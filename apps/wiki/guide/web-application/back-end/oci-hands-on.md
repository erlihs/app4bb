# Hands on

## Database schemas explained

Oracle Database has a bit different naming of things that other databases. [Check this article](https://www.pixelstech.net/article/1481778811-Understanding-database-instance-and-schema-in-Oracle-database)

In case of Oracle Cloud Free Tier we will have one instance to which we can create one or more schemas. Default schema, when we create an new instance is _ADMIN_. From this schema we will create a new schema that will contain all data and packages needed for our app.

## Setting up database

In "heavy duty" circumstances we would be [using Liquibase for Oracle](https://docs.liquibase.com/start/tutorials/oracle.html) or the new `SqlCl project init` feature, but for quick start we will just create and re-run necessary database scripts.

1.  Create `database` folder in your project root directory

2.  Download and install [odb4bb](https://github.com/erlihs/odb4bb)

```
/
    /database
        /odb4bb
            setup.sql
            ..
    /apps
```

Open **SQLCl** and install the database

```ps
cd C:\path_to_your_project\database\odb4bb
@setup.sql my_schema 01234567abcdeF "My Company" https://mydomain.com admin@mydomain.com abcdeF01234567

```

3. Check if database is up and running via [Postman](https://www.postman.com/) or in browser

```
GET https://my_db_host/ords/my_schema/open-api-catalog/
```

## Test database

Create package - add `/database/app/pck_app.pks` and `/database/app/pck_app.pkb`.

```plsql
CREATE OR REPLACE PACKAGE pck_app AS -- Package provides methods for app

    PROCEDURE get_version( -- Procedure returns current version
        r_version OUT VARCHAR2 -- Version number
    );

END;
/
```

```plsql
CREATE OR REPLACE PACKAGE BODY pck_app AS

    PROCEDURE get_version(
        r_version OUT VARCHAR2
    ) AS
    BEGIN

        pck_api_settings.read('APP_VERSION', r_version);

    END;

END;
/
```

And `/database/app/setup_app.sql` and run the script with `SQLcl`

```sql
@pck_app.pks
@pck_app.pkb
exec ordsify('pck_app');
```

_Further on - run this script after any changes in package_

Check with Postman

```ps
GET https://my_db_host/ords/my_schema/app-v1/version/
```

the result should be

```json
{
  "version": "0.3.0"
}
```
