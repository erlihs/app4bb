# Sending emails

For the next features we will need emails to be sent out for password recovery and email conformation. We will implement that using the Oracle Database on Oracle Cloud Infrastructure.

SMTP, or Simple Mail Transfer Protocol, is the standard protocol used for sending emails across the Internet. Its main function is to enable email servers to communicate with each other to relay messages from the sender to the recipient's server. SMTP is used primarily for sending (outgoing) emails, while other protocols like IMAP or POP3 are typically used for retrieving (incoming) emails. SMTP operates on the principle of a session-based exchange of text commands and responses to transfer email reliably and efficiently.

it is possible to send SMTP messages from an Oracle Database. Oracle provides a package called `UTL_SMTP` that allows you to send emails using the Simple Mail Transfer Protocol (SMTP) directly from the Oracle Database. This feature can be useful for sending notifications, alerts, or reports generated within the database.

## Enabling sending emails from Oracle Cloud Infrastructure

See how to [send email with oci](https://blogs.oracle.com/cloud-infrastructure/post/step-by-step-instructions-to-send-email-with-oci-email-delivery)

## Example via `pck_api_emails` of [odb4bb](https://github.com/erlihs/odb4bb)

```plsql
declare
    v_id APP_EMAILS.ID%TYPE;
begin
    pck_api_emails.mail(v_id,'tests@test.com','Test Test','Test','<p>Test <strong>this</strong></p>');
    pck_api_emails.send(v_id);
end;
/

```

## Feature

When user is singned up, it has status `N` and confirmation e-mail is sent out. When user opens link from the e-mail, it gets confirmed and status updated to `A`.

## Api

1. Create procedure `post_confirmemail`

::: details `./database/app/pck_api.pks`

```plsql
    PROCEDURE post_confirmemail( -- Procedure confirms email address
        p_confirmtoken APP_TOKENS.TOKEN%TYPE, --  Email confirmation token (sent by e-mail)
        r_error OUT VARCHAR2 -- Error (NULL if sucess)
    );
```

:::

::: details `./database/app/pck_api.pkb`

```plsql
    PROCEDURE post_confirmemail(
        p_confirmtoken APP_TOKENS.TOKEN%TYPE,
        r_error OUT VARCHAR2
    ) AS
        v_uuid APP_USERS.UUID%TYPE;
    BEGIN

        BEGIN
            SELECT uuid
            INTO  v_uuid
            FROM app_users
            WHERE id IN (
                SELECT id_user
                FROM app_tokens
                WHERE token = p_confirmtoken
                AND expiration > SYSTIMESTAMP
            );
        EXCEPTION
            WHEN NO_DATA_FOUND THEN r_error := 'Invalid token';
        END;

        IF r_error IS NOT NULL THEN

            pck_api_audit.wrn('Confirm emmail failed', pck_api_audit.mrg('confirmtoken', '********'), v_uuid);

        ELSE

            UPDATE app_users
            SET status = 'A'
            WHERE uuid = v_uuid;

            COMMIT;

            pck_api_audit.inf('Confirm email success', pck_api_audit.mrg('confirmtoken', '********'), v_uuid);

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            r_error := 'Internal error';
            pck_api_audit.err('Confirm email error', pck_api_audit.mrg('confirmtoken', '********'), v_uuid);
    END;

```

:::

2. Add method to `@/src/api/index.ts`

```ts
...
export type ConfirmEmailResponse = {
  error?: string
}
...
  async confirmEmail(confirmtoken: string): Promise<HttpResponse<ConfirmEmailResponse>> {
    return await http.post('confirmemail/', { confirmtoken })
  },
...
```

## Store

Add method in auth store `@/store/app/auth.ts`

```ts
    async function confirmEmail(confirmToken: string): Promise<boolean> {
      startLoading()
      const { data } = await appApi.confirmEmail(confirmToken)
      if (data?.error) {
        setError('Email confirmation failed')
      } else {
        setInfo('Email confirmed')
      }
      stopLoading()
      return !data?.error
    }
..
    return {
        ...
        confirmEmail,
    }
```

## View

Create view for confirming emails `@/pages/confirm-email/[id].vue`

```vue
<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" :md="4">
        <h1 class="mb-4">{{ t('Confirm email') }}</h1>
        <v-btn @click="router.push('/')">{{ t('Ok') }}</v-btn>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
definePage({ meta: { role: 'restricted' } })
const authStore = useAuthStore()
const router = useRouter()
const route = useRoute()
const { t } = useI18n()

onMounted(async () => {
  const token = (route.params as { id: string }).id
  await authStore.confirmEmail(token)
})
</script>
```
