CREATE OR REPLACE PACKAGE BODY pck_tfm IS 


    PROCEDURE get_keys( -- Get keys for the Flow Master
        p_search VARCHAR2 DEFAULT NULL, -- Search term
        p_offset PLS_INTEGER DEFAULT 0, -- Offset for pagination
        p_limit PLS_INTEGER DEFAULT 10, -- Limit for pagination
        r_keys OUT SYS_REFCURSOR -- List of keys [{ukid: guid, name: name, description: description}]
    ) AS

    BEGIN

        IF (pck_api_auth.priv(NULL, 'ADMIN') IS NULL) THEN
            pck_api_auth.http_401;
            RETURN;
        END IF;

        OPEN r_keys FOR
        SELECT
            ukid AS "ukid",
            name AS "name",
            description AS "description"
        FROM tfm_keys
        WHERE (p_search IS NULL OR name LIKE '%' || TRIM(UPPER(p_search)) || '%')
        ORDER BY name
        OFFSET p_offset ROWS FETCH NEXT p_limit ROWS ONLY;

    END;

    PROCEDURE post_key(
        p_ukid VARCHAR2, -- Unique key identifier
        p_name VARCHAR2, -- Name of the key
        p_key VARCHAR2, -- Value of the key
        p_description VARCHAR2, -- Description of the key
        r_errors OUT SYS_REFCURSOR -- List of errors [{name: name, message: message}]

    ) AS
        c_required CONSTANT VARCHAR2(2000 CHAR) := '{"rules":[{"type":"required","params":null,"message":"Value is required"}]}';
    BEGIN

        IF (pck_api_auth.priv(NULL, 'ADMIN') IS NULL) THEN
            pck_api_auth.http_401;
            RETURN;
        END IF;

        IF pck_api_validate.validate('name', p_name, c_required, r_errors) > 0 THEN RETURN; END IF;
        IF pck_api_validate.validate('key', p_key, c_required, r_errors) > 0 THEN RETURN; END IF;

        UPDATE tfm_keys SET 
            name = p_name, 
            key = p_key, 
            description = p_description
        WHERE ukid = p_ukid;

        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO tfm_keys (ukid, name, key, description)
            VALUES (LOWER(SYS_GUID()), p_name, p_key, p_description);
        END IF; 

        COMMIT;

    END;

    PROCEDURE get_agents( -- Get agents for the Flow Master
        p_search VARCHAR2 DEFAULT NULL, -- Search term
        p_offset PLS_INTEGER DEFAULT 0, -- Offset for pagination
        p_limit PLS_INTEGER DEFAULT 10, -- Limit for pagination
        r_agents OUT SYS_REFCURSOR -- List of agents [{uaid: guid, name: name, description: description, options: {}, coins: 1.00}]
    ) AS
    BEGIN

        IF (pck_api_auth.priv(NULL, 'ADMIN') IS NULL) THEN
            pck_api_auth.http_401;
            RETURN;
        END IF;

        OPEN r_agents FOR
        SELECT
            uaid AS "uaid",
            name AS "name",
            description AS "description",
            options AS "options",
            coins AS "coins"
        FROM tfm_agents
        WHERE (p_search IS NULL OR name LIKE '%' || TRIM(UPPER(p_search)) || '%')
        ORDER BY name
        OFFSET p_offset ROWS FETCH NEXT p_limit ROWS ONLY;

    END;

    PROCEDURE get_flows( -- Get flows for the Flow Master
        p_search VARCHAR2 DEFAULT NULL, -- Search term
        p_offset PLS_INTEGER DEFAULT 0, -- Offset for pagination
        p_limit PLS_INTEGER DEFAULT 10, -- Limit for pagination
        r_flows OUT SYS_REFCURSOR -- List of flows [{ufid: guid, name: name, description: description, options: {}, coins: 1.00}]
    ) AS
        v_uuid CHAR(32 CHAR) := pck_api_auth.uuid;
    BEGIN

        OPEN r_flows FOR
        SELECT
            ufid AS "ufid",
            name AS "name",
            description AS "description",
            options AS "{}options",
            coins AS "coins"
        FROM tfm_flows
        WHERE (p_search IS NULL OR name LIKE '%' || TRIM(UPPER(p_search)) || '%')
        ORDER BY name
        OFFSET p_offset ROWS FETCH NEXT p_limit ROWS ONLY;

    END;

    PROCEDURE get_runs( -- Get runs for the Flow Master
        p_search VARCHAR2 DEFAULT NULL, -- Search term
        p_offset PLS_INTEGER DEFAULT 0, -- Offset for pagination
        p_limit PLS_INTEGER DEFAULT 10, -- Limit for pagination
        r_runs OUT SYS_REFCURSOR -- List of runs [{urid: guid, name: name, started: 20251231T1612, duration: 1m 20s, coins: 1.00}]
    ) AS
        v_uuid CHAR(32 CHAR) := pck_api_auth.uuid;
    BEGIN
        OPEN r_runs FOR
        SELECT
            r.urid AS "urid",
            f.name AS "name",
            TO_CHAR(r.created, 'YYYY-MM-DD HH24:MI:SS') AS "created",
            TO_CHAR(r.started, 'YYYY-MM-DD HH24:MI:SS') AS "started",
            r.duration AS "duration",
            r.coins AS "coins",
            r.results AS "results",
            r.status AS "status"
        FROM tfm_runs r
        JOIN tfm_flows f ON f.ufid = r.ufid
        WHERE (v_uuid IS NULL OR r.uuid = v_uuid)
        AND (p_search IS NULL OR name LIKE '%' || TRIM(UPPER(p_search)) || '%')
        ORDER BY created DESC
        OFFSET p_offset ROWS FETCH NEXT p_limit ROWS ONLY;

    END;

    PROCEDURE put_run(
        p_ufid VARCHAR2, -- Unique run identifier
        p_options CLOB, -- Options
        r_errors OUT SYS_REFCURSOR, -- List of errors [{name: name, message: message}]
        r_urid OUT VARCHAR2 -- Unique run identifier
    ) AS
        v_uuid CHAR(32 CHAR) := pck_api_auth.uuid;
        v_coins NUMBER;
        v_remaining NUMBER;
    BEGIN

        SELECT MIN(remaining) INTO v_remaining FROM tfm_balance 
        WHERE (v_uuid IS NULL OR uuid = v_uuid);

        IF (v_remaining IS NULL) THEN

            INSERT INTO tfm_balance (uuid, period, used, limit, remaining)
            SELECT 
                v_uuid,
                period,
                0 AS used,
                limit,
                limit
            FROM tfm_limits
            WHERE uuid = v_uuid;

            IF SQL%ROWCOUNT = 0 THEN
                INSERT INTO tfm_balance (uuid, period, used, limit, remaining)
                SELECT 
                    v_uuid,
                    period,
                    0 AS used,
                    limit,
                    limit
                FROM tfm_limits
                WHERE uuid IS NULL;
            END IF;    

        END IF;      

        SELECT coins INTO v_coins FROM tfm_flows WHERE ufid = p_ufid;

        IF v_coins > v_remaining THEN 
            OPEN r_errors FOR
            SELECT
                'limit' AS "name",
                'not.enough.coins.to.run.this.task' AS "message"
            FROM dual;
            RETURN;
        END IF;

        INSERT INTO tfm_runs (urid, ufid, uuid, options, coins)
        VALUES (LOWER(SYS_GUID()), p_ufid, v_uuid, p_options, v_coins)
        RETURNING urid INTO r_urid;

        UPDATE tfm_balance SET used = used + v_coins, remaining = remaining - v_coins 
        WHERE (v_uuid IS NULL OR uuid = v_uuid);
   
        COMMIT;

    END;

    PROCEDURE get_balance( -- Get balance for the Flow Master
        r_balance OUT SYS_REFCURSOR -- List of balance [{period: H, used: 0.30, limit: 1.00, balance: 0.70}]
    ) AS
        v_uuid CHAR(32 CHAR) := pck_api_auth.uuid;
    BEGIN 
        
        OPEN r_balance FOR
        SELECT
            period AS "period",
            used AS "used",
            limit AS "limit",
            remaining AS "remaining"
        FROM tfm_balance
       WHERE (v_uuid IS NULL OR uuid = v_uuid);

    END;

    PROCEDURE job_tfm IS
        TYPE t_cache IS TABLE OF CLOB INDEX BY VARCHAR2(200 CHAR); 
        v_cache t_cache;

        v_api_keys t_cache;

        v_json JSON_OBJECT_T;
        v_keys JSON_KEY_LIST;

        v_step JSON_OBJECT_T;
        v_step_agent VARCHAR2(200 CHAR);
        v_step_params JSON_OBJECT_T;
        v_step_keys JSON_KEY_LIST;

        v_agent_method CLOB;
        v_agent_api_keys CLOB;
        v_agent_const CLOB;
        v_agent_params CLOB;
        v_agent_result CLOB;
        v_agent_sql CLOB;
        v_agent_json JSON_OBJECT_T;
        v_agent_keys JSON_KEY_LIST;

        v_key VARCHAR2(200 CHAR);
        v_value CLOB;
    BEGIN

        FOR k IN (
            SELECT 
                name,
                key
            FROM tfm_keys
        ) LOOP
            v_api_keys(k.name) := k.key;
        END LOOP;

        FOR r IN (
            SELECT 
                urid,
                JSON_QUERY(options, '$.params') AS params,
                JSON_QUERY(options, '$.steps') AS steps,
                JSON_VALUE(options, '$.report') AS report
            FROM tfm_runs
            WHERE status = 'P'
            FETCH NEXT 10 ROWS ONLY   
        ) LOOP

            BEGIN

                UPDATE tfm_runs SET status = 'R', started = SYSTIMESTAMP WHERE urid = r.urid;
                COMMIT;

                -- get params and write to cache
                IF (r.params IS NOT NULL) THEN
                    v_json := JSON_OBJECT_T.parse(r.params);
                    v_keys := v_json.get_keys;
                    FOR i IN 1 .. v_keys.count LOOP
                        v_key := v_keys(i);
                        v_value := v_json.get_string(v_keys(i));
                        v_cache(v_key) := v_value;
                    END LOOP;
                END IF;

                -- iterate over the steps
                v_json := JSON_OBJECT_T.parse(r.steps);
                v_keys := v_json.get_keys;
                FOR i IN 1 .. v_keys.count LOOP
                    v_step := JSON_OBJECT_T(v_json.get(v_keys(i)));

                    -- get agent name
                    v_step_agent := v_step.get_string('agent');
                    
                    -- get step params and write to cache
                    v_step_params := JSON_OBJECT_T(v_step.get('params'));
                    v_step_keys := v_step_params.get_keys;
                    FOR j IN 1 .. v_step_keys.count LOOP
                        v_key := v_step_keys(j);
                        v_value := v_step_params.get_string(v_step_keys(j));
                        v_cache(v_key) := v_value;
                    END LOOP;
                    
                    -- get step agent details
                    SELECT 
                        JSON_VALUE(options, '$.method') AS method,
                        JSON_QUERY(options, '$.keys') AS keys,
                        JSON_QUERY(options, '$.const') AS const,
                        JSON_QUERY(options, '$.params') AS params,
                        JSON_QUERY(options, '$.result') AS result
                    INTO v_agent_method, v_agent_api_keys, v_agent_const, v_agent_params, v_agent_result
                    FROM tfm_agents 
                    WHERE name = v_step_agent;

                    -- run agent
                    v_agent_sql := 'BEGIN ' || v_agent_method || '(';

                    v_agent_json := JSON_OBJECT_T.parse(v_agent_api_keys);
                    v_agent_keys := v_agent_json.get_keys;
                    FOR j IN 1 .. v_agent_keys.count LOOP
                        v_value := v_agent_json.get_string(v_agent_keys(j));
                        v_value := v_api_keys(v_value);
                        v_agent_sql := v_agent_sql || 'p_' || v_agent_keys(j) || ' => ''' || v_value || ''', ';
                    END LOOP;

                    v_agent_json := JSON_OBJECT_T.parse(v_agent_const);
                    v_agent_keys := v_agent_json.get_keys;
                    FOR j IN 1 .. v_agent_keys.count LOOP
                        v_value := v_agent_json.get_string(v_agent_keys(j));
                        v_agent_sql := v_agent_sql || 'p_' || v_agent_keys(j) || ' => ''' || v_value || ''', ';
                    END LOOP;

                    v_agent_json := JSON_OBJECT_T.parse(v_agent_params);
                    v_agent_keys := v_agent_json.get_keys;
                    FOR j IN 1 .. v_agent_keys.count LOOP
                        v_key := v_agent_keys(j);
                        IF v_cache.EXISTS(v_key) THEN
                            v_value := v_cache(v_key);

                            DECLARE
                                k VARCHAR2(30 CHAR);
                            BEGIN
                                k := v_cache.FIRST;
                                WHILE k IS NOT NULL LOOP
                                    v_value := REPLACE(v_value, '{{ ' || k || ' }}', v_cache(k));
                                    k := v_cache.NEXT(k);
                                END LOOP;
                            END;

                            v_agent_sql := v_agent_sql || 'p_' || v_key || ' => ''' || v_value || ''', ';
                        END IF;
                    END LOOP;

                    v_agent_json := JSON_OBJECT_T.parse(v_agent_result);
                    v_agent_keys := v_agent_json.get_keys;
                    FOR j IN 1 .. v_agent_keys.count LOOP
                        v_agent_sql := v_agent_sql || 'r_' || v_agent_keys(j) || ' => :r_' || v_agent_keys(j) || ', ';
                    END LOOP;

                    v_agent_sql := RTRIM(v_agent_sql, ', ') || '); END;';

                    v_cache('DEBUG SQL') := v_agent_sql;

                    EXECUTE IMMEDIATE v_agent_sql USING OUT v_value;

                    v_cache(v_keys(i)) := v_value; 

                END LOOP;


                v_value := r.report;
                DECLARE
                    k VARCHAR2(30 CHAR);
                BEGIN
                    k := v_cache.FIRST;
                    WHILE k IS NOT NULL LOOP
                        v_value := REPLACE(v_value, '{{ ' || k || ' }}', v_cache(k));
                        k := v_cache.NEXT(k);
                    END LOOP;
                END;

                UPDATE tfm_runs SET 
                    status = 'C', 
                    results = v_value,
                    finished = SYSTIMESTAMP,
                    duration = (CAST(SYSTIMESTAMP AS DATE) - CAST(started AS DATE)) * 86400
                WHERE urid = r.urid;
                COMMIT;

            EXCEPTION
                WHEN OTHERS THEN
                    UPDATE tfm_runs SET 
                        status = 'E', 
                        errors =  SUBSTR(dbms_utility.format_error_backtrace, 1, 2000),
                        finished = SYSTIMESTAMP,
                        duration = (CAST(SYSTIMESTAMP AS DATE) - CAST(started AS DATE)) * 86400
                    WHERE urid = r.urid;
                    COMMIT; 
            END;           

        END LOOP;

    END;

END;
/