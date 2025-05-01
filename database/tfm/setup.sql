ALTER SESSION SET CURRENT_SCHEMA = BSB_DEV
/

-- common

CREATE OR REPLACE PROCEDURE drop_table_if_exists(p_table_name VARCHAR2) IS
  v_sql VARCHAR2(2000 CHAR) := 'DROP TABLE ' || UPPER(p_table_name) || ' PURGE'; 
BEGIN
  EXECUTE IMMEDIATE v_sql;
  DBMS_OUTPUT.PUT_LINE('Table ' || UPPER(p_table_name) || ' dropped.');
EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
        RAISE;
      END IF;
END;
/

exec drop_table_if_exists('TFM_RUNS');
exec drop_table_if_exists('TFM_FLOWS');
exec drop_table_if_exists('TFM_AGENTS');
exec drop_table_if_exists('TFM_KEYS');
exec drop_table_if_exists('TFM_LIMITS');
exec drop_table_if_exists('TFM_BALANCE');
/

drop procedure drop_table_if_exists
/

-- tfm_balance

CREATE TABLE tfm_balance (
    uuid CHAR(32),
    period CHAR(1 CHAR) NOT NULL,
    used NUMBER(10, 2) NOT NULL,
    limit NUMBER(10, 2) NOT NULL,
    remaining NUMBER(10, 2) NOT NULL
)
/

-- tfm_limits

CREATE TABLE tfm_limits (
    uuid CHAR(32),
    period CHAR(1 CHAR) NOT NULL,
    limit NUMBER(10, 2) NOT NULL
)
/

INSERT INTO tfm_limits (uuid, period, limit) VALUES (NULL, 'H', 1.00);
INSERT INTO tfm_limits (uuid, period, limit) VALUES (NULL, 'D', 1.00);
INSERT INTO tfm_limits (uuid, period, limit) VALUES (NULL, 'M', 1.00);
INSERT INTO tfm_limits (uuid, period, limit) VALUES (NULL, 'Q', 1.00);
INSERT INTO tfm_limits (uuid, period, limit) VALUES (NULL, 'Y', 1.00);

COMMIT;

-- tfm_flows

CREATE TABLE tfm_flows (
    ufid CHAR(32) NOT NULL,
    name VARCHAR2(200 CHAR) NOT NULL,
    description VARCHAR2(2000 CHAR),
    options CLOB,
    coins NUMBER(10, 2) NOT NULL,
    status CHAR(1 CHAR) DEFAULT 'A' NOT NULL
)
/

ALTER TABLE tfm_flows ADD CONSTRAINT tfm_flows_ufid PRIMARY KEY (ufid);
ALTER TABLE tfm_flows ADD CONSTRAINT tfm_flows_status CHECK (status IN ('A', 'I'));
ALTER TABLE tfm_flows ADD CONSTRAINT tfm_flows_options CHECK (options IS JSON);
CREATE INDEX tfm_flows_name on tfm_flows (name);


