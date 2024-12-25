# Oracle Database and Oracle Rest Data Services

This article includes various techniques and tips.

## Read bearer token

Get bearer token in procedure called from ORDS.

```plsql
    AS
        v_token VARCHAR2(2000 CHAR) := REPLACE(OWA_UTIL.GET_CGI_ENV('Authorization'),'Bearer ','');
```

## Respond with specific status

Use `owa_util.status_line` to output specific HTTP status. Note, that procedure must return immediately after this line.

```plsql
        owa_util.status_line(nstatus=>401, creason=>'Unauthorized', bclose_header=>true);
```

## Provide binary content for download

Use this construction to provide file for download:

```plsql
    ...

    OWA_UTIL.MIME_HEADER(v_mime_type, FALSE);
    HTP.P ('Content-length: ' || v_file_size);
    HTP.p('Content-Disposition: filename="' || v_file_name || '"');
    OWA_UTIL.HTTP_HEADER_CLOSE;
    WPG_DOCLOAD.DOWNLOAD_FILE(v_file);

  END;
```

## Output json data

Add `{}` before alias to output data as JSON, not as text with escape `\`.

```plsql
    ...

    OPEN r_json FOR
    SELECT
      '{"a": "b", "b": 1}' AS "{}data"
    FROM dual;

    ...
```
