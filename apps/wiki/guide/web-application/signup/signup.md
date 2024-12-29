# Sign up

Create self registration feature.

## Api

1. Create Api method for sign-up.

::: details `/database/app/pck_app.pks`

```plsql
    PROCEDURE post_signup( -- Procedure registers and authenticates user and returns token and context data
        p_username APP_USERS.USERNAME%TYPE, -- User name (e-mail address)
        p_password APP_USERS.PASSWORD%TYPE, -- Password
        p_fullname APP_USERS.FULLNAME%TYPE, -- Full name
        r_access_token OUT APP_TOKENS.TOKEN%TYPE, -- Token
        r_refresh_token OUT APP_TOKENS.TOKEN%TYPE, -- Refresh token
        r_user OUT SYS_REFCURSOR, -- User data
        r_error OUT VARCHAR2 -- Error (NULL if success)
    );
...
```

:::

::: details `/database/app/pck_app.pkb`

```plsql
...
    PROCEDURE post_signup(
        p_username APP_USERS.USERNAME%TYPE,
        p_password APP_USERS.PASSWORD%TYPE,
        p_fullname APP_USERS.FULLNAME%TYPE,
        r_access_token OUT APP_TOKENS.TOKEN%TYPE,
        r_refresh_token OUT APP_TOKENS.TOKEN%TYPE,
        r_user OUT SYS_REFCURSOR,
        r_error OUT VARCHAR2
    ) AS
        v_uuid APP_USERS.UUID%TYPE;
        v_password app_users.password%TYPE := pck_api_auth.pwd(p_password);
        v_id_email APP_EMAILS.ID%TYPE;
        v_confirm_token APP_TOKENS.TOKEN%TYPE;
    BEGIN

       BEGIN

            SELECT uuid
            INTO v_uuid
            FROM app_users
            WHERE username = UPPER(TRIM(p_username));

        EXCEPTION

            WHEN NO_DATA_FOUND THEN
                NULL;

        END;

        IF NOT REGEXP_LIKE (p_username,'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN

            r_error := 'Username must be a valid email address';
            pck_api_audit.wrn('Signup failed - invalid email address', pck_api_audit.mrg('username', p_username, 'fullname', p_fullname, 'password', '********'), v_uuid);

        ELSIF p_username IS NULL OR p_password IS NULL OR p_fullname IS NULL THEN

            r_error := 'Missing parameters';
            pck_api_audit.wrn('Signup failed - missing parameters', pck_api_audit.mrg('username', p_username, 'fullname', p_fullname, 'password', '********'), v_uuid);

        ELSIF v_uuid IS NOT NULL THEN

            r_error := 'Such username already exists';
            pck_api_audit.wrn('Signup failed - user already exists', pck_api_audit.mrg('username', p_username, 'fullname', p_fullname, 'password', '********'), v_uuid);

        ELSE -- success

            INSERT INTO app_users (id, status, username, password, fullname, accessed)
            VALUES (
                seq_app_users.NEXTVAL,
                'N',
                UPPER(TRIM(p_username)),
                v_password,
                p_fullname,
                SYSTIMESTAMP
            ) RETURNING uuid INTO v_uuid;

            COMMIT;

            pck_api_auth.reset(v_uuid, 'A');
            pck_api_auth.reset(v_uuid, 'R');
            r_access_token := pck_api_auth.token(v_uuid, 'A');
            r_refresh_token := pck_api_auth.token(v_uuid, 'R');

            user(v_uuid, r_user);

            v_confirm_token := pck_api_auth.token(v_uuid, 'E');

            pck_api_emails.mail(v_id_email,TRIM(p_username),p_fullname,'Confirm email address!','<h1>Confirm email!</h1><p>Please, confirm your email address by pressing this <a href="' || pck_api_settings.read('APP_DOMAIN') || '/confirm-email/' || v_confirm_token || '">link</a></p>');
            BEGIN
                pck_api_emails.send(v_id_email);
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;
            END;

            pck_api_audit.inf('Signup successful', pck_api_audit.mrg('username', p_username, 'fullname', p_fullname, 'password', '********'), v_uuid);

        END IF;

     EXCEPTION
        WHEN OTHERS THEN
            r_error := 'Internal error';
            r_access_token := NULL;
            r_refresh_token := NULL;
            pck_api_audit.err('Signup error', pck_api_audit.mrg('username', p_username, 'fullname', p_fullname, 'password', '********'), v_uuid);
    END;

...
```

:::

2. Add sign-up method to `@/api/index.ts`

```ts
...
  async signup(username: string, password: string, fullname: string): Promise<HttpResponse<AuthResponse>> {
    return await http.post('signup/', { username, password, fullname })
  },

```

## Store

Add signup method to `@/store/app/auth.ts`

```ts
...
    async function signup(username: string, password: string, fullname: string): Promise<boolean> {
      startLoading()
      const { data, status, error } = await appApi.signup(username, password, fullname)
      if (error || data?.error) {
        setError(error?.message || data?.error || 'An unknown error occurred')
      } else if (data) {
        accessToken.value = data.accessToken
        Cookies.set('refresh_token', data.refreshToken, refreshCookieOptions)
        isAuthenticated.value = !!accessToken.value
        user.value = {
          ...defaultUser,
          ...data.user?.[0],
          privileges: data.user?.[0]?.privileges || []
        }
      }
      stopLoading()
      return isAuthenticated.value
    }
...
  return {
...
    signup,
...
```

## View

Create signup view

::: details `@/pages/signup.vue`
<<< ../../../../src/pages/signup.vue
:::

## Signup link

Add link to `@/pages/login.vue`

```vue
...
<br />
<br />
{{ t('not.registered.yet') }}
<a href="/signup">{{t('sign.up')}}</a>
...
```
