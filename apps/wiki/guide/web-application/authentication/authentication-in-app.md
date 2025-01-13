# Authentication - app

## Consuming API

1. Add interceptors to HTTP composable to add Bearer token and handle refresh token

::: details `@/composables/http.ts`

```ts
// ...
const useHttpOptions = {
  baseURL: '' as string,
  timeout: 5000,
  headers: {},
  retries: 5,
  errorMessage: 'app.errors.http',
  convertKeys: '',
}
// ...

let isRefreshing = false
const requestQueue: Array<{
  resolve: (value: unknown) => void
  reject: (error: unknown) => void
  config: AxiosRequestConfig
}> = []

const processQueue = (error: unknown = null) => {
  requestQueue.forEach((request) => {
    if (error) {
      request.reject(error)
    } else {
      request.resolve(request.config)
    }
  })
  requestQueue.length = 0
}

const snakeToCamel = <T>(data: T): T => {
  const toCamelCase = (str: string): string => {
    return str.replace(/_([a-z])/g, (_, letter) => letter.toUpperCase())
  }

  if (Array.isArray(data)) {
    return data.map((item) => snakeToCamel(item)) as T
  }

  if (data !== null && typeof data === 'object') {
    const newObj: Record<string, unknown> = {}

    Object.entries(data as Record<string, unknown>).forEach(([key, value]) => {
      const camelKey = toCamelCase(key)
      newObj[camelKey] = snakeToCamel(value)
    })

    return newObj as T
  }

  return data
}

export function useHttp(options: UseHttpOptions = {}): UseHttpInstance {
  const instance: AxiosInstance = axios.create({
    baseURL: options.baseURL || useHttpOptions.baseURL,
    timeout: options.timeout !== undefined ? options.timeout : useHttpOptions.timeout,
    headers: {
      ...(options.headers || useHttpOptions.headers),
    },
  })

  axiosRetry(instance, {
    retries: options.retries ?? useHttpOptions.retries,
    retryDelay: (retryCount) => axiosRetry.exponentialDelay(retryCount),
    retryCondition: (error) => {
      return (
        axiosRetry.isNetworkOrIdempotentRequestError(error) ||
        (error.response?.status ? error.response.status >= 500 : false)
      )
    },
  })

  instance.interceptors.request.use(
    (config) => {
      config.headers['request-startTime'] = performance.now()
      const appStore = useAppStore()
      if (appStore.auth.accessToken && config.headers) {
        config.headers.Authorization = `Bearer ${appStore.auth.accessToken}`
      }
      if (config.url && config.url.includes('refresh/') && appStore.auth.refreshToken()) {
        config.headers.Authorization = `Bearer ${appStore.auth.refreshToken()}`
      }
      return config
    },
    (error) => Promise.reject(error),
  )

  instance.interceptors.response.use(
    (response) => {
      if (options.convertKeys ?? useHttpOptions.convertKeys == 'snake_to_camel') {
        response.data = snakeToCamel(response.data)
      }
      const duration = performance.now() - (response.config.headers['request-startTime'] as number)
      if (duration >= import.meta.env.VITE_PERFORMANCE_API_CALL_THRESHOLD_IN_MS) {
        const appAudit = useAuditStore()
        appAudit.wrn(
          'API call time threshold exceeded',
          `API ${response.config.url} took ${duration}ms`,
        )
      }
      return response
    },
    async (err: AxiosError) => {
      const originalRequest = err.config
      const appStore = useAppStore()

      if (err.response?.status === 401 && err.config?.url?.includes('refresh/')) {
        const error = new Error('session.expired')
        processQueue(error)
        isRefreshing = false
        appStore.auth.logout('/login', true, error.message)
        return Promise.reject(error)
      }

      if (err.response?.status === 401 && originalRequest && !originalRequest.url?.includes('/refresh') && !originalRequest.url?.includes('/login')) {
        if (!isRefreshing) {
          isRefreshing = true

          try {
            await appStore.auth.refresh()

            if (originalRequest.headers) {
              originalRequest.headers.Authorization = `Bearer ${appStore.auth.accessToken}`
            }

            processQueue()
            return instance(originalRequest)
          } catch (error) {
            processQueue(error)
            return Promise.reject(error)
          } finally {
            isRefreshing = false
          }
        }

        return new Promise((resolve, reject) => {
          requestQueue.push({
            resolve: () => {
              if (originalRequest.headers && appStore.auth.accessToken) {
                originalRequest.headers.Authorization = `Bearer ${appStore.auth.accessToken}`
              }
              resolve(instance(originalRequest))
            },
            reject,
            config: originalRequest,
          })
        })
      }

      return Promise.reject(err)
    },
  )

// ...
```

