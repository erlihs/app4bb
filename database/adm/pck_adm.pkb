CREATE OR REPLACE PACKAGE BODY pck_adm AS 

    PROCEDURE get_status (
        r_status OUT SYS_REFCURSOR
    ) AS 
    BEGIN
        IF pck_api_auth.role(NULL, 'ADMIN') IS NULL THEN  pck_api_auth.http_401; RETURN; END IF;

        OPEN r_status FOR
        SELECT 
            'Total users' AS "status",
            TO_CHAR(COUNT(id)) AS "value",
            '/admin#users' AS "to",
            'I' AS "severity"
        FROM app_users
        UNION ALL
        SELECT 
            'Active users' AS "status",
            TO_CHAR(COUNT(id)) AS "value",
            '/admin#users' AS "to",
            'I' AS "severity"
        FROM app_users 
        WHERE status = 'A'
        UNION ALL
        SELECT 
            'Active user tokens' AS "status",
            TO_CHAR(COUNT(token)) AS "value",
            NULL AS "to",
            'I' AS "severity"
        FROM app_tokens 
        WHERE id_token_type = 'A'
        AND expiration > SYSTIMESTAMP
        UNION ALL
        SELECT 
            'Emails in queue' AS "status",
            TO_CHAR(COUNT(id)) AS "value",
            NULL AS "to",
            'I' AS "severity"
        FROM app_emails PARTITION (emails_active) 
        UNION ALL
        SELECT 
            'Emails sent' AS "status",
            TO_CHAR(COUNT(id)) AS "value",
            NULL AS "to",
            'I' AS "severity"
        FROM app_emails PARTITION (emails_archive)
        WHERE status = 'S' 
        UNION ALL
        SELECT 
            'Unsent emails' AS "status",
            TO_CHAR(COUNT(id)) AS "value",
            NULL AS "to",
            CASE WHEN COUNT(id) > 0 THEN 'W' ELSE 'I' END AS "severity"
        FROM app_emails PARTITION (emails_archive)
        WHERE status = 'E' 
        UNION ALL
        SELECT
            'Storage' AS "status",
            TO_CHAR(COUNT(id)) || ' (' || TO_CHAR(COALESCE(SUM(file_size),0)) || ' bytes)' AS "value",
            NULL AS "to",
            'I' AS "severity"
        FROM app_storage
        UNION ALL
        SELECT
            'Jobs started within last hour' AS "status",
            TO_CHAR(COUNT(log_id)) AS "value",
            '/admin#jobs' AS "to",
            'I' AS "severity"
        FROM user_scheduler_job_run_details
        WHERE actual_start_date >= SYSDATE - 1 / 24    
        ;

    END;

    PROCEDURE get_users (
        p_search VARCHAR2 DEFAULT NULL,
        p_offset NUMBER DEFAULT 0,
        p_limit NUMBER DEFAULT 10,
        r_items OUT SYS_REFCURSOR
    ) AS
    BEGIN

        IF (pck_api_auth.role(NULL, 'ADMIN') IS NULL) THEN
            pck_api_auth.http_401;
            RETURN;
        END IF;

        OPEN r_items FOR
        SELECT
            uuid,
            username,
            fullname,
            status,
            TO_CHAR(created, 'YYYY-MM-DD HH24:MI') AS created,
            TO_CHAR(accessed, 'YYYY-MM-DD HH24:MI') AS accessed
        FROM app_users
        WHERE (p_search IS NULL OR username LIKE '%' || p_search || '%')
        ORDER BY created DESC
        OFFSET p_offset ROWS FETCH NEXT p_limit ROWS ONLY;

    END;

    PROCEDURE post_user_lock ( 
        p_uuid app_users.uuid%TYPE 
    ) AS
    BEGIN
        IF (pck_api_auth.role(NULL, 'ADMIN') IS NULL) THEN
            pck_api_auth.http_401;
            RETURN;
        END IF;

        UPDATE app_users
        SET status = 'D'
        WHERE uuid = p_uuid;

        pck_api_audit.inf('User account locked', pck_api_audit.mrg('uuid', p_uuid), pck_api_auth.uuid);

        COMMIT;

    END;

    PROCEDURE post_user_unlock ( 
        p_uuid app_users.uuid%TYPE 
    ) AS
        v_username app_users.username%TYPE;
        v_fullname app_users.fullname%TYPE;
        v_id_email APP_EMAILS.ID%TYPE;
        v_confirm_token APP_TOKENS.TOKEN%TYPE;
    BEGIN
        IF (pck_api_auth.role(NULL, 'ADMIN') IS NULL) THEN
            pck_api_auth.http_401;
            RETURN;
        END IF;

        UPDATE app_users
        SET status = 'N'
        WHERE uuid = p_uuid
        RETURNING username, fullname INTO v_username, v_fullname;

        v_confirm_token := pck_api_auth.token(p_uuid, 'E');
        
        pck_api_emails.mail(v_id_email,TRIM(v_username),v_fullname,'Confirm email address!','<h1>Confirm email!</h1><p>Please, confirm your email address by pressing this <a href="' || pck_api_settings.read('APP_DOMAIN') || '/confirm-email/' || v_confirm_token || '">link</a></p>');            
        BEGIN
            pck_api_emails.send(v_id_email);
        EXCEPTION 
            WHEN OTHERS THEN
                NULL;
        END;   

        pck_api_audit.inf('User account unlocked', pck_api_audit.mrg('uuid', p_uuid), pck_api_auth.uuid);

        COMMIT;

    END;

    PROCEDURE get_audit ( 
        p_search VARCHAR2 DEFAULT NULL, 
        p_offset NUMBER DEFAULT 0, 
        p_limit NUMBER DEFAULT 10,
        r_items OUT SYS_REFCURSOR 
    ) AS
    BEGIN
        
        IF (pck_api_auth.priv(NULL, 'ADMIN') IS NULL) THEN
            pck_api_auth.http_401;
            RETURN;
        END IF;

        OPEN r_items FOR
        SELECT
            a.id,
            a.uuid,
            u.username,
            a.action,
            a.details,
            a.severity,
            TO_CHAR(a.created, 'YYYY-MM-DD HH24:MI:SS') AS created,
            a.stack,
            a.agent,
            a.ip
        FROM app_audit a
        LEFT JOIN app_users u ON u.uuid = a.uuid
        WHERE (p_search IS NULL OR a.action LIKE '%' || p_search || '%')
        ORDER BY a.created DESC
        OFFSET p_offset ROWS FETCH NEXT p_limit ROWS ONLY;

    END;

    PROCEDURE get_settings (
        p_search VARCHAR2 DEFAULT NULL,
        p_offset NUMBER DEFAULT 0,
        p_limit NUMBER DEFAULT 10,
        r_items OUT SYS_REFCURSOR
    ) AS
    BEGIN

        IF (pck_api_auth.role(NULL, 'ADMIN') IS NULL) THEN
            pck_api_auth.http_401;
            RETURN;
        END IF;

        OPEN r_items FOR
        SELECT
            id,
            description,
            content,
            options AS "{}options"
        FROM app_settings
        WHERE (p_search IS NULL OR id LIKE '%' || TRIM(UPPER(p_search)) || '%')
        ORDER BY id
        OFFSET p_offset ROWS FETCH NEXT p_limit ROWS ONLY;

    END;

    PROCEDURE post_setting(
        p_id app_settings.id%TYPE,
        p_content app_settings.content%TYPE,
        r_errors OUT SYS_REFCURSOR
    ) AS
        v_options VARCHAR2(2000 CHAR);    
        v_cnt PLS_INTEGER;
    BEGIN

        IF (pck_api_auth.role(NULL, 'ADMIN') IS NULL) THEN
            pck_api_auth.http_401;
            RETURN;
        END IF;

        SELECT options INTO v_options FROM app_settings WHERE id = p_id;
        IF pck_api_validate.validate('content', p_content, v_options, r_errors) > 0 THEN
            RETURN;
        END IF; 

        UPDATE app_settings
        SET content = p_content
        WHERE id = p_id;

        pck_api_audit.inf('Settings updated', pck_api_audit.mrg('id', p_id), pck_api_auth.uuid);

        COMMIT;

    END;

    PROCEDURE get_jobs (
        p_search VARCHAR2 DEFAULT NULL,
        p_offset NUMBER DEFAULT 0,
        p_limit NUMBER DEFAULT 10,
        r_items OUT SYS_REFCURSOR
    ) AS
    BEGIN
        IF (pck_api_auth.role(NULL, 'ADMIN') IS NULL) THEN
            pck_api_auth.http_401;
            RETURN;
        END IF;

        OPEN r_items FOR
        SELECT 
            j.job_name AS "name",
            (SELECT LISTAGG(s.repeat_interval, ', ') FROM user_scheduler_schedules s WHERE s.schedule_name = j.schedule_name) AS "schedule",
            TO_CHAR(last_start_date, 'YYYY-MM-DD HH24:MI:SS') AS "start",
            TO_CHAR(last_run_duration) AS "duration",
            j.comments AS "comments",
            j.enabled AS "enabled"
        FROM user_scheduler_jobs j
        WHERE (p_search IS NULL OR j.job_name LIKE '%' || p_search || '%')
        ORDER BY j.job_name
        OFFSET p_offset ROWS FETCH NEXT p_limit ROWS ONLY;

    END;

    PROCEDURE get_jobs_history (
        p_search VARCHAR2 DEFAULT NULL,
        p_offset NUMBER DEFAULT 0,
        p_limit NUMBER DEFAULT 10,
        r_items OUT SYS_REFCURSOR
    ) AS
    BEGIN
        IF (pck_api_auth.role(NULL, 'ADMIN') IS NULL) THEN
            pck_api_auth.http_401;
            RETURN;
        END IF;

        OPEN r_items FOR
        SELECT 
            job_name AS "name",
            TO_CHAR(actual_start_date, 'YYYY-MM-DD HH24:MI:SS') AS "start",
            TO_CHAR(run_duration) AS "duration",
            status AS "status",
            TRIM(output || ' ' || errors) AS "output" 
        FROM user_scheduler_job_run_details
        WHERE (p_search IS NULL OR job_name LIKE '%' || p_search || '%')
        ORDER BY actual_start_date DESC
        OFFSET p_offset ROWS FETCH NEXT p_limit ROWS ONLY;

    END;

    PROCEDURE post_job_run (
        p_name VARCHAR2
    ) AS
    BEGIN
        IF (pck_api_auth.role(NULL, 'ADMIN') IS NULL) THEN
            pck_api_auth.http_401;
            RETURN;
        END IF;

        pck_api_jobs.run(UPPER(TRIM(REPLACE(p_name,'_JOB',''))));

    END;


END;
/
