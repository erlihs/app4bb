CREATE OR REPLACE PACKAGE pck_adm AS -- Package for Admin

    PROCEDURE get_status ( -- Procedure to get status data
        r_status OUT SYS_REFCURSOR -- Status data
    );

    PROCEDURE get_users ( -- Procedure to get users data
        p_search VARCHAR2 DEFAULT NULL, -- Search string
        p_offset NUMBER DEFAULT 0, -- Offset
        p_limit NUMBER DEFAULT 10, -- Limit
        r_items OUT SYS_REFCURSOR -- Users data
    );

    PROCEDURE post_user_lock ( -- Procedure to lock user
        p_uuid app_users.uuid%TYPE -- User UUID
    );

    PROCEDURE post_user_unlock ( -- Procedure to lock user
        p_uuid app_users.uuid%TYPE -- User UUID
    );

    PROCEDURE get_audit ( -- Procedure to get audit data
        p_search VARCHAR2 DEFAULT NULL, -- Search string
        p_offset NUMBER DEFAULT 0, -- Offset
        p_limit NUMBER DEFAULT 10, -- Limit
        r_items OUT SYS_REFCURSOR -- Audit data
    );

    PROCEDURE get_settings ( -- Get settings data
        p_search VARCHAR2 DEFAULT NULL, -- Search string
        p_offset NUMBER DEFAULT 0, -- Offset
        p_limit NUMBER DEFAULT 10, -- Limit
        r_items OUT SYS_REFCURSOR -- Result data
    );

    PROCEDURE post_setting( -- Post setting data
        p_id app_settings.id%type DEFAULT NULL, -- Setting ID
        p_content app_settings.content%type DEFAULT NULL, -- Setting value
        r_errors OUT SYS_REFCURSOR -- Error message
    );


END;
/
