CREATE OR REPLACE PACKAGE pck_bsb AS -- package for public app

    /*DEALER*/

    PROCEDURE get_tags( -- procedure gets list of tags
        r_tags OUT SYS_REFCURSOR -- list of tags
    );

    PROCEDURE get_deals( -- gets list of deals
        p_tag bsb_games.tag%TYPE DEFAULT NULL, -- tag
        p_title bsb_games.title%TYPE DEFAULT NULL, -- title
        p_offset PLS_INTEGER DEFAULT 0, -- number of rows to skip
        p_limit PLS_INTEGER DEFAULT 10, -- number of rows to return
        r_deals OUT SYS_REFCURSOR -- game data
    );     

    PROCEDURE put_deal( -- procedure modifies game
        p_code bsb_games.code%TYPE, -- code
        p_tag bsb_games.tag%TYPE, -- tag
        p_fullname bsb_plays.username%TYPE, -- Full name
        p_title bsb_games.title%TYPE, -- title
        p_status bsb_games.status%TYPE, -- status
        p_w1 bsb_games.w1%TYPE, p_w2 bsb_games.w2%TYPE, p_w3 bsb_games.w3%TYPE, p_w4 bsb_games.w4%TYPE,p_w5 bsb_games.w5%TYPE,
        p_w6 bsb_games.w6%TYPE, p_w7 bsb_games.w7%TYPE, p_w8 bsb_games.w8%TYPE, p_w9 bsb_games.w9%TYPE, p_w10 bsb_games.w10%TYPE, 
        p_w11 bsb_games.w11%TYPE, p_w12 bsb_games.w12%TYPE, p_w13 bsb_games.w13%TYPE, p_w14 bsb_games.w14%TYPE, p_w15 bsb_games.w15%TYPE,
        p_w16 bsb_games.w16%TYPE, p_w17 bsb_games.w17%TYPE, p_w18 bsb_games.w18%TYPE, p_w19 bsb_games.w19%TYPE, p_w20 bsb_games.w20%TYPE,
        p_w21 bsb_games.w21%TYPE, p_w22 bsb_games.w22%TYPE, p_w23 bsb_games.w23%TYPE, p_w24 bsb_games.w24%TYPE, p_w25 bsb_games.w25%TYPE,
        r_deals OUT SYS_REFCURSOR -- game data
    );

    /*PLAYER*/

    PROCEDURE get_play( -- procedure gets play data
        p_id bsb_plays.id%TYPE, -- play id
        r_play OUT SYS_REFCURSOR -- game data
    );

    PROCEDURE post_join( -- procedure joins player to the play
        p_gamecode bsb_games.code%TYPE, -- game code
        p_username bsb_plays.username%TYPE, -- user name
        r_play OUT SYS_REFCURSOR -- game data
    );

    PROCEDURE put_mark( -- procedure gets user input
        p_id bsb_plays.id%TYPE, -- play ID
        p_m1 bsb_plays.m1%TYPE, p_m2 bsb_plays.m2%TYPE, p_m3 bsb_plays.m3%TYPE, p_m4 bsb_plays.m4%TYPE,p_m5 bsb_plays.m5%TYPE,
        p_m6 bsb_plays.m6%TYPE, p_m7 bsb_plays.m7%TYPE, p_m8 bsb_plays.m8%TYPE, p_m9 bsb_plays.m9%TYPE, p_m10 bsb_plays.m10%TYPE, 
        p_m11 bsb_plays.m11%TYPE, p_m12 bsb_plays.m12%TYPE, p_m13 bsb_plays.m13%TYPE, p_m14 bsb_plays.m14%TYPE, p_m15 bsb_plays.m15%TYPE,
        p_m16 bsb_plays.m16%TYPE, p_m17 bsb_plays.m17%TYPE, p_m18 bsb_plays.m18%TYPE, p_m19 bsb_plays.m19%TYPE, p_m20 bsb_plays.m20%TYPE,
        p_m21 bsb_plays.m21%TYPE, p_m22 bsb_plays.m22%TYPE, p_m23 bsb_plays.m23%TYPE, p_m24 bsb_plays.m24%TYPE, p_m25 bsb_plays.m25%TYPE,
        r_play OUT SYS_REFCURSOR -- game data
    );    

    /*CHAT*/

    PROCEDURE get_chats( -- procedure gets chat 
        p_id bsb_plays.id%TYPE, -- game ID
        r_chat OUT SYS_REFCURSOR  --  chat data
    );

    PROCEDURE put_chat( -- procedure sends comment to chat
        p_id bsb_plays.id%TYPE, -- game ID
        p_status bsb_chats.status%TYPE, -- status (T - typing, B - bot, P - player, D - dealer, N - none)
        p_message bsb_chats.message%TYPE, -- message text
        r_chat OUT SYS_REFCURSOR  --  chat data
    );

    /*BOT*/

    PROCEDURE bot(
        p_id bsb_games.id%TYPE,
        p_debug CHAR DEFAULT '0'
    );

END pck_bsb;
/