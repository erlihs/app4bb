# Naming conventions

## Usage of object types

| Ok to use | With caution                        | Red flag                   |
| --------- | ----------------------------------- | -------------------------- |
| Tables    | Views                               | Business logic in triggers |
| Sequences | Types                               | Java / C / etc. procedures |
| Indexes   | Standalone procedures and functions |                            |
| Packages  | Materialized views                  |                            |
|           |                                     |                            |

## Common

All object names are in single and self describing.

Length of object names is limited to 30 characters.

Object names have underscore separated three letter prefix describing business domain.

ANSII SQL syntax must be used wherever possible.

All object names must have prefix of 3 letters representing modules.

Oracle reserved words must be in upper case

```sql
SELECT word FROM v$reserved_words WHERE reserved = 'Y';
```

## Tables

Table names are in single and self describing.

Tables and columns must have comments.

If name is too long, then use abbreviations.

Allowed data types: _VARCHAR2(X CHAR) - max 2000 char, CHAR, NUMBER(X,Y), CLOB, DATE, TIMESTAMP(6), BLOB_.

Column names are in single.

Primary key is named: _id_. Data type: _NUMBER(19, 0)_.

Foreign keys are named: _id_table name_.

_NOT NULL_ constraints must be defined, where needed.

Comments are mandatory for tables and columns.

Primary key constraint must be named: _pk_table name_.

Foreign key constraint must be named: _fk_table name_. N.B. Index is not automatically created and should be added as well.

Enumerated fields must have check constraints.

JSON field must have JSON constraint.

```sql
CREATE TABLE app_storage (
   id NUMBER(19) NOT NULL,
   guid CHAR(32 CHAR) DEFAULT SYS_GUID() NOT NULL,
   id_user NUMBER(19),
   file_name VARCHAR2(2000 CHAR),
   file_size NUMBER(19),
   file_ext VARCHAR2(30 CHAR),
   content BLOB,
   sharing CHAR(1 CHAR) DEFAULT 'Y' NOT NULL,
   created TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL
)
LOB(content) STORE AS SECUREFILE(
   CACHE
   NOLOGGING
);
/

COMMENT ON TABLE app_storage IS 'Table for storing and processing attachment data';
..
COMMENT ON COLUMN app_storage.id_user IS 'User who created attachment. Reference to APP_USERS.ID';
COMMENT ON COLUMN app_storage.sharing IS 'Is attachment shareable to other users (Y - yes, N - No)';
/

ALTER TABLE app_storage ADD CONSTRAINT pk_app_storage PRIMARY KEY (id);
/

ALTER TABLE app_storage ADD CONSTRAINT fk_app_storage_user FOREIGN KEY (id_user) REFERENCES app_users(id);
CREATE INDEX idx_app_storage_user ON app_storage(id_user) ONLINE;
/

ALTER TABLE app_storage ADD CONSTRAINT ch_app_storage_sharing CHECK sharing IN ('Y','N');
/
```

## Views

View names must have prefix v\_.

## Sequences

Sequence shall be named _seq_table_name_.

## Indexes

Indexes shall be named _idx_table_name_column_name(s)_.

Unique indexes shall be named idq\_.

## PL\SQL

Package, procedure and variable names are in single an self describing.

Input and output variables must reference table column data types (..%TYPE) whenever possible.

Prefix, purpose

- p\_ Incoming parameters
- v\_ Local variables
- g\_ Global variables
- vc\_ Local constants
- gc\_ Global constants
- c\_ Cursors
- e\_ Exception
- r\_ Outgoing parameters
- r\_ Record
- t\_ Type

See [Ordsify](https://github.com/erlihs/ordsify) for procedure naming conventions.