INSERT INTO tfm_flows (ufid, name, description, coins, options)
VALUES (LOWER(SYS_GUID()), 'Random joke about sports', 'Generate a random joke about sports', 0.02, '
{
    "name": "Random joke about sports",
    "description": "Generates a random joke about sports",
    "coins": 0.02,
    "steps": {
        "Random joke": {
            "agent": "Ask Chat GPT 4.0",
            "params": {
                "message": "Tell me random joke about sports"
            }
        }
    },
    "report": "{{ Random joke }}"
}
');

INSERT INTO tfm_flows (ufid, name, description, coins, options)
VALUES (LOWER(SYS_GUID()), 'Random jokes about people and plants', 'Generate a random jokes about people and plants', 0.04, '
{
    "name": "Random joke about people and plants",
    "description": "Generates a random joke about people and plants",
    "coins": 0.04,
    "steps": {
        "Random people joke": {
            "agent": "Ask Chat GPT 4.0",
            "params": {
                "message": "Tell me random joke about people"
            }
        },
        "Random plants joke": {
            "agent": "Ask Chat GPT 4.0",
            "params": {
                "message": "Tell me random joke about plants"
            }
        }
    },
    "report": "##People\n\n{{ Random people joke }}\n\n## Plants\n\n{{ Random plants joke }}\n\n"
}
');

INSERT INTO tfm_flows (ufid, name, description, coins, options)
VALUES (LOWER(SYS_GUID()), 'Random joke about something', 'Generate a random joke about something', 0.02, '
{
    "name": "Random joke about something",
    "description": "Generates a random joke about something",
    "coins": 0.02,
    "form":{
        "fields":[
            {
                "name":"something",
                "type":"text",
                "label":"Write topic"
            }
        ],
        "actions" : ["cancel", "submit"],
        "actionSubmit" : "submit",
        "actionCancel" : "cancel"
    },
    "steps": {
        "Random joke": {
            "agent": "Ask Chat GPT 4.0",
            "params": {
                "message": "Generate a random joke about {{ something }}"
            }
        }
    },
    "report": "{{ Random joke }}"
}
');

COMMIT;

-- tfm_runs

CREATE TABLE tfm_runs (
    urid CHAR(32) NOT NULL,
    ufid CHAR(32) NOT NULL,
    uuid CHAR(32),
    options CLOB,
    results CLOB,
    errors CLOB,
    coins NUMBER(10, 2) NOT NULL,
    status CHAR(1 CHAR) DEFAULT 'P' NOT NULL,
    created TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    started TIMESTAMP(6),
    finished TIMESTAMP(6),
    duration NUMBER(19)
)
/

-- tfm_agents

CREATE TABLE tfm_agents (
    uaid CHAR(32) NOT NULL,
    name VARCHAR2(200 CHAR) NOT NULL,
    description VARCHAR2(2000 CHAR),
    options CLOB,
    coins NUMBER(10, 2) NOT NULL,
    status CHAR(1 CHAR) DEFAULT 'A' NOT NULL
)
/

COMMENT ON TABLE tfm_agents IS 'Table to store the agents';
COMMENT ON COLUMN tfm_agents.uaid IS 'Unique agent identifier';
COMMENT ON COLUMN tfm_agents.name IS 'Agent name';
COMMENT ON COLUMN tfm_agents.description IS 'Agent description';
COMMENT ON COLUMN tfm_agents.options IS 'Agent options';
COMMENT ON COLUMN tfm_agents.coins IS 'Agent coins';
COMMENT ON COLUMN tfm_agents.status IS 'Agent status (A=Active, I=Inactive)';
BEGIN NULL; END;
/ 

ALTER TABLE tfm_agents ADD CONSTRAINT tfm_agents_uaid PRIMARY KEY (uaid)
/

ALTER TABLE tfm_agents ADD CONSTRAINT csc_tfm_agents_status CHECK (status IN ('A', 'I'))
/

ALTER TABLE tfm_agents ADD CONSTRAINT csc_tfm_agents_options CHECK (options IS JSON);

CREATE INDEX tfm_agents_name on tfm_agents (name)
/

DECLARE
    v_options CLOB := '
{
    "name": "Ask Chat GPT 4.0",
    "description": "Classical OpenAI Chat GPT 4.0",
    "coins": 0.01,
    "method":"pck_api_openai.completion",
    "keys":{
        "api_key": "openai_api_key"
    },
    "const":{
        "model": "gpt-4",
        "prompt": ""
    },    
    "params":{
        "message": ""
    },
    "result":{
        "message": ""
    }
}
    ';
    v_name VARCHAR2(200) := JSON_VALUE(v_options, '$.name');
    v_description VARCHAR2(2000) := JSON_VALUE(v_options, '$.description');
    v_coins NUMBER(10, 2) := JSON_VALUE(v_options, '$.coins');
BEGIN
    INSERT INTO tfm_agents (uaid, name, description, options, coins)
    VALUES (LOWER(SYS_GUID()), v_name, v_description, v_options, v_coins);

    COMMIT;
END;
/

-- tfm_keys

CREATE TABLE tfm_keys (
    ukid CHAR(32) NOT NULL,
    name VARCHAR2(200 CHAR) NOT NULL,
    key VARCHAR2(200 CHAR) NOT NULL,
    description VARCHAR2(2000 CHAR)
);

COMMENT ON TABLE tfm_keys IS 'Table to store the keys';
COMMENT ON COLUMN tfm_keys.ukid IS 'Unique key identifier';
COMMENT ON COLUMN tfm_keys.name IS 'Key name';
COMMENT ON COLUMN tfm_keys.key IS 'Key value';
COMMENT ON COLUMN tfm_keys.description IS 'Key description';

ALTER TABLE tfm_keys ADD CONSTRAINT tfm_keys_ukid PRIMARY KEY (ukid);

CREATE INDEX tfm_keys_name on tfm_keys (name);

INSERT INTO tfm_keys (ukid, name, key, description) 
SELECT LOWER(SYS_GUID()), 'openai_api_key', content, 'OpenAI API Key'
FROM app_settings
WHERE id = 'APP_OPENAI_API_KEY';

COMMIT;

-- job

BEGIN
    pck_api_jobs.remove('tfm');
    pck_api_jobs.add('tfm','pck_tfm.job_tfm', NULL, 'FREQ=SECONDLY; INTERVAL=30', 'The Flow Master Job');
END;