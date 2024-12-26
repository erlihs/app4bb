# Authentication services

In this section the services needed for authentication will be created.

## Authentication methods

Create methods for login with username and password, logout and obtaining refresh token.

::: details `/database/app/pck_app.pks`

```plsql
CREATE OR REPLACE PACKAGE pck_app AS -- Package provides methods for the application

    PROCEDURE get_version( -- Procedure returns current version
        r_version OUT VARCHAR2 -- Version number
    );

    PROCEDURE post_login( -- Procedure authenticates user and returns tokens
        p_username APP_USERS.USERNAME%TYPE, -- User name (e-mail address)
        p_password APP_USERS.PASSWORD%TYPE, -- Password
        r_access_token OUT APP_TOKENS.TOKEN%TYPE, -- Token
        r_refresh_token OUT APP_TOKENS.TOKEN%TYPE, -- Refresh token
        r_user OUT SYS_REFCURSOR -- User data
    );

    PROCEDURE post_logout; -- Procedure invalidates access and refresh tokens

    PROCEDURE post_refresh( -- Procedure re-issues access and refresh tokens
        r_access_token OUT APP_TOKENS.TOKEN%TYPE, -- Token
        r_refresh_token OUT APP_TOKENS.TOKEN%TYPE -- Refresh token
    );

    PROCEDURE get_heartbeat;

END;
/
```

:::

::: details `/database/app/pck_app.pkb`

```plsql
CREATE OR REPLACE PACKAGE BODY pck_app AS

    PROCEDURE get_version(
        r_version OUT VARCHAR2
    ) AS
    BEGIN
        pck_api_settings.read('APP_VERSION', r_version);
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

        OPEN r_user FOR
        SELECT
            u.uuid AS "uuid",
            u.username AS "username",
            u.fullname AS "fullname",
            TO_CHAR(u.created, 'YYYY-MM-DD HH24:MI') AS "created"
        FROM
            app_users u
        WHERE
            u.uuid = v_uuid;

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

END;
/
```

:::

## Test

Test with Postmnan `POST login` to get access and refresh tokens, `POST logout` to revoke tokens, `POST refresh` and `GET heartbeat` with and without tokens to see the difference - check audit records.

```sql
SELECT * FROM app_audit ORDER BY created DESC;
```
