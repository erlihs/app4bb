SET SERVEROUTPUT ON

PROMPT Starting setup.

PROMPT Installing app package..
@./app/pck_app.pks
@./app/pck_app.pkb

PROMPT Installing adm package..
@./adm/pck_adm.pks
@./adm/pck_adm.pkb

PROMPT Setting web services..
exec ordsify;

PROMPT Done.
