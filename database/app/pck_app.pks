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

    PROCEDURE post_signup( -- Procedure registers and authenticates user and returns token and context data
        p_username APP_USERS.USERNAME%TYPE, -- User name (e-mail address)
        p_password APP_USERS.PASSWORD%TYPE, -- Password
        p_fullname APP_USERS.FULLNAME%TYPE, -- Full name
        r_access_token OUT APP_TOKENS.TOKEN%TYPE, -- Token
        r_refresh_token OUT APP_TOKENS.TOKEN%TYPE, -- Refresh token
        r_user OUT SYS_REFCURSOR, -- User data
        r_error OUT VARCHAR2 -- Error (NULL if success)
    );

    PROCEDURE post_confirmemail( -- Procedure confirms email address
        p_confirmtoken APP_TOKENS.TOKEN%TYPE, --  Email confirmation token (sent by e-mail)
        r_error OUT VARCHAR2 -- Error (NULL if sucess)
    );

   PROCEDURE post_recoverpassword( -- Procedure initiates sending of email to recover password
        p_username APP_USERS.USERNAME%TYPE, -- Username (e-mail address)
        r_error OUT VARCHAR2 -- Error (NULL if sucess)
    );
    
    PROCEDURE post_resetpassword( -- Procedure resets user password
        p_username APP_USERS.USERNAME%TYPE, -- Username (e-mail address)
        p_password APP_USERS.PASSWORD%TYPE, -- Password
        p_recovertoken APP_TOKENS.TOKEN%TYPE, --  Password recovery token (sent by e-mail)
        r_access_token OUT VARCHAR2, -- Access token
        r_refresh_token OUT VARCHAR2, -- Refresh token
        r_user OUT SYS_REFCURSOR, -- User data
        r_error OUT VARCHAR2 -- Error (NULL if success)
    );

END;
/