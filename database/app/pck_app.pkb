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
            pck_api_auth.http_401;
            RETURN;
        END IF;

        pck_api_audit.audit(p_data, v_uuid);

    END;

END;
/