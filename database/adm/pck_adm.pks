CREATE OR REPLACE PACKAGE pck_adm AS -- Package for Admin

    PROCEDURE get_status ( -- Procedure to get status data
        r_status OUT SYS_REFCURSOR -- Status data [{"status": "Total users", "value": "10", "to": "/admin#users", "severity": "I"}]
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

    PROCEDURE get_jobs ( -- Get jobs data
        p_search VARCHAR2 DEFAULT NULL, -- Search string
        p_offset NUMBER DEFAULT 0, -- Offset
        p_limit NUMBER DEFAULT 10, -- Limit
        r_items OUT SYS_REFCURSOR -- Jobs data [{"name": "Job name", "schedule": "FREQ=Daily", "start": "2025-12-12 12:12:12", "duration": "+00 00:00:00", "comments": "Job comments", "enabled": "Y"}]
    );

    PROCEDURE get_jobs_history ( -- Get jobs history data
        p_search VARCHAR2 DEFAULT NULL, -- Search string
        p_offset NUMBER DEFAULT 0, -- Offset
        p_limit NUMBER DEFAULT 10, -- Limit
        r_items OUT SYS_REFCURSOR -- Jobs history data [{"name": "Job name", "start": "2025-12-12 12:12:12", "duration": "+00 00:00:00", "status": "SUCCEEDED", "output": "Job output"}]
    );

    PROCEDURE post_job_run ( -- Post job run data
        p_name VARCHAR2 -- Job name
    );

END;
/
