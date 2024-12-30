SET SERVEROUTPUT ON
SET FEEDBACK OFF
PROMPT Starting setup.

PROMPT Installing app package..
@./app/pck_app.pks
@./app/pck_app.pkb

PROMPT Setting app web services..
exec ordsify('pck_app');

PROMPT Done.
