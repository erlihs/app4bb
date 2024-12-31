
BEGIN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_bsb_games START WITH 1';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-955) THEN RAISE; END IF; 
END;
/

BEGIN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_bsb_games_code START WITH 1';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-955) THEN RAISE; END IF; 
END;
/

BEGIN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_bsb_plays START WITH 1';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-955) THEN RAISE; END IF; 
END;
/

BEGIN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_bsb_chats START WITH 1';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-955) THEN RAISE; END IF; 
END;
/

BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE bsb_games (
    id NUMBER(10) NOT NULL,
    tag  VARCHAR2(30 CHAR) DEFAULT ''business'' NOT NULL,
    code VARCHAR2(30 CHAR) NOT NULL,
    uuid CHAR(32 CHAR) NOT NULL,
    title VARCHAR2(120 CHAR) NOT NULL,
    status CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    created TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    modified TIMESTAMP(6),
    w1 VARCHAR2(30 CHAR) NOT NULL,
    w2 VARCHAR2(30 CHAR) NOT NULL,
    w3 VARCHAR2(30 CHAR) NOT NULL,
    w4 VARCHAR2(30 CHAR) NOT NULL,
    w5 VARCHAR2(30 CHAR) NOT NULL,
    w6 VARCHAR2(30 CHAR) NOT NULL,
    w7 VARCHAR2(30 CHAR) NOT NULL,
    w8 VARCHAR2(30 CHAR) NOT NULL,
    w9 VARCHAR2(30 CHAR) NOT NULL,
    w10 VARCHAR2(30 CHAR) NOT NULL,
    w11 VARCHAR2(30 CHAR) NOT NULL,
    w12 VARCHAR2(30 CHAR) NOT NULL,
    w13 VARCHAR2(30 CHAR) DEFAULT ''Bullshit Bingo'' NOT NULL,
    w14 VARCHAR2(30 CHAR) NOT NULL,
    w15 VARCHAR2(30 CHAR) NOT NULL,
    w16 VARCHAR2(30 CHAR) NOT NULL,
    w17 VARCHAR2(30 CHAR) NOT NULL,
    w18 VARCHAR2(30 CHAR) NOT NULL,
    w19 VARCHAR2(30 CHAR) NOT NULL,
    w20 VARCHAR2(30 CHAR) NOT NULL,
    w21 VARCHAR2(30 CHAR) NOT NULL,
    w22 VARCHAR2(30 CHAR) NOT NULL,
    w23 VARCHAR2(30 CHAR) NOT NULL,
    w24 VARCHAR2(30 CHAR) NOT NULL,
    w25 VARCHAR2(30 CHAR) NOT NULL,
    m1 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m2 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m3 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m4 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m5 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m6 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m7 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m8 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m9 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m10 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m11 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m12 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m13 CHAR(1 CHAR) DEFAULT ''C'' NOT NULL,
    m14 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m15 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m16 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m17 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m18 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m19 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m20 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m21 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m22 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m23 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m24 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m25 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL
)
    ';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-955) THEN RAISE; END IF;
END;
/

COMMENT ON TABLE bsb_games IS 'Bullshit Bingo games';
COMMENT ON COLUMN bsb_games.id IS 'Game ID';
COMMENT ON COLUMN bsb_games.tag IS 'Game tag';
COMMENT ON COLUMN bsb_games.code IS 'Game code';
COMMENT ON COLUMN bsb_games.uuid IS 'User ID';
COMMENT ON COLUMN bsb_games.title IS 'Game title';
COMMENT ON COLUMN bsb_games.status IS 'Game status';
COMMENT ON COLUMN bsb_games.created IS 'Game created';
COMMENT ON COLUMN bsb_games.modified IS 'Game modified';
BEGIN NULL; END;
/

BEGIN
    EXECUTE IMMEDIATE '
ALTER TABLE bsb_games ADD CONSTRAINT cpk_bsb_games PRIMARY KEY (id)';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-2260) THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_01 CHECK (m1 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_02 CHECK (m2 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_03 CHECK (m3 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_04 CHECK (m4 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_05 CHECK (m5 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_06 CHECK (m6 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_07 CHECK (m7 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_08 CHECK (m8 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_09 CHECK (m9 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_10 CHECK (m10 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_11 CHECK (m11 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_12 CHECK (m12 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_13 CHECK (m13 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_14 CHECK (m14 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_15 CHECK (m15 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_16 CHECK (m16 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_17 CHECK (m17 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_18 CHECK (m18 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_19 CHECK (m19 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_20 CHECK (m20 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_21 CHECK (m21 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_22 CHECK (m22 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_23 CHECK (m23 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_24 CHECK (m24 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_25 CHECK (m25 IN (''N'', ''P'', ''C''))';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-2264) THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE '
ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_status CHECK (status IN (''A'', ''N''))
    ';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-2264) THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE '
