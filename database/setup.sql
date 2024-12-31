SET SERVEROUTPUT ON
SET FEEDBACK OFF

PROMPT Starting setup.
ALTER SESSION SET CURRENT_SCHEMA = &schema_name;

PROMPT Installing app package..
@./app/pck_app.pks
@./app/pck_app.pkb

PROMPT Installing adm package..
@./adm/pck_adm.pks
@./adm/pck_adm.pkb

PROMPT Installing bsb tables and package..
@./bsb/setup.sql
@./bsb/pck_bsb.pks
@./bsb/pck_bsb.pkb

PROMPT Setting web services..
exec ordsify;

PROMPT Done.
