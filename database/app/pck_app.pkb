CREATE OR REPLACE PACKAGE BODY pck_app AS

    PROCEDURE get_version(
        r_version OUT VARCHAR2
    ) AS
    BEGIN
        pck_api_settings.read('APP_VERSION', r_version);
    END;

    PROCEDURE user(
        p_uuid APP_USERS.UUID%TYPE,
        r_user OUT SYS_REFCURSOR
    ) AS
        v_privileges CLOB;
    BEGIN

        SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'role' VALUE r.role,
                    'permission' VALUE p.permission,
                    'validfrom' VALUE p.valid_from,
                    'validto' VALUE p.valid_to
                )
            )
        INTO v_privileges
        FROM app_permissions p
        JOIN app_roles r ON r.id = p.id_role
        JOIN app_users u ON u.id = p.id_user
        WHERE u.uuid = p_uuid;

        OPEN r_user FOR
        SELECT
            u.uuid AS "uuid",
            u.username AS "username",
            u.fullname AS "fullname",
            TO_CHAR(u.created, 'YYYY-MM-DD HH24:MI') AS "created",
            v_privileges AS "{}privileges"
        FROM
            app_users u
        WHERE
            u.uuid = p_uuid;
    END;

    PROCEDURE post_login(
        p_username APP_USERS.USERNAME%TYPE,
        p_password APP_USERS.PASSWORD%TYPE,
        r_access_token OUT APP_TOKENS.TOKEN%TYPE,
        r_refresh_token OUT APP_TOKENS.TOKEN%TYPE,
        r_user OUT SYS_REFCURSOR
    ) AS
        v_uuid app_users.uuid%TYPE := pck_api_auth.auth(p_username, p_password);
    BEGIN
        IF (v_uuid IS NULL) THEN
            pck_api_audit.wrn('Login error', pck_api_audit.mrg('username', p_username, 'password', '********'),v_uuid);
            pck_api_auth.http_401('login.error.invalidUsernameOrPassword');
            RETURN;
        END IF;

        pck_api_audit.inf('Login success', pck_api_audit.mrg('username', p_username, 'password', '********'), v_uuid);
        pck_api_auth.reset(v_uuid, 'A');
        pck_api_auth.reset(v_uuid, 'R');
        r_access_token := pck_api_auth.token(v_uuid, 'A');
        r_refresh_token := pck_api_auth.token(v_uuid, 'R');

        user(v_uuid, r_user);

     EXCEPTION
        WHEN OTHERS THEN
            r_access_token := NULL;
            r_refresh_token := NULL;
            pck_api_audit.err('Login error', pck_api_audit.mrg('username', p_username, 'password', '********'), v_uuid);
    END;

    PROCEDURE post_logout
    AS
        v_uuid app_users.uuid%TYPE := COALESCE(pck_api_auth.uuid, pck_api_auth.refresh('refresh_token'));
    BEGIN
        pck_api_auth.reset(v_uuid, 'A');
        pck_api_auth.reset(v_uuid, 'R');
        IF v_uuid IS NOT NULL THEN
            pck_api_audit.inf('Logout success', '',v_uuid);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            pck_api_audit.err('Logout error', NULL, v_uuid);
    END;

    PROCEDURE post_refresh(
        r_access_token OUT APP_TOKENS.TOKEN%TYPE,
        r_refresh_token OUT APP_TOKENS.TOKEN%TYPE
    ) AS
        v_uuid app_users.uuid%TYPE := pck_api_auth.refresh('refresh_token');
    BEGIN

        IF v_uuid IS NULL THEN
            pck_api_auth.http_401;
        ELSE
            pck_api_auth.reset(v_uuid, 'A');
            pck_api_auth.reset(v_uuid, 'R');
            r_access_token := pck_api_auth.token(v_uuid, 'A');
            r_refresh_token := pck_api_auth.token(v_uuid, 'R');
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            r_access_token := NULL;
            r_refresh_token := NULL;
            pck_api_audit.err('Refresh error', NULL, v_uuid);
    END;

    PROCEDURE get_heartbeat
    AS
        v_uuid app_users.uuid%TYPE := pck_api_auth.uuid;
    BEGIN
        if v_uuid IS NULL THEN pck_api_auth.http_401; END IF;
    EXCEPTION
        WHEN OTHERS THEN
            pck_api_audit.err('Heartbeat error', NULL, v_uuid);
    END;

    PROCEDURE post_audit(
        p_data CLOB
    ) AS
        v_uuid app_users.uuid%TYPE := pck_api_auth.uuid;
    BEGIN
        IF v_uuid IS NULL THEN
            pck_api_audit.wrn('Audit error', 'User not authenticated');
        END IF;

        pck_api_audit.audit(p_data, v_uuid);

    END;

    PROCEDURE post_signup( 
        p_username APP_USERS.USERNAME%TYPE, 
        p_password APP_USERS.PASSWORD%TYPE, 
        p_fullname APP_USERS.FULLNAME%TYPE, 
        r_access_token OUT APP_TOKENS.TOKEN%TYPE, 
        r_refresh_token OUT APP_TOKENS.TOKEN%TYPE, 
        r_user OUT SYS_REFCURSOR,
        r_error OUT VARCHAR2 
    ) AS
        v_uuid APP_USERS.UUID%TYPE;
        v_password app_users.password%TYPE := pck_api_auth.pwd(p_password);
        v_id_email APP_EMAILS.ID%TYPE;
        v_confirm_token APP_TOKENS.TOKEN%TYPE;
    BEGIN

       BEGIN

            SELECT uuid 
            INTO v_uuid
            FROM app_users
            WHERE username = UPPER(TRIM(p_username));

        EXCEPTION

            WHEN NO_DATA_FOUND THEN
                NULL;

        END;
        
        IF NOT REGEXP_LIKE (p_username,'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN

            r_error := 'Username must be a valid email address';
            pck_api_audit.wrn('Signup failed - invalid email address', pck_api_audit.mrg('username', p_username, 'fullname', p_fullname, 'password', '********'), v_uuid);

        ELSIF p_username IS NULL OR p_password IS NULL OR p_fullname IS NULL THEN

            r_error := 'Missing parameters';       
            pck_api_audit.wrn('Signup failed - missing parameters', pck_api_audit.mrg('username', p_username, 'fullname', p_fullname, 'password', '********'), v_uuid);

        ELSIF v_uuid IS NOT NULL THEN

            r_error := 'Such username already exists'; 
            pck_api_audit.wrn('Signup failed - user already exists', pck_api_audit.mrg('username', p_username, 'fullname', p_fullname, 'password', '********'), v_uuid);
            
        ELSE -- success
        
            INSERT INTO app_users (id, status, username, password, fullname, accessed)
            VALUES (
                seq_app_users.NEXTVAL, 
                'N', 
                UPPER(TRIM(p_username)), 
                v_password, 
                p_fullname,
                SYSTIMESTAMP
            ) RETURNING uuid INTO v_uuid;
            
            COMMIT;

            pck_api_auth.reset(v_uuid, 'A');
            pck_api_auth.reset(v_uuid, 'R');
            r_access_token := pck_api_auth.token(v_uuid, 'A');
            r_refresh_token := pck_api_auth.token(v_uuid, 'R');
            
            user(v_uuid, r_user);

            v_confirm_token := pck_api_auth.token(v_uuid, 'E');
            
            pck_api_emails.mail(v_id_email,TRIM(p_username),p_fullname,'Confirm email address!','<h1>Confirm email!</h1><p>Please, confirm your email address by pressing this <a href="' || pck_api_settings.read('APP_DOMAIN') || '/confirm-email/' || v_confirm_token || '">link</a></p>');            
            BEGIN
                pck_api_emails.send(v_id_email);
            EXCEPTION 
                WHEN OTHERS THEN
                    NULL;
            END;   

            pck_api_audit.inf('Signup successful', pck_api_audit.mrg('username', p_username, 'fullname', p_fullname, 'password', '********'), v_uuid);

        END IF;                

     EXCEPTION
        WHEN OTHERS THEN
            r_error := 'Internal error';
            r_access_token := NULL;
            r_refresh_token := NULL;
            pck_api_audit.err('Signup error', pck_api_audit.mrg('username', p_username, 'fullname', p_fullname, 'password', '********'), v_uuid);
    END;  

    PROCEDURE post_confirmemail( 
        p_confirmtoken APP_TOKENS.TOKEN%TYPE, 
        r_error OUT VARCHAR2 
    ) AS
        v_uuid APP_USERS.UUID%TYPE;
    BEGIN

        BEGIN
            SELECT uuid
            INTO  v_uuid
            FROM app_users
            WHERE id IN (
                SELECT id_user  
                FROM app_tokens
                WHERE token = p_confirmtoken
                AND expiration > SYSTIMESTAMP
            );
        EXCEPTION
            WHEN NO_DATA_FOUND THEN r_error := 'Invalid token';
        END;
        
        IF r_error IS NOT NULL THEN
        
            pck_api_audit.wrn('Confirm emmail failed', pck_api_audit.mrg('confirmtoken', '********'), v_uuid);
        
        ELSE

            UPDATE app_users
            SET status = 'A'
            WHERE uuid = v_uuid;
        
            COMMIT;

            pck_api_audit.inf('Confirm email success', pck_api_audit.mrg('confirmtoken', '********'), v_uuid);
        
        END IF;    
    
    EXCEPTION
        WHEN OTHERS THEN
            r_error := 'Internal error';
            pck_api_audit.err('Confirm email error', pck_api_audit.mrg('confirmtoken', '********'), v_uuid);
    END;

   PROCEDURE post_recoverpassword( 
        p_username APP_USERS.USERNAME%TYPE, 
        r_error OUT VARCHAR2 
    ) AS
        v_id_email APP_EMAILS.ID%TYPE;
        v_uuid APP_USERS.UUID%TYPE;
        v_fullname APP_USERS.FULLNAME%TYPE;
        v_password_token APP_TOKENS.TOKEN%TYPE;
    BEGIN

        UPDATE app_users 
        SET status = 'N' 
        WHERE username = TRIM(UPPER(p_username))
        RETURNING uuid, fullname INTO v_uuid, v_fullname; 

        IF SQL%ROWCOUNT = 1 THEN

           v_password_token := pck_api_auth.token(v_uuid, 'R');
    
            pck_api_emails.mail(v_id_email,TRIM(p_username),v_fullname,'Recover password!','<h1>Recover password!</h1><p>Recover your password address by pressing this <a href="' || pck_api_settings.read('APP_DOMAIN') || '/reset-password/' || v_password_token || '">link</a></p>');
            BEGIN
                pck_api_emails.send(v_id_email); 
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;  
            END;

            pck_api_audit.inf('Recover password request successful', pck_api_audit.mrg('username', p_username), v_uuid);             
        
        ELSE 
        
            r_error := 'Wrong username';
            pck_api_audit.wrn('Recover password request failed', pck_api_audit.mrg('username', p_username), v_uuid);
    
        END IF;
        
     EXCEPTION
        WHEN OTHERS THEN
            r_error := 'Internal error';
            pck_api_audit.err('Recover password request error', pck_api_audit.mrg('username', p_username), v_uuid);
    END;    
    
    PROCEDURE post_resetpassword( 
        p_username APP_USERS.USERNAME%TYPE, 
        p_password APP_USERS.PASSWORD%TYPE, 
        p_recovertoken APP_TOKENS.TOKEN%TYPE, 
        r_access_token OUT VARCHAR2, 
        r_refresh_token OUT VARCHAR2, 
        r_user OUT SYS_REFCURSOR,
        r_error OUT VARCHAR2 
    ) AS
        v_id_user APP_USERS.ID%TYPE;
        v_uuid APP_USERS.UUID%TYPE;
        c_salt VARCHAR2(32 CHAR) := DBMS_RANDOM.STRING('X', 32);
        v_password app_users.password%TYPE := c_salt || DBMS_CRYPTO.HASH(UTL_RAW.CAST_TO_RAW(TRIM(p_password) || c_salt),4);
    BEGIN

        BEGIN
            SELECT id, uuid
            INTO v_id_user, v_uuid
            FROM app_users
            WHERE id IN (
                SELECT id_user
                FROM app_tokens
                WHERE token = p_recovertoken
                AND id_token_type = 'R'
                AND expiration > SYSTIMESTAMP
            );
        EXCEPTION
            WHEN NO_DATA_FOUND THEN r_error := 'Invalid token';
        END;    

        IF r_error IS NOT NULL THEN

            pck_api_audit.wrn('Reset password', pck_api_audit.mrg('username', p_username,'password','********','recover_token','********'), v_uuid);

        ELSE -- valid token

            UPDATE app_users SET 
                password = v_password,
                attempts = 0,
                status = 'A',
                accessed = SYSTIMESTAMP
            WHERE id = v_id_user;
        
            COMMIT;

            pck_api_auth.reset(v_uuid, 'A');
            pck_api_auth.reset(v_uuid, 'R');
            r_access_token := pck_api_auth.token(v_uuid, 'A');
            r_refresh_token := pck_api_auth.token(v_uuid, 'R');

            user(v_uuid, r_user);

            pck_api_audit.inf('Reset password successful', pck_api_audit.mrg('username', p_username,'password','********','recoverytoken','********'), v_uuid);
        
        END IF; 
    
     EXCEPTION
        WHEN OTHERS THEN
            r_error := 'Internal error';
            r_access_token := NULL;
            r_refresh_token := NULL;
            pck_api_audit.err('Reset password error', pck_api_audit.mrg('username', p_username,'password','********','recoverytoken','********'), v_uuid);
    END;

END;
/