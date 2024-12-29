# Recover password

## Database

1. Create two methods for password recovery and reset

::: details `/database/app/pck_app.pks`

```plsql
   PROCEDURE post_recoverpassword( -- Procedure initiates sending of email to recover password
        p_username APP_USERS.USERNAME%TYPE, -- Username (e-mail address)
        r_error OUT VARCHAR2 -- Error (NULL if sucess)
    );

    PROCEDURE post_resetpassword( -- Procedure resets user password
        p_username APP_USERS.USERNAME%TYPE, -- Username (e-mail address)
        p_password APP_USERS.PASSWORD%TYPE, -- Password
        p_recovertoken APP_TOKENS.TOKEN%TYPE, --  Password recovery token (sent by e-mail)
        r_accesstoken OUT VARCHAR2, -- Access token
        r_refreshtoken OUT VARCHAR2, -- Refresh token
        r_user OUT SYS_REFCURSOR, -- User data
        r_error OUT VARCHAR2 -- Error (NULL if success)
    );
```

:::

::: details `/database/app/pck_app.pkb`

```plsql
   PROCEDURE post_recoverpassword(
        p_username APP_USERS.USERNAME%TYPE,
        r_error OUT VARCHAR2
    ) AS
        v_id_email APP_EMAILS.ID%TYPE;
        v_uuid APP_USERS.UUID%TYPE;
        v_fullname APP_USERS.FULLNAME%TYPE;
        v_password_token APP_TOKENS.TOKEN%TYPE;
    BEGIN

        UPDATE app_users
        SET status = 'N'
        WHERE username = TRIM(UPPER(p_username))
        RETURNING uuid, fullname INTO v_uuid, v_fullname;

        IF SQL%ROWCOUNT = 1 THEN

           v_password_token := pck_api_auth.token(v_uuid, 'R');

            pck_api_emails.mail(v_id_email,TRIM(p_username),v_fullname,'Recover password!','<h1>Recover password!</h1><p>Recover your password address by pressing this <a href="' || pck_api_settings.read('APP_DOMAIN') || '/reset-password/' || v_password_token || '">link</a></p>');
            BEGIN
                pck_api_emails.send(v_id_email);
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;
            END;

            pck_api_audit.inf('Recover password request successful', pck_api_audit.mrg('username', p_username), v_uuid);

        ELSE

            r_error := 'Wrong username';
            pck_api_audit.wrn('Recover password request failed', pck_api_audit.mrg('username', p_username), v_uuid);

        END IF;

     EXCEPTION
        WHEN OTHERS THEN
            r_error := 'Internal error';
            pck_api_audit.err('Recover password request error', pck_api_audit.mrg('username', p_username), v_uuid);
    END;

    PROCEDURE post_resetpassword(
        p_username APP_USERS.USERNAME%TYPE,
        p_password APP_USERS.PASSWORD%TYPE,
        p_recovertoken APP_TOKENS.TOKEN%TYPE,
        r_accesstoken OUT VARCHAR2,
        r_refreshtoken OUT VARCHAR2,
        r_user OUT SYS_REFCURSOR,
        r_error OUT VARCHAR2
    ) AS
        v_id_user APP_USERS.ID%TYPE;
        v_uuid APP_USERS.UUID%TYPE;
        c_salt VARCHAR2(32 CHAR) := DBMS_RANDOM.STRING('X', 32);
        v_password app_users.password%TYPE := c_salt || DBMS_CRYPTO.HASH(UTL_RAW.CAST_TO_RAW(TRIM(p_password) || c_salt),4);
    BEGIN

        BEGIN
            SELECT id, uuid
            INTO v_id_user, v_uuid
            FROM app_users
            WHERE id IN (
                SELECT id_user
                FROM app_tokens
                WHERE token = p_recovertoken
                AND id_token_type = 'R'
                AND expiration > SYSTIMESTAMP
            );
        EXCEPTION
            WHEN NO_DATA_FOUND THEN r_error := 'Invalid token';
        END;

        IF r_error IS NOT NULL THEN

            pck_api_audit.wrn('Reset password', pck_api_audit.mrg('username', p_username,'password','********','recover_token','********'), v_uuid);

        ELSE -- valid token

            UPDATE app_users SET
                password = v_password,
                attempts = 0,
                status = 'A',
                accessed = SYSTIMESTAMP
            WHERE id = v_id_user;

            COMMIT;

            pck_api_auth.reset(v_uuid, 'A');
            pck_api_auth.reset(v_uuid, 'R');
            r_accesstoken := pck_api_auth.token(v_uuid, 'A');
            r_refreshtoken := pck_api_auth.token(v_uuid, 'R');

            app_user(v_uuid, r_user);

            pck_api_audit.inf('Reset password successful', pck_api_audit.mrg('username', p_username,'password','********','recoverytoken','********'), v_uuid);

        END IF;

     EXCEPTION
        WHEN OTHERS THEN
            r_error := 'Internal error';
            r_accesstoken := NULL;
            r_refreshtoken := NULL;
            pck_api_audit.err('Reset password error', pck_api_audit.mrg('username', p_username,'password','********','recoverytoken','********'), v_uuid);
    END;
```

:::

2. Add methods to `@/api/index.ts`

```ts
  async recoverPassword(username: string): Promise<HttpResponse<VoidResponse>> {
    return await http.post('recoverpassword/', { username })
  },

  async resetPassword(username: string, password: string, recovertoken: string): Promise<HttpResponse<AuthResponse>> {
    return await http.post('resetpassword/', { username, password, recovertoken })
  },

```

## Store

```ts
async function recoverPassword(username: string): Promise<boolean> {
  startLoading()
  const { data } = await appApi.recoverPassword(username)
  if (data?.error) {
    setError('password.recovery.failed')
  } else {
    setInfo('password.recovery.email.sent')
  }
  stopLoading()
  return !data?.error
}

async function resetPassword(
  username: string,
  password: string,
  recoverToken: string,
): Promise<boolean> {
  startLoading()
  const { data, status, error } = await appApi.resetPassword(username, password, recoverToken)
  if (error) {
    accessToken.value = ''
    Cookies.remove('refresh_token', refreshCookieOptions)
    isAuthenticated.value = false
    if (status == 401) {
      setError('invalid.username.or.password')
    } else {
      setWarning(error.message)
    }
  } else if (data) {
    accessToken.value = data.accesstoken
    Cookies.set('refresh_token', data.refreshtoken, refreshCookieOptions)
    isAuthenticated.value = !!accessToken.value
    user.value = {
      ...defaultUser,
      ...data.user?.[0],
      privileges: data.user?.[0]?.privileges || [],
    }
    setInfo('password.reset')
  }
  stopLoading()
  return isAuthenticated.value
}
```

## Views

::: details `@/pages/recover-password.vue`
<<< ../../../../src/pages/recover-password.vue
:::

::: details `@/pages/reset-password/[token].vue`
<<< ../../../../src/pages/reset-password/[token].vue
:::

## Login view

Add link to start password recovery in `@/src/pages/login.vue`

```vue
{{ t('not.registered.yet') }}
<a href="/signup">{{ t('sign.up') }}</a>
|
<a href="/recover-password">{{ t('forgot.password') }}</a>
```
