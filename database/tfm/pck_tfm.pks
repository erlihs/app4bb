CREATE OR REPLACE PACKAGE pck_tfm IS -- The Flow Master

    PROCEDURE get_keys( -- Get keys for the Flow Master
        p_search VARCHAR2 DEFAULT NULL, -- Search term
        p_offset PLS_INTEGER DEFAULT 0, -- Offset for pagination
        p_limit PLS_INTEGER DEFAULT 10, -- Limit for pagination
        r_keys OUT SYS_REFCURSOR -- List of keys [{ukid: guid, name: name, description: description}]
    );

    PROCEDURE post_key(
        p_ukid VARCHAR2, -- Unique key identifier
        p_name VARCHAR2, -- Name of the key
        p_key VARCHAR2, -- Value of the key
        p_description VARCHAR2, -- Description of the key
        r_errors OUT SYS_REFCURSOR -- List of errors [{name: name, message: message}]
    );

    PROCEDURE get_agents( -- Get agents for the Flow Master
        p_search VARCHAR2 DEFAULT NULL, -- Search term
        p_offset PLS_INTEGER DEFAULT 0, -- Offset for pagination
        p_limit PLS_INTEGER DEFAULT 10, -- Limit for pagination
        r_agents OUT SYS_REFCURSOR -- List of agents [{uaid: guid, name: name, description: description, options: {}, coins: 1.00}]
    );

    PROCEDURE get_flows( -- Get flows for the Flow Master
        p_search VARCHAR2 DEFAULT NULL, -- Search term
        p_offset PLS_INTEGER DEFAULT 0, -- Offset for pagination
        p_limit PLS_INTEGER DEFAULT 10, -- Limit for pagination
        r_flows OUT SYS_REFCURSOR -- List of flows [{ufid: guid, name: name, description: description, options: {}, coins: 1.00}]
    );

    PROCEDURE get_runs( -- Get runs for the Flow Master
        p_search VARCHAR2 DEFAULT NULL, -- Search term
        p_offset PLS_INTEGER DEFAULT 0, -- Offset for pagination
        p_limit PLS_INTEGER DEFAULT 10, -- Limit for pagination
        r_runs OUT SYS_REFCURSOR -- List of runs [{urid: guid, name: name, started: 20251231T1612, duration: 1m 20s, coins: 1.00}]
    );

    PROCEDURE get_balance( -- Get balance for the Flow Master
        r_balance OUT SYS_REFCURSOR -- List of balance [{period: H, used: 0.30, limit: 1.00, balance: 0.70}]
    );

END;
/