ALTER TABLE bsb_games ADD CONSTRAINT csc_bsb_games_26 CHECK (tag IN (''business'', ''technology'', ''sports'', ''entertainment'',''education''))
    ';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-2264) THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE '
CREATE UNIQUE INDEX idx_bsb_games_code ON bsb_games (code)
    ';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-955) THEN RAISE; END IF;
END;
/

BEGIN
	EXECUTE IMMEDIATE '
CREATE INDEX idx_bsb_games_uuid ON bsb_games(uuid)
	';
EXCEPTION
	WHEN OTHERS THEN IF SQLCODE NOT IN (-955) THEN RAISE; END IF;
END;
/

BEGIN
    UPDATE bsb_games SET 
        code = TRIM(TO_CHAR(seq_bsb_games.NEXTVAL,'XXXXXXXXXXXXXXXX')),
        uuid = (SELECT uuid FROM app_users WHERE id = 1),
        title = 'The very first bullshit bingo game',
        status = 'A',
        w1 = 'agile',
        w2 = 'vision',
        w3 = 'sprint',
        w4 = 'increment',
        w5 = 'standup',
        w6 = 'release',
        w7 = 'product owner',
        w8 = 'scrummaster',
        w9 = 'team',
        w10 = 'high performance',
        w11 = 'burndown',
        w12 = 'story points',
        w13 = 'Bullshit Bingo',
        w14 = 'backlog',
        w15 = 'user story',
        w16 = 'epic',
        w17 = 'task',
        w18 = 'planning',
        w19 = 'demo',
        w20 = 'retrospection',
        w21 = 'impediment',
        w22 = 'transparency',
        w23 = 'inspection',
        w24 = 'adaptation',
        w25 = 'scrum'
    WHERE id = 1;
    IF SQL%ROWCOUNT = 0 THEN
    INSERT INTO bsb_games (
        id,
        code,
        uuid,
        title,
        status,
        w1,
        w2,
        w3,
        w4,
        w5,
        w6,
        w7,
        w8,
        w9,
        w10,
        w11,
        w12,
        w13,
        w14,
        w15,
        w16,
        w17,
        w18,
        w19,
        w20,
        w21,
        w22,
        w23,
        w24,
        w25
    ) VALUES (
        seq_bsb_games.NEXTVAL,
        TRIM(TO_CHAR(seq_bsb_games.NEXTVAL,'XXXXXXXXXXXXXXXX')),
        (SELECT uuid FROM app_users WHERE id = 1), -- uuid
        'The very first bullshit bingo game',
        'A',
        'agile', -- w1
        'vision',
        'sprint',
        'increment',
        'standup',
        'release',
        'product owner',
        'scrummaster',
        'team',
        'high performance',
        'burndown',
        'story points',
        'Bullshit Bingo', --w13
        'backlog',
        'user story',
        'epic',
        'task',
        'planning',
        'demo',
        'retrospection',
        'impediment',
        'transparency',
        'inspection',
        'adaptation',
        'scrum' -- w25
    );
    END IF;
    COMMIT;
END;
/

BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE bsb_plays (
    id NUMBER(10) NOT NULL,
    id_game NUMBER(10) NOT NULL,
    uuid CHAR(32 CHAR),
    username VARCHAR2(30 CHAR) NOT NULL,
    status CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    created TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    modified TIMESTAMP(6),
    bingo TIMESTAMP(6),
    bullshit_bingo TIMESTAMP(6),
    w1 VARCHAR2(30 CHAR) NOT NULL,
    w2 VARCHAR2(30 CHAR) NOT NULL,
    w3 VARCHAR2(30 CHAR) NOT NULL,
    w4 VARCHAR2(30 CHAR) NOT NULL,
    w5 VARCHAR2(30 CHAR) NOT NULL,
    w6 VARCHAR2(30 CHAR) NOT NULL,
    w7 VARCHAR2(30 CHAR) NOT NULL,
    w8 VARCHAR2(30 CHAR) NOT NULL,
    w9 VARCHAR2(30 CHAR) NOT NULL,
    w10 VARCHAR2(30 CHAR) NOT NULL,
    w11 VARCHAR2(30 CHAR) NOT NULL,
    w12 VARCHAR2(30 CHAR) NOT NULL,
    w13 VARCHAR2(30 CHAR) DEFAULT ''Bullshit Bingo'' NOT NULL,
    w14 VARCHAR2(30 CHAR) NOT NULL,
    w15 VARCHAR2(30 CHAR) NOT NULL,
    w16 VARCHAR2(30 CHAR) NOT NULL,
    w17 VARCHAR2(30 CHAR) NOT NULL,
    w18 VARCHAR2(30 CHAR) NOT NULL,
    w19 VARCHAR2(30 CHAR) NOT NULL,
    w20 VARCHAR2(30 CHAR) NOT NULL,
    w21 VARCHAR2(30 CHAR) NOT NULL,
    w22 VARCHAR2(30 CHAR) NOT NULL,
    w23 VARCHAR2(30 CHAR) NOT NULL,
    w24 VARCHAR2(30 CHAR) NOT NULL,
    w25 VARCHAR2(30 CHAR) NOT NULL,
    m1 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m2 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m3 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m4 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m5 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m6 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m7 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m8 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m9 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m10 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m11 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m12 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m13 CHAR(1 CHAR) DEFAULT ''C'' NOT NULL,
    m14 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m15 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m16 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m17 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m18 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m19 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m20 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m21 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m22 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m23 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m24 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL,
    m25 CHAR(1 CHAR) DEFAULT ''N'' NOT NULL
)
    ';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-955) THEN RAISE; END IF;
END;
/

COMMENT ON TABLE bsb_plays IS 'Bullshit Bingo plays';
COMMENT ON COLUMN bsb_plays.id IS 'Play ID';
COMMENT ON COLUMN bsb_plays.id_game IS 'Game ID';
COMMENT ON COLUMN bsb_plays.uuid IS 'User ID';
COMMENT ON COLUMN bsb_plays.username IS 'Username';
COMMENT ON COLUMN bsb_plays.status IS 'Play status';
COMMENT ON COLUMN bsb_plays.created IS 'Play created';
COMMENT ON COLUMN bsb_plays.modified IS 'Play modified';
COMMENT ON COLUMN bsb_plays.bingo IS 'Bingo';
COMMENT ON COLUMN bsb_plays.bullshit_bingo IS 'Bullshit Bingo';
BEGIN NULL; END;
/

BEGIN
    EXECUTE IMMEDIATE '
ALTER TABLE bsb_plays ADD CONSTRAINT cpk_bsb_plays PRIMARY KEY (id)
    ';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-2260) THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE '
ALTER TABLE bsb_plays ADD CONSTRAINT cfk_bsb_plays_01 FOREIGN KEY (id_game) REFERENCES bsb_games(id)
    ';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-2261, -2298) THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_01 CHECK (m1 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_02 CHECK (m2 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_03 CHECK (m3 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_04 CHECK (m4 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_05 CHECK (m5 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_06 CHECK (m6 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_07 CHECK (m7 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_08 CHECK (m8 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_09 CHECK (m9 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_10 CHECK (m10 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_11 CHECK (m11 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_12 CHECK (m12 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_13 CHECK (m13 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_14 CHECK (m14 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_15 CHECK (m15 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_16 CHECK (m16 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_17 CHECK (m17 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_18 CHECK (m18 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_19 CHECK (m19 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_20 CHECK (m20 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_21 CHECK (m21 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_22 CHECK (m22 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_23 CHECK (m23 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_24 CHECK (m24 IN (''N'', ''P'', ''C''))';
    EXECUTE IMMEDIATE 'ALTER TABLE bsb_plays ADD CONSTRAINT csc_bsb_plays_25 CHECK (m25 IN (''N'', ''P'', ''C''))';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-2264) THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE '
CREATE INDEX idx_bsb_plays_id_game ON bsb_plays(id_game)
    ';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-955) THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE '
CREATE INDEX idx_bsb_plays_uuid ON bsb_plays(uuid)
    ';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-955) THEN RAISE; END IF;
END;
/

