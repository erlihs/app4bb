# Auditing

## Overview

Application need to provide such capabilities as:

- record events
- intercept and record errors
- track page and api load time

Audit data needs to be collected and sent to api in bulk.

## API

For auditing purposes add `post_audit` method.

1. Package `/database/app/pck_app.pks` specification.

```plsql
--
    PROCEDURE post_audit( -- Procedure logs user activity (PUBLIC)
        p_data CLOB --  Audit data in JSON format [{severity, action, details, created}]
    );
--
```

2. Package `/database/app/pck_app.pks` body.

```plsql
--
    PROCEDURE post_audit(
        p_data CLOB
    ) AS
        v_uuid app_users.uuid%TYPE := pck_api_auth.uuid;
    BEGIN
        IF v_uuid IS NULL THEN
            pck_api_audit.wrn('Audit error', 'User not authenticated');
        END IF;

        pck_api_audit.audit(p_data, v_uuid);

    END;
--
```

3. Add method to `@/api/index.ts`

```ts
// ...
export type AuditData = {
  severity: string
  action: string
  details?: string
  created?: string
}
// ...
  async audit(data: AuditData[]): Promise<HttpResponse<void>> {
    return await http.post('audit/', {data : JSON.stringify(data) })
  },
// ...
```

## Store

1. Create new store for processing audit records

Store will provide methods `inf`, `wrn`, `err` as well as handling of auto save of audit records.

::: details `@/stores/app/audit.ts`
<<< ../../../src/stores/app/audit.ts
:::

2. Append the new audit store to `@/store/index.ts`

```ts
// ...
import { useAuditStore } from './app/audit'
// ...
export const useAppStore = defineStore('app', () => {
  const audit = useAuditStore()
// ...
  return {
    audit,
// ...
  }
```

## Error intercpetion

1. Create error handler for interception of errors.

::: details `@/plugins/errors.ts`
<<< ../../../src/plugins/errors.ts
:::

2. Add error handler to `@/main.ts`

```ts{2,5}
// ...
import { errorHandler } from './plugins/errors'

const app = createApp(App)
app.config.errorHandler = errorHandler
// ...
```

From now on any Vue error will be passed to common audit store and preserved and sent to backend.

## Performance - page loads

1. Create threshold parameter, e.g. 250 ms, in `./.env.production` and `./.env.development.local` to audit cases where page loads longer that the set threshold.

```ini
VITE_PERFORMANCE_PAGE_LOAD_THRESHOLD_IN_MS = 250
```

2. Add logic in `@/router/index.ts` to track this information

```ts{3,7-13}
// ...
router.beforeEach(async (to) => {
  to.meta.performance = performance.now()
// ...
})

router.afterEach((to) => {
  const duration: number = performance.now() - (to.meta.performance as number)
  if (duration >= import.meta.env.VITE_PERFORMANCE_PAGE_LOAD_THRESHOLD_IN_MS) {
   const appAudit = useAuditStore()
   appAudit.wrn('Page load time threshold exceeded', `Route ${to.path} took ${duration}ms`)
  }
})
// ...
```

## Performance - API calls

1. Create threshold parameter, e.g. 250 ms, in `./.env.production` and `./.env.development.local` to audit cases where API calls take longer that the set threshold.

```ini
VITE_PERFORMANCE_API_CALL_THRESHOLD_IN_MS = 250
```

2. Add logic in HTTP interceptors to detect slow API calls in `@\composables\http.ts`

```ts{4,13-17}
// ...
  instance.interceptors.request.use(
    (config) => {
      config.headers['request-startTime'] = performance.now()
// ...
      return config
    },
    (error) => Promise.reject(error)
  )

  instance.interceptors.response.use(
    (response) => {
      // ...
      const duration = performance.now() - (response.config.headers['request-startTime'] as number)
      if (duration >= import.meta.env.VITE_PERFORMANCE_API_CALL_THRESHOLD_IN_MS) {
        const appAudit = useAuditStore()
        appAudit.wrn('API call time threshold exceeded', `API ${response.config.url} took ${duration}ms`)
      }
      return response
    },
// ...
```

## Usage

Add audit test card to `@/pages/sandbox/index.ts`

```vue
  <v-card class="mt-6">
    <v-card-title>Test audit</v-card-title>
    <v-card-text
      >Test audit capabilities. In stash: <strong>{{ appStore.audit.count }}</strong></v-card-text
    >
    <v-card-actions>
      <v-btn
        color="info"
        @click="appStore.audit.inf('This is info message', 'This is info message details')"
        >Test info</v-btn
      >
      <v-btn
        color="warning"
        @click="appStore.audit.wrn('This is warning message', 'This is warning message details')"
        >Test warning</v-btn
      >
      <v-btn color="error" @click="error()">Test error</v-btn>
      <v-spacer></v-spacer>
      <v-btn @click="appStore.audit.save()">Save</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script setup lang="ts">
...
// AUDIT
const appStore = useAppStore()
function error() {
  throw new Error('This is an error')
}
</script>
```
