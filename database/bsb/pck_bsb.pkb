CREATE OR REPLACE PACKAGE BODY pck_bsb AS

    /*DEALER*/

    PROCEDURE get_tags(
        r_tags OUT SYS_REFCURSOR
    )
    AS
    BEGIN
        OPEN r_tags FOR
        SELECT 'business' AS "tag" FROM dual
        UNION ALL
        SELECT 'technology' AS "tag" FROM dual
        UNION ALL
        SELECT 'sports' AS "tag" FROM dual
        UNION ALL
        SELECT 'entertainment' AS "tag" FROM dual
        UNION ALL
        SELECT 'education' AS "tag" FROM dual
        ;    
  
    END;

    PROCEDURE get_deal(
        p_gamecode bsb_games.code%TYPE,
        p_uuid bsb_games.uuid%TYPE,
        p_tag bsb_games.tag%TYPE,
        p_title bsb_games.title%TYPE,
        p_offset PLS_INTEGER, 
        p_limit PLS_INTEGER,
        r_result OUT SYS_REFCURSOR
    ) AS
    BEGIN

        OPEN r_result FOR
        SELECT 
            p.id AS "id_play",
            g.code AS "code",
            g.tag AS "tag",
            g.title AS "title",
            g.status AS "status",
            g.w1 AS "w1", g.w2 AS "w2", g.w3 AS "w3", g.w4 AS "w4", g.w5 AS "w5", 
            g.w6 AS "w6", g.w7 AS "w7", g.w8 AS "w8", g.w9 AS "w9", g.w10 AS "w10", 
            g.w11 AS "w11", g.w12 AS "w12", g.w13 AS "w13", g.w14 AS "w14", g.w15 AS "w15", 
            g.w16 AS "w16", g.w17 AS "w17", g.w18 AS "w18", g.w19 AS "w19", g.w20 AS "w20", 
            g.w21 AS "w21", g.w22 AS "w22", g.w23 AS "w23", g.w24 AS "w24", g.w25 AS "w25"
        FROM bsb_games g
        LEFT JOIN bsb_plays p ON p.id_game = g.id AND p.uuid = g.uuid
        WHERE (p_gamecode IS NULL OR g.code = p_gamecode)
        AND (p_uuid IS NULL OR g.uuid = p_uuid)
        AND ((DECODE(p_tag,'*',NULL,p_tag) IS NULL) OR (g.tag = p_tag))
        AND ((DECODE(p_title,'*',NULL,p_tag) IS NULL) OR g.title LIKE '%' || p_title || '%') -- todo: text index
        ORDER BY g.id DESC    
        OFFSET p_offset ROWS
        FETCH NEXT p_limit ROWS ONLY;

    END;

    PROCEDURE get_deals(
        p_tag bsb_games.tag%TYPE DEFAULT NULL,
        p_title bsb_games.title%TYPE DEFAULT NULL,
        p_offset PLS_INTEGER DEFAULT 0, 
        p_limit PLS_INTEGER DEFAULT 10,
        r_deals OUT SYS_REFCURSOR 
    ) AS
        v_uuid CHAR(32 CHAR) := pck_api_auth.uuid;
    BEGIN

        IF v_uuid IS NULL THEN pck_api_auth.http_401; RETURN; END IF;

        get_deal(
            NULL,
            v_uuid,
            p_tag,
            p_title,
            p_offset,
            p_limit,
            r_deals
        );

    END;

    PROCEDURE put_deal( 
        p_code bsb_games.code%TYPE,
        p_tag bsb_games.tag%TYPE, 
        p_fullname bsb_plays.username%TYPE,
        p_title bsb_games.title%TYPE, 
        p_status bsb_games.status%TYPE, 
        p_w1 bsb_games.w1%TYPE, p_w2 bsb_games.w2%TYPE, p_w3 bsb_games.w3%TYPE, p_w4 bsb_games.w4%TYPE,p_w5 bsb_games.w5%TYPE,
        p_w6 bsb_games.w6%TYPE, p_w7 bsb_games.w7%TYPE, p_w8 bsb_games.w8%TYPE, p_w9 bsb_games.w9%TYPE, p_w10 bsb_games.w10%TYPE, 
        p_w11 bsb_games.w11%TYPE, p_w12 bsb_games.w12%TYPE, p_w13 bsb_games.w13%TYPE, p_w14 bsb_games.w14%TYPE, p_w15 bsb_games.w15%TYPE,
        p_w16 bsb_games.w16%TYPE, p_w17 bsb_games.w17%TYPE, p_w18 bsb_games.w18%TYPE, p_w19 bsb_games.w19%TYPE, p_w20 bsb_games.w20%TYPE,
        p_w21 bsb_games.w21%TYPE, p_w22 bsb_games.w22%TYPE, p_w23 bsb_games.w23%TYPE, p_w24 bsb_games.w24%TYPE, p_w25 bsb_games.w25%TYPE,
        r_deals OUT SYS_REFCURSOR
    ) AS 
        v_id bsb_games.id%TYPE;
        v_uuid CHAR(32 CHAR) := pck_api_auth.uuid;
    BEGIN

        IF v_uuid IS NULL THEN pck_api_auth.http_401; RETURN; END IF;

        UPDATE bsb_games SET 
            tag = p_tag,
            uuid = v_uuid,
            title = p_title,
            status = p_status,
            modified = SYSTIMESTAMP,
            w1 = p_w1, w2 = p_w2, w3 = p_w3, w4 = p_w4, w5 = p_w5, 
            w6 = p_w6, w7 = p_w7, w8 = p_w8, w9 = p_w9, w10 = p_w10, 
            w11 = p_w11, w12 = p_w12, w13 = p_w13, w14 = p_w14, w15 = p_w15, 
            w16 = p_w16, w17 = p_w17, w18 = p_w18, w19 = p_w19, w20 = p_w20, 
            w21 = p_w21, w22 = p_w22, w23 = p_w23, w24 = p_w24, w25 = p_w25 
        WHERE code = p_code;

        IF SQL%ROWCOUNT = 0 THEN 

            INSERT INTO bsb_games (
                id,
                tag,
                code,
                uuid,
                title,
                status,
                w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, 
                w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, 
                w21, w22, w23, w24, w25
            ) VALUES (
                seq_bsb_games.NEXTVAL,
                p_tag,
                TRIM(TO_CHAR(seq_bsb_games.NEXTVAL,'XXXXXXXXXXXXXXXX')),
                v_uuid, 
                p_title,
                p_status,
                p_w1, p_w2, p_w3, p_w4, p_w5, p_w6, p_w7, p_w8, p_w9, p_w10, 
                p_w11, p_w12, p_w13, p_w14, p_w15, p_w16, p_w17, p_w18, p_w19, p_w20, 
                p_w21, p_w22, p_w23, p_w24, p_w25
            ) 
            RETURNING id INTO v_id;

            INSERT INTO bsb_plays (
                id,
                id_game,
                uuid,
                username,
                status,
                w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, 
                -- w13, 
                w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25            
            ) VALUES (
                seq_bsb_plays.NEXTVAL,
                v_id,
                v_uuid,
                p_fullname,
                'A',
                p_w1, p_w2, p_w3, p_w4, p_w5, p_w6, p_w7, p_w8, p_w9, p_w10, 
                p_w11, p_w12, 
                -- p_w13, 
                p_w14, p_w15, p_w16, p_w17, p_w18, p_w19, p_w20, 
                p_w21, p_w22, p_w23, p_w24, p_w25
            );

        END IF;

        COMMIT;

        get_deal(
            p_code,
            NULL,
            NULL,
            NULL,
            0,
            1,
            r_deals
        );        

    END;

    /*PLAYER*/

    FUNCTION bot_match_count(
        p_id bsb_games.id%TYPE,
        p_i PLS_INTEGER,
        p_status bsb_games.m1%TYPE
    ) RETURN PLS_INTEGER AS
        v_count PLS_INTEGER;
    BEGIN
        SELECT 
            (SELECT COUNT(p.w1) FROM bsb_plays p WHERE p.id_game = g.id AND p.w1 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m1 = p_status) +
            (SELECT COUNT(p.w2) FROM bsb_plays p WHERE p.id_game = g.id AND p.w2 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m2 = p_status) +
            (SELECT COUNT(p.w3) FROM bsb_plays p WHERE p.id_game = g.id AND p.w3 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m3 = p_status) +
            (SELECT COUNT(p.w4) FROM bsb_plays p WHERE p.id_game = g.id AND p.w4 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m4 = p_status) +
            (SELECT COUNT(p.w5) FROM bsb_plays p WHERE p.id_game = g.id AND p.w5 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m5 = p_status) +
            (SELECT COUNT(p.w6) FROM bsb_plays p WHERE p.id_game = g.id AND p.w6 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m6 = p_status) +
            (SELECT COUNT(p.w7) FROM bsb_plays p WHERE p.id_game = g.id AND p.w7 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m7 = p_status) +
            (SELECT COUNT(p.w8) FROM bsb_plays p WHERE p.id_game = g.id AND p.w8 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m8 = p_status) +
            (SELECT COUNT(p.w9) FROM bsb_plays p WHERE p.id_game = g.id AND p.w9 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m9 = p_status) +
            (SELECT COUNT(p.w10) FROM bsb_plays p WHERE p.id_game = g.id AND p.w10 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m10 = p_status) +
            (SELECT COUNT(p.w11) FROM bsb_plays p WHERE p.id_game = g.id AND p.w11 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m11 = p_status) +
            (SELECT COUNT(p.w12) FROM bsb_plays p WHERE p.id_game = g.id AND p.w12 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m12 = p_status) +
            (SELECT COUNT(p.w13) FROM bsb_plays p WHERE p.id_game = g.id AND p.w13 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m13 = p_status) +
            (SELECT COUNT(p.w14) FROM bsb_plays p WHERE p.id_game = g.id AND p.w14 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m14 = p_status) +
            (SELECT COUNT(p.w15) FROM bsb_plays p WHERE p.id_game = g.id AND p.w15 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m15 = p_status) +
            (SELECT COUNT(p.w16) FROM bsb_plays p WHERE p.id_game = g.id AND p.w16 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m16 = p_status) +
            (SELECT COUNT(p.w17) FROM bsb_plays p WHERE p.id_game = g.id AND p.w17 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m17 = p_status) +
            (SELECT COUNT(p.w18) FROM bsb_plays p WHERE p.id_game = g.id AND p.w18 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m18 = p_status) +
            (SELECT COUNT(p.w19) FROM bsb_plays p WHERE p.id_game = g.id AND p.w19 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m19 = p_status) +
            (SELECT COUNT(p.w20) FROM bsb_plays p WHERE p.id_game = g.id AND p.w20 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m20 = p_status) +
            (SELECT COUNT(p.w21) FROM bsb_plays p WHERE p.id_game = g.id AND p.w21 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m21 = p_status) +
            (SELECT COUNT(p.w22) FROM bsb_plays p WHERE p.id_game = g.id AND p.w22 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m22 = p_status) +
            (SELECT COUNT(p.w23) FROM bsb_plays p WHERE p.id_game = g.id AND p.w23 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m23 = p_status) +
            (SELECT COUNT(p.w24) FROM bsb_plays p WHERE p.id_game = g.id AND p.w24 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m24 = p_status) +
            (SELECT COUNT(p.w25) FROM bsb_plays p WHERE p.id_game = g.id AND p.w25 = DECODE(p_i, 1, g.w1, 2, g.w2, 3, g.w3, 4, g.w4, 5, g.w5, 6, g.w6, 7, g.w7, 8, g.w8, 9, g.w9, 10, g.w10, 11, g.w11, 12, g.w12, 13, g.w13, 14, g.w14, 15, g.w15, 16, g.w16, 17, g.w17, 18, g.w18, 19, g.w19, 20, g.w20, 21, g.w21, 22, g.w22, 23, g.w23, 24, g.w24, 25, g.w25) AND p.m25 = p_status) 
        INTO v_count
        FROM bsb_games g WHERE id = p_id;

        RETURN v_count;   

    END;

    PROCEDURE get_play(
        p_id bsb_plays.id%TYPE,
        p_error VARCHAR2,
        r_result OUT SYS_REFCURSOR
    ) AS
        v_id_game bsb_games.id%TYPE;
        TYPE TN IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
        n TN;
        i PLS_INTEGER := 1;
    BEGIN

        BEGIN

            WHILE (i<26) LOOP
            
                n(i) := 0;
            
                i := i + 1;

            END LOOP;

            SELECT g.id 
            INTO v_id_game 
            FROM bsb_games g 
            WHERE g.id IN (
                SELECT p.id_game 
                FROM bsb_plays p
                WHERE p.id = p_id
                AND p.uuid = g.uuid
            );

            i := 1;

            WHILE (i<26) LOOP
            
                n(i) := bot_match_count(v_id_game,i,'P');
            
                i := i + 1;

            END LOOP;

        EXCEPTION 

            WHEN NO_DATA_FOUND THEN NULL;

        END;        

        OPEN r_result FOR
        SELECT
            p_error AS "error",
            p.id AS "id",
            p.username AS "fullname",
            g.code AS "gamecode",
            g.id AS "id_game", 
            g.tag AS "tag",
            g.title AS "title",
            g.status AS "status",
            (SELECT COUNT(p2.id) FROM bsb_plays p2 WHERE p2.id_game=g.id) AS "players", -- number of players in game
            (
                SELECT p3.username FROM bsb_plays p3 WHERE p3.id_game = g.id AND p3.bingo = (
                    SELECT MIN(p4.bingo) FROM bsb_plays p4 WHERE p4.id_game = g.id
                )
            ) AS "bingo", -- first to claim bingo
            (
                SELECT p3.username FROM bsb_plays p3 WHERE p3.id_game = g.id AND p3.bullshit_bingo = (
                    SELECT MIN(p4.bullshit_bingo) FROM bsb_plays p4 WHERE p4.id_game = g.id
                )
            ) AS "bullshitbingo", -- first to claim bullshitbingo

            p.w1 AS "w1", p.w2 AS "w2", p.w3 AS "w3", p.w4 AS "w4", p.w5 AS "w5", 
            p.w6 AS "w6", p.w7 AS "w7", p.w8 AS "w8", p.w9 AS "w9", p.w10 AS "w10", 
            p.w11 AS "w11", p.w12 AS "w12", p.w13 AS "w13", p.w14 AS "w14", p.w15 AS "w15", 
            p.w16 AS "w16", p.w17 AS "w17", p.w18 AS "w18", p.w19 AS "w19", p.w20 AS "w20", 
            p.w21 AS "w21", p.w22 AS "w22", p.w23 AS "w23", p.w24 AS "w24", p.w25 AS "w25", 
            
            p.m1 AS "m1", p.m2 AS "m2", p.m3 AS "m3", p.m4 AS "m4", p.m5 AS "m5", 
            p.m6 AS "m6", p.m7 AS "m7", p.m8 AS "m8", p.m9 AS "m9", p.m10 AS "m10", 
            p.m11 AS "m11", p.m12 AS "m12", p.m13 AS "m13", p.m14 AS "m14", p.m15 AS "m15", 
            p.m16 AS "m16", p.m17 AS "m17", p.m18 AS "m18", p.m19 AS "m19", p.m20 AS "m20", 
            p.m21 AS "m21", p.m22 AS "m22", p.m23 AS "m23", p.m24 AS "m24", p.m25 AS "m25",

            n(1) AS "n1", n(2) AS "n2", n(3) AS "n3", n(4) AS "n4", n(5) AS "n5", 
            n(6) AS "n6", n(7) AS "n7", n(8) AS "n8", n(9) AS "n9", n(10) AS "n10", 
            n(11) AS "n11", n(12) AS "n12", n(13) AS "n13", n(14) AS "n14", n(15) AS "n15", 
            n(16) AS "n16", n(17) AS "n17", n(18) AS "n18", n(19) AS "n19", n(20) AS "n20", 
            n(21) AS "n21", n(22) AS "n22", n(23) AS "n23", n(24) AS "n24", n(25) AS "n25"

        FROM bsb_plays p 
        JOIN bsb_games g ON p.id_game = g.id 
        WHERE p.id = p_id;

    END;


    PROCEDURE get_play( 
        p_id bsb_plays.id%TYPE,
        r_play OUT SYS_REFCURSOR 
    ) AS
        v_error VARCHAR2(2000 CHAR);
    BEGIN

        get_play(p_id,v_error,r_play);

    END;

    PROCEDURE post_join( 
        p_gamecode bsb_games.code%TYPE, 
        p_username bsb_plays.username%TYPE, 
        r_play OUT SYS_REFCURSOR
    ) AS
        v_id bsb_plays.id%TYPE;
        v_count PLS_INTEGER;
        v_error VARCHAR2(240 CHAR);
        TYPE TW IS TABLE OF VARCHAR2(30 CHAR) INDEX BY PLS_INTEGER;
        w TW;
        g bsb_games%ROWTYPE;
        i PLS_INTEGER;
        a PLS_INTEGER;
        b PLS_INTEGER;
        c bsb_games.w13%TYPE;
    BEGIN

        -- validation: is game code correct?

        SELECT COUNT(id) INTO v_count
        FROM bsb_games WHERE code = TRIM(UPPER(p_gamecode));

        IF v_count = 0 THEN
            v_error := 'Game with such code does not exist';
        END IF;

        -- validation: is game active?

        IF v_error IS NULL THEN

            SELECT COUNT(id) INTO v_count
            FROM bsb_games WHERE code = TRIM(UPPER(p_gamecode)) AND status = 'A';

            IF v_count = 0 THEN
                v_error := 'Game with such code is not active';
            END IF;

        END IF;    

        -- validation: is user unique?

        IF v_error IS NULL THEN

            SELECT COUNT(id) INTO v_count
            FROM bsb_plays WHERE id_game = (SELECT id FROM bsb_games WHERE code = TRIM(UPPER(p_gamecode))) AND username = p_username;

            IF v_count > 0 THEN
                v_error := 'There is another user with the same username in the game already, choose different username';
            END IF;

        END IF;    

        -- new play?

        IF v_error IS NULL THEN

            SELECT * INTO g FROM bsb_games WHERE code = TRIM(UPPER(p_gamecode));

            w(1) := g.w1; w(2) := g.w2; w(3) := g.w3; w(4) := g.w4; w(5) := g.w5; 
            w(6) := g.w6; w(7) := g.w7; w(8) := g.w8; w(9) := g.w9; w(10) := g.w10; 
            w(11) := g.w11; w(12) := g.w12; w(13) := g.w13; w(14) := g.w14; w(15) := g.w15; 
            w(16) := g.w16; w(17) := g.w17; w(18) := g.w18; w(19) := g.w19; w(20) := g.w20; 
            w(21) := g.w21; w(22) := g.w22; w(23) := g.w23; w(24) := g.w24; w(25) := g.w25; 

            i := 0;
            WHILE i<100 LOOP

                a := round(dbms_random.value(1,25));
                b := round(dbms_random.value(1,25));

                IF (a<>13) AND (b<>13) AND (a<>b) THEN

                    c := w(a);
                    w(a) := w(b);
                    w(b) := c;

                END IF;

                i:= i + 1;
            END LOOP;

            INSERT INTO bsb_plays (
                id,
                id_game,
                username,
                status,
                w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, 
                -- w13, 
                w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25            
            ) VALUES (
                seq_bsb_plays.NEXTVAL,
                (SELECT id FROM bsb_games WHERE code = TRIM(UPPER(p_gamecode))),
                p_username,
                'A',
                w(1), w(2), w(3), w(4), w(5), w(6), w(7), w(8), w(9), w(10), w(11), w(12),
                -- w(13),
                w(14), w(15), w(16), w(17), w(18), w(19), w(20), w(21), w(22), w(23), w(24), w(25)
            ) RETURNING id INTO v_id;

            COMMIT;

        END IF;

        IF v_error IS NULL AND v_id IS NOT NULL THEN 

            get_play(v_id, v_error, r_play);

        ELSE 

            OPEN r_play FOR 
            SELECT v_error AS "error" FROM DUAL;

        END IF;

    END;

    PROCEDURE put_mark(
        p_id bsb_plays.id%TYPE, 
        p_m1 bsb_plays.m1%TYPE, p_m2 bsb_plays.m2%TYPE, p_m3 bsb_plays.m3%TYPE, p_m4 bsb_plays.m4%TYPE,p_m5 bsb_plays.m5%TYPE,
        p_m6 bsb_plays.m6%TYPE, p_m7 bsb_plays.m7%TYPE, p_m8 bsb_plays.m8%TYPE, p_m9 bsb_plays.m9%TYPE, p_m10 bsb_plays.m10%TYPE, 
        p_m11 bsb_plays.m11%TYPE, p_m12 bsb_plays.m12%TYPE, p_m13 bsb_plays.m13%TYPE, p_m14 bsb_plays.m14%TYPE, p_m15 bsb_plays.m15%TYPE,
        p_m16 bsb_plays.m16%TYPE, p_m17 bsb_plays.m17%TYPE, p_m18 bsb_plays.m18%TYPE, p_m19 bsb_plays.m19%TYPE, p_m20 bsb_plays.m20%TYPE,
        p_m21 bsb_plays.m21%TYPE, p_m22 bsb_plays.m22%TYPE, p_m23 bsb_plays.m23%TYPE, p_m24 bsb_plays.m24%TYPE, p_m25 bsb_plays.m25%TYPE,
        r_play OUT SYS_REFCURSOR
    ) AS
        v_error VARCHAR2(2000 CHAR);
        v_id bsb_games.id%TYPE;
    BEGIN

        UPDATE bsb_plays SET 
            modified = SYSTIMESTAMP,
            m1=p_m1, m2=p_m2, m3=p_m3, m4=p_m4, m5=p_m5, 
            m6=p_m6, m7=p_m7, m8=p_m8, m9=p_m9, m10=p_m10, 
            m11=p_m11, m12=p_m12, m13=p_m13, m14=p_m14, m15=p_m15, 
            m16=p_m16, m17=p_m17, m18=p_m18, m19=p_m19, m20=p_m20, 
            m21=p_m21, m22=p_m22, m23=p_m23, m24=p_m24, m25=p_m25 
        WHERE id=p_id;

        COMMIT; 

        BEGIN

            SELECT g.id 
            INTO v_id 
            FROM bsb_games g
            JOIN bsb_plays p ON p.id_game = g.id AND p.uuid = g.uuid
            WHERE p.id = p_id;

            bot(v_id);

        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;        

        get_play(p_id,v_error,r_play);

    END;

    /*CHAT*/

    PROCEDURE get_chats(
        p_id bsb_plays.id%TYPE,
        r_chat OUT SYS_REFCURSOR        
    ) AS
    BEGIN

        OPEN r_chat FOR
        SELECT
            c.id AS "id",
            c.status AS "status",
            p.username AS "username",
            c.message AS "message"
        FROM bsb_chats c
        JOIN bsb_plays p ON p.id = c.id_play
        WHERE c.id_game IN (
            SELECT p2.id_game FROM bsb_plays p2 
            WHERE p2.id = p_id
        )
        AND (
                c.status <> 'T'
            OR (
                c.status = 'T'
                AND c.id > (
                    SELECT MAX(c2.id)
                    FROM bsb_chats c2
                    WHERE c2.id_play = c.id_play
                    AND c2.status <> 'T'
                    
                )
            )
        )
        GROUP BY c.id, c.status, p.username, c.message
        ORDER BY c.id DESC
        FETCH NEXT 100 ROWS ONLY;

    END;

    PROCEDURE put_chat(
        p_id bsb_plays.id%TYPE,
        p_status bsb_chats.status%TYPE, -- status (T - typing, B - bot, P - player, D - dealer, N - none)       
        p_message bsb_chats.message%TYPE,
        r_chat OUT SYS_REFCURSOR  
    ) AS
    BEGIN

        IF p_status NOT IN ('N') THEN

            INSERT INTO bsb_chats (id,id_game,id_play,message,status)
            SELECT seq_bsb_chats.NEXTVAL, id_game, id, p_message, p_status 
            FROM bsb_plays 
            WHERE id = p_id
            AND NOT EXISTS (
                SELECT id
                FROM bsb_chats
                WHERE id_play = p_id
                AND status = 'T'
                AND status = p_status
                AND created BETWEEN SYSTIMESTAMP - INTERVAL '10' SECOND AND SYSTIMESTAMP
            );

            COMMIT;

        END IF;

        get_chats(p_id,r_chat);

    END;

   /* BOT */

    PROCEDURE bot(
        p_id bsb_games.id%TYPE,
        p_debug CHAR DEFAULT '0'
    ) AS
        v_count PLS_INTEGER;
        v_target PLS_INTEGER;
        v_i PLS_INTEGER;
        v_fullname bsb_plays.username%TYPE;
        v_id bsb_plays.id%TYPE;

        PROCEDURE log(
            p_log VARCHAR2
        ) AS
        BEGIN
            IF p_debug = '1' THEN
                DBMS_OUTPUT.put_line(p_log);
            END IF;
        END;

         PROCEDURE update_bsb_plays(
            p_id bsb_games.id%TYPE,
            p_status bsb_games.m1%TYPE
        ) AS
        BEGIN

            FOR w IN (
                        SELECT w1 AS w FROM bsb_games WHERE id = p_id AND m1 = p_status
                UNION ALL SELECT w2 AS w FROM bsb_games WHERE id = p_id AND m2 = p_status
                UNION ALL SELECT w3 AS w FROM bsb_games WHERE id = p_id AND m3 = p_status
                UNION ALL SELECT w4 AS w FROM bsb_games WHERE id = p_id AND m4 = p_status
                UNION ALL SELECT w5 AS w FROM bsb_games WHERE id = p_id AND m5 = p_status
                UNION ALL SELECT w6 AS w FROM bsb_games WHERE id = p_id AND m6 = p_status
                UNION ALL SELECT w7 AS w FROM bsb_games WHERE id = p_id AND m7 = p_status
                UNION ALL SELECT w8 AS w FROM bsb_games WHERE id = p_id AND m8 = p_status
                UNION ALL SELECT w9 AS w FROM bsb_games WHERE id = p_id AND m9 = p_status
                UNION ALL SELECT w10 AS w FROM bsb_games WHERE id = p_id AND m10 = p_status
                UNION ALL SELECT w11 AS w FROM bsb_games WHERE id = p_id AND m11 = p_status
                UNION ALL SELECT w12 AS w FROM bsb_games WHERE id = p_id AND m12 = p_status
                UNION ALL SELECT w13 AS w FROM bsb_games WHERE id = p_id AND m13 = p_status
                UNION ALL SELECT w14 AS w FROM bsb_games WHERE id = p_id AND m14 = p_status
                UNION ALL SELECT w15 AS w FROM bsb_games WHERE id = p_id AND m15 = p_status
                UNION ALL SELECT w16 AS w FROM bsb_games WHERE id = p_id AND m16 = p_status
                UNION ALL SELECT w17 AS w FROM bsb_games WHERE id = p_id AND m17 = p_status
                UNION ALL SELECT w18 AS w FROM bsb_games WHERE id = p_id AND m18 = p_status
                UNION ALL SELECT w19 AS w FROM bsb_games WHERE id = p_id AND m19 = p_status
                UNION ALL SELECT w20 AS w FROM bsb_games WHERE id = p_id AND m20 = p_status
                UNION ALL SELECT w21 AS w FROM bsb_games WHERE id = p_id AND m21 = p_status
                UNION ALL SELECT w22 AS w FROM bsb_games WHERE id = p_id AND m22 = p_status
                UNION ALL SELECT w23 AS w FROM bsb_games WHERE id = p_id AND m23 = p_status
                UNION ALL SELECT w24 AS w FROM bsb_games WHERE id = p_id AND m24 = p_status
                UNION ALL SELECT w25 AS w FROM bsb_games WHERE id = p_id AND m25 = p_status
            ) LOOP

                UPDATE bsb_plays SET
                    m1 = CASE WHEN w1 = w.w THEN p_status ELSE m1 END,
                    m2 = CASE WHEN w2 = w.w THEN p_status ELSE m2 END,
                    m3 = CASE WHEN w3 = w.w THEN p_status ELSE m3 END,
                    m4 = CASE WHEN w4 = w.w THEN p_status ELSE m4 END,
                    m5 = CASE WHEN w5 = w.w THEN p_status ELSE m5 END,
                    m6 = CASE WHEN w6 = w.w THEN p_status ELSE m6 END,
                    m7 = CASE WHEN w7 = w.w THEN p_status ELSE m7 END,
                    m8 = CASE WHEN w8 = w.w THEN p_status ELSE m8 END,
                    m9 = CASE WHEN w9 = w.w THEN p_status ELSE m9 END,
                    m10 = CASE WHEN w10 = w.w THEN p_status ELSE m10 END,
                    m11 = CASE WHEN w11 = w.w THEN p_status ELSE m11 END,
                    m12 = CASE WHEN w12 = w.w THEN p_status ELSE m12 END,
                    m13 = CASE WHEN w13 = w.w THEN p_status ELSE m13 END,
                    m14 = CASE WHEN w14 = w.w THEN p_status ELSE m14 END,
                    m15 = CASE WHEN w15 = w.w THEN p_status ELSE m15 END,
                    m16 = CASE WHEN w16 = w.w THEN p_status ELSE m16 END,
                    m17 = CASE WHEN w17 = w.w THEN p_status ELSE m17 END,
                    m18 = CASE WHEN w18 = w.w THEN p_status ELSE m18 END,
                    m19 = CASE WHEN w19 = w.w THEN p_status ELSE m19 END,
                    m20 = CASE WHEN w20 = w.w THEN p_status ELSE m20 END,
                    m21 = CASE WHEN w21 = w.w THEN p_status ELSE m21 END,
                    m22 = CASE WHEN w22 = w.w THEN p_status ELSE m22 END,
                    m23 = CASE WHEN w23 = w.w THEN p_status ELSE m23 END,
                    m24 = CASE WHEN w24 = w.w THEN p_status ELSE m24 END,
                    m25 = CASE WHEN w25 = w.w THEN p_status ELSE m25 END
                WHERE id_game = p_id;

                v_count := SQL%ROWCOUNT;

                log('bsb_plays staatus updated to "' || p_status || '" for "' || v_count || '" rows for word "' || w.w || '"');    

            END LOOP;

        END;

    BEGIN

        log('game id: ' || p_id);

        SELECT COUNT(id) 
        INTO v_target
        FROM bsb_plays where id_game = p_id;

        log('number of bsb_plays: ' || v_target);

        SELECT
        ROUND(
            (SELECT COUNT(id) FROM bsb_plays where id_game = p_id)
            * 50 -- todo: params
            / 100
        )
        INTO v_target
        FROM dual;

        log('auto acceptance target: ' || v_target);

        v_i := 1;
        WHILE v_i <= 25
        LOOP

            v_count := bot_match_count(p_id,v_i,'P');

            log('Pending for ' || v_i || ' => ' || v_count);

            UPDATE bsb_games SET 
                m1 = DECODE(v_i,1,'C',m1),
                m2 = DECODE(v_i,2,'C',m2),
                m3 = DECODE(v_i,3,'C',m3),
                m4 = DECODE(v_i,4,'C',m4),
                m5 = DECODE(v_i,5,'C',m5),
                m6 = DECODE(v_i,6,'C',m6),
                m7 = DECODE(v_i,7,'C',m7),
                m8 = DECODE(v_i,8,'C',m8),
                m9 = DECODE(v_i,9,'C',m9),
                m10 = DECODE(v_i,10,'C',m10),
                m11 = DECODE(v_i,11,'C',m11),
                m12 = DECODE(v_i,12,'C',m12),
                m13 = DECODE(v_i,13,'C',m13),
                m14 = DECODE(v_i,14,'C',m14),
                m15 = DECODE(v_i,15,'C',m15),
                m16 = DECODE(v_i,16,'C',m16),
                m17 = DECODE(v_i,17,'C',m17),
                m18 = DECODE(v_i,18,'C',m18),
                m19 = DECODE(v_i,19,'C',m19),
                m20 = DECODE(v_i,20,'C',m20),
                m21 = DECODE(v_i,21,'C',m21),
                m22 = DECODE(v_i,22,'C',m22),
                m23 = DECODE(v_i,23,'C',m23),
                m24 = DECODE(v_i,24,'C',m24),
                m25 = DECODE(v_i,25,'C',m25)
            WHERE id = p_id 
            AND v_count >= v_target;

            v_count := SQL%ROWCOUNT;

            log('Number of rows updated ' || v_i || ' => ' || v_count);

            v_i := v_i + 1;

        END LOOP;

        -- update bsb_plays
        update_bsb_plays(p_id,'C');

        -- bullshit bingo
        FOR b IN (
            SELECT p.id, p.modified
            FROM bsb_plays p
            WHERE p.id_game = p_id
            AND (
                (p.m1 = 'C' AND p.m7 = 'C' AND p.m13 = 'C' AND p.m19 = 'C' AND p.m25 = 'C')
                OR
                (p.m3 = 'C' AND p.m8 = 'C' AND p.m13 = 'C' AND p.m18 = 'C' AND p.m23 = 'C')
                OR
                (p.m5 = 'C' AND p.m9 = 'C' AND p.m13 = 'C' AND p.m17 = 'C' AND p.m21 = 'C')
                OR
                (p.m11 = 'C' AND p.m12 = 'C' AND p.m13 = 'C' AND p.m14 = 'C' AND p.m15 = 'C')
                OR
                (p.m3 = 'C' AND p.m8 = 'C' AND p.m13 = 'C' AND p.m18 = 'C' AND p.m23 = 'C')
            )    
        ) LOOP

            UPDATE bsb_plays 
            SET bullshit_bingo = b.modified
            WHERE id = b.id
            AND bullshit_bingo IS NULL
            RETURNING username INTO v_fullname;

            IF SQL%ROWCOUNT > 0 THEN 

                SELECT p.id 
                INTO v_id
                FROM bsb_plays p
                WHERE p.id_game = p_id
                AND uuid IN (
                    SELECT uuid FROM bsb_games WHERE id = p_id
                )
                ;

                INSERT INTO bsb_chats (id, status, id_game, id_play, message)
                SELECT 
                    seq_bsb_chats.NEXTVAL,
                    'B',
                    p_id,
                    p.id,
                    p.username || ' has the Bullshit Bingo!' 
                FROM bsb_plays p
                WHERE p.id_game = p_id
                AND p.uuid IN (
                    SELECT uuid FROM bsb_games WHERE id = p_id
                )
                ;

                log('bullshit bingo "' || v_fullname || '"');

            END IF;

        END LOOP;

        COMMIT;

    END;

END pck_bsb;
/
