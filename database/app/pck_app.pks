CREATE OR REPLACE PACKAGE pck_app AS -- Package provides methods for app

    PROCEDURE get_version( -- Procedure returns current version
        r_version OUT VARCHAR2 -- Version number
    );

END;
/