CREATE OR REPLACE PACKAGE pck_app AS -- Package provides methods for app

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

    PROCEDURE get_heartbeat; -- Procedure keeps session alive

    PROCEDURE post_audit( -- Procedure logs user activity
        p_data CLOB --  Audit data in JSON format [{severity, action, details, created}]
    );

END;
/