:::

2. Add methods for providing APIs

::: details `@/api/index.ts`

```ts
const http = useHttp({
  baseURL: (import.meta.env.DEV ? '/api/' : import.meta.env.VITE_API_URI) + 'app-v1/',
  convertKeys: 'snake_to_camel',
})

export type AuthResponse = {
  accessToken: string
  refreshToken: string
  user?: {
    uuid: string
    username: string
    fullname: string
    created: string
  }[]
  error?: string
}

export const appApi = {
  async version(): Promise<HttpResponse<{ version: string }>> {
    return await http.get('version/')
  },

  async login(username: string, password: string): Promise<HttpResponse<AuthResponse>> {
    return await http.post('login/', { username, password })
  },

  async logout(): Promise<HttpResponse<void>> {
    return await http.post('logout/')
  },

  async refresh(): Promise<HttpResponse<AuthResponse>> {
    return await http.post('refresh/')
  },

  async heartbeat(): Promise<HttpResponse<void>> {
    return await http.get('heartbeat/', { random: Math.random() })
  },
}
```

:::

## Authentication logic

1.  Install package for handling cookies

```ps
npm i js-cookie
npm i @types/js-cookie

```

2. Create auth store

::: details `@/stores/app/auth.ts`

```ts
import { defineStore, acceptHMRUpdate } from 'pinia'
import Cookies from 'js-cookie'
import { appApi } from '@/api'

export const useAuthStore = defineStore(
  'auth',
  () => {
    const { startLoading, stopLoading, setError, setWarning } = useUiStore()

    const refreshCookieOptions = {
      path: '/',
      secure: true,
      sameSite: 'Strict' as const,
      domain: window.location.hostname,
      expires: 7,
    }

    const defaultUser = {
      uuid: '',
      username: '',
      fullname: '',
      created: '',
    }

    const accessToken = ref('')
    const isAuthenticated = ref(false)
    const user = ref({ ...defaultUser })

    function refreshToken() {
      return Cookies.get('refresh_token')
    }

    const login = async (username: string, password: string): Promise<boolean> => {
      startLoading()
      const { data, status, error } = await appApi.login(username, password)
      if (error) {
        accessToken.value = ''
        Cookies.remove('refresh_token', refreshCookieOptions)
        isAuthenticated.value = false
        if (status == 401) {
          setError('Invalid username or password')
        } else {
          setWarning(error.message)
        }
      } else if (data) {
        accessToken.value = data.accessToken
        Cookies.set('refresh_token', data.refreshToken, refreshCookieOptions)
        isAuthenticated.value = !!accessToken.value
        user.value = {
          ...defaultUser,
          ...data.user?.[0],
        }
      }
      stopLoading()
      return isAuthenticated.value
    }

    const router = useRouter()

    function _logout() {
      accessToken.value = ''
      Cookies.remove('refresh_token', refreshCookieOptions)
      isAuthenticated.value = false
      user.value = { ...defaultUser }
    }

    const logout = async (to: string = '/', skipApiCall: boolean = false, message?: string) => {
      if (!skipApiCall) {
        startLoading()
        await appApi.logout()
        stopLoading()
      }
      _logout()
      if (message) setInfo(message)
      router.push(to)
    }

    const refresh = async () => {
      const { data, status, error } = await appApi.refresh()
      if (error) {
        _logout()
        if (status == 401) {
          setError('User session has expired')
        } else {
          setWarning(error.message)
        }
      } else if (data) {
        accessToken.value = data.accessToken
        Cookies.set('refresh_token', data.refreshToken, refreshCookieOptions)
        isAuthenticated.value = !!accessToken.value
      }
    }

    return {
      accessToken,
      refreshToken,
      isAuthenticated,
      user,
      login,
      logout,
      refresh,
    }
  },
  {
    persist: {
      include: ['isAuthenticated', 'user'],
    },
  },
)

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useAuthStore, import.meta.hot))
}
```