BEGIN
    UPDATE bsb_plays SET 
        uuid = (SELECT uuid FROM app_users WHERE id = 1),
        username = 'John Doe',
        status = 'A',
        w1 = 'agile',
        w2 = 'vision',
        w3 = 'sprint',
        w4 = 'increment',
        w5 = 'standup',
        w6 = 'release',
        w7 = 'product owner',
        w8 = 'scrummaster',
        w9 = 'team',
        w10 = 'high performance',
        w11 = 'burndown',
        w12 = 'story points',
        w13 = 'Bullshit Bingo',
        w14 = 'backlog',
        w15 = 'user story',
        w16 = 'epic',
        w17 = 'task',
        w18 = 'planning',
        w19 = 'demo',
        w20 = 'retrospection',
        w21 = 'impediment',
        w22 = 'transparency',
        w23 = 'inspection',
        w24 = 'adaptation',
        w25 = 'scrum'
    WHERE id = 1;
    IF SQL%ROWCOUNT = 0 THEN
    INSERT INTO bsb_plays (
        id,
        id_game,
        uuid,
        username,
        status,
        w1,
        w2,
        w3,
        w4,
        w5,
        w6,
        w7,
        w8,
        w9,
        w10,
        w11,
        w12,
        w13,
        w14,
        w15,
        w16,
        w17,
        w18,
        w19,
        w20,
        w21,
        w22,
        w23,
        w24,
        w25
    ) VALUES (
        seq_bsb_plays.NEXTVAL,
        1000,
        (SELECT uuid FROM app_users WHERE id = 1), -- uuid
        'John Doe',
        'A',
        'agile', -- w1
        'vision',
        'sprint',
        'increment',
        'standup',
        'release',
        'product owner',
        'scrummaster',
        'team',
        'high performance',
        'burndown',
        'story points',
        'Bullshit Bingo', --w13
        'backlog',
        'user story',
        'epic',
        'task',
        'planning',
        'demo',
        'retrospection',
        'impediment',
        'transparency',
        'inspection',
        'adaptation',
        'scrum' -- w25
    );
    END IF;
    COMMIT;
END;
/

BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE bsb_chats (
    id NUMBER(10) NOT NULL,
    status CHAR(1 CHAR) DEFAULT ''P'' NOT NULL,
    id_game NUMBER(10) NOT NULL,
    id_play NUMBER(10),
    message VARCHAR2(2000 CHAR),
    created TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL
)
    ';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-955) THEN RAISE; END IF;
END;
/

COMMENT ON TABLE bsb_chats IS 'Bullshit Bingo chats';
COMMENT ON COLUMN bsb_chats.id IS 'Chat ID';
COMMENT ON COLUMN bsb_chats.status IS 'Chat status';
COMMENT ON COLUMN bsb_chats.id_game IS 'Game ID';
COMMENT ON COLUMN bsb_chats.id_play IS 'Play ID';
COMMENT ON COLUMN bsb_chats.message IS 'Chat message';
COMMENT ON COLUMN bsb_chats.created IS 'Chat created';
BEGIN NULL; END;
/

BEGIN
    EXECUTE IMMEDIATE '
ALTER TABLE bsb_chats ADD CONSTRAINT cpk_bsb_chats PRIMARY KEY (id)
';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-2260) THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE '
ALTER TABLE bsb_chats ADD CONSTRAINT cfk_bsb_chats_01 FOREIGN KEY (id_game) REFERENCES bsb_games(id)
    ';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-2261, -2275) THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE '
ALTER TABLE bsb_chats ADD CONSTRAINT cfk_bsb_chats_02 FOREIGN KEY (id_play) REFERENCES bsb_plays(id)
    ';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-2261, -2275) THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE '
ALTER TABLE bsb_chats ADD CONSTRAINT csc_bsb_chats_01 CHECK (status IN (''D'', ''P'', ''T'', ''B''))
    '; --delaer, -- player, --typos, -- bot
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-2264) THEN RAISE; END IF;
END;  
/

BEGIN
    EXECUTE IMMEDIATE '
CREATE INDEX idx_chats_01 ON bsb_chats(id_game)
    ';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-955) THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE '
CREATE INDEX idx_chats_02 ON bsb_chats(id_play)
    ';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE NOT IN (-955) THEN RAISE; END IF;
END;
/

BEGIN
    UPDATE app_settings SET content = '50' WHERE id = 'BSB_AUTOACCEPT_LEVEL';
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO app_settings (id, description, content) VALUES ('BSB_AUTOACCEPT_LEVEL', 'Bullshti Bingo auto accept level, percentage', '50');
    END IF;
    COMMIT;
END;
/
