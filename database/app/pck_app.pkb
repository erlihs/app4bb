CREATE OR REPLACE PACKAGE BODY pck_app AS

    PROCEDURE get_version(
        r_version OUT VARCHAR2
    ) AS
    BEGIN

        pck_api_settings.read('APP_VERSION', r_version);

    END;

END;
/