:::

3. Include in `@/stores/index.ts`

```ts
// ...
const auth = useAuthStore()
// ...
return { auth, settings, navigation, ui, version, init }
// ...
```

4. Modify `@/stores/app/navigate.ts` to exclude guest pages like `login/` from being showed in menu and home.

```ts{5}
// ...
  const pages = computed(() => {
    return allPages.filter((page) => page.level < 2)
      .filter((page) => page.path !== '/:path(.*)')
      .filter((page) => page.role !== 'guest')
  })
// ...
```

## Modiify App

Add login / logout button in app bar

::: details `@/src/App.vue`

```vue
<template>
  <v-app>
    <v-navigation-drawer v-model="drawer" app>
      <!-- ... -->
      <v-divider v-if="app.auth.isAuthenticated" />
      <v-list v-if="app.auth.isAuthenticated">
        <v-list-item>
          {{ t('welcome') }}, <br />
          <strong>{{ app.auth.user?.fullname }}</strong>
        </v-list-item>
        <v-list-item @click="app.auth.logout()">
          <template #prepend>
            <v-icon icon="$mdiLogout"></v-icon>
          </template>
          <v-list-item-title>{{ t('logout') }}</v-list-item-title>
        </v-list-item>
      </v-list>
      <!-- ... -->
    </v-navigation-drawer>
    <v-app-bar>
      <!-- ... -->
      <v-btn v-show="!app.auth.isAuthenticated" to="/login" class="mr-2">
        <v-icon icon="$mdiAccount"></v-icon>
        {{ t('login') }}
      </v-btn>
      <v-btn v-show="app.auth.isAuthenticated" @click="app.auth.logout()" class="mr-2">
        <v-icon icon="$mdiLogout"></v-icon>
        {{ t('logout') }}
      </v-btn>
      <!-- ... -->
    </v-app-bar>
    <v-main class="ma-4">
      <!-- ... -->
    </v-main>
    <v-footer app>
      <!-- ... -->
    </v-footer>
  </v-app>
</template>
```

:::

## Create Login form

::: details `@/src/pages/login.vue`

```vue
<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" :md="4">
        <h1 class="mb-4">{{ t('login') }}</h1>
        <v-bsb-form :options :data @submit="submit" @action="dev" />
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
definePage({ meta: { role: 'guest' } })

const appStore = useAppStore()
const router = useRouter()
const route = useRoute()
const { t } = useI18n()

const devAction = import.meta.env.DEV
  ? [
      {
        type: 'dev',
        title: 'dev',
        variant: 'outlined',
      },
    ]
  : []

const options = {
  fields: [
    {
      type: 'text',
      name: 'username',
      label: 'username',
      placeholder: 'username',
      rules: [
        { type: 'required', value: true, message: 'username.is.required' },
        { type: 'email', value: true, message: 'username.must.be.a.valid.email.address' },
      ],
    },
    {
      type: 'password',
      name: 'password',
      label: 'password',
      placeholder: 'password',
      rules: [{ type: 'required', value: true, message: 'password.is.required' }],
    },
  ],
  actions: [
    {
      type: 'submit',
      title: 'submit',
      color: 'primary',
    },
    ...devAction,
  ],
  actionsAlign: 'right',
  actionsClass: 'ml-2',
}

const data = ref({
  username: '',
  password: '',
})

const submit = async (newData: typeof data.value) => {
  if (await appStore.auth.login(newData.username, newData.password))
    router.push((route.query.redirect as string) || '/')
}

const dev = async () => {
  data.value = {
    username: import.meta.env.VITE_USERNAME,
    password: import.meta.env.VITE_PASSWORD,
  }
}
</script>
```

:::

## Test

Check how login and logout works.

Add Heartbeat feature to `@/pages/sandbox/index.vue` to test how tokens are renewed.

```vue
<template>
  <!-- ... -->
  <v-btn @click="heartbeat()">Heartbeat: {{ responseStatus }}</v-btn>
  <!-- ... -->
</template>

<script setup lang="ts">
// ...
import { appApi } from '@/api'
const responseStatus = ref(200)
async function heartbeat() {
  responseStatus.value = (await appApi.heartbeat()).status ?? 200
}
</script>
```
