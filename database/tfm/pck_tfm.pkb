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
            options AS "options",
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
            r.started AS "started",
            r.duration AS "duration",
            r.coins AS "coins"
        FROM tfm_runs r
        JOIN tfm_flows f ON f.ufid = r.ufid
        WHERE uuid = v_uuid
        AND (p_search IS NULL OR name LIKE '%' || TRIM(UPPER(p_search)) || '%')
        ORDER BY name
        OFFSET p_offset ROWS FETCH NEXT p_limit ROWS ONLY;

    END;

    PROCEDURE get_balance( -- Get balance for the Flow Master
        r_balance OUT SYS_REFCURSOR -- List of balance [{period: H, used: 0.30, limit: 1.00, balance: 0.70}]
    ) AS
        v_uuid CHAR(32 CHAR) := pck_api_auth.uuid;
    BEGIN 
        
        OPEN r_balance FOR
        SELECT
            b.period AS "period",
            b.used AS "used",
            b.limit AS "limit",
            b.balance AS "balance"
        FROM tfm_balance b
        WHERE uuid = v_uuid;

    END;   

END;
/