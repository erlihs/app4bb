# Consuming Web Services

## Environment Variables

Create [Environment variables](https://vite.dev/guide/env-and-mode) to store information about service endpoint. Suggested approach is to keep in Environment variables just a bare minimum and to obtain most of configuration and settings from back-end.

For production `./.env.production`

```ini
VITE_PROJECT_ENV = production
VITE_API_URI = https://your_domain.adb.eu-frankfurt-1.oraclecloudapps.com/ords/your_prod_schema/
```

For local development

```ini
VITE_PROJECT_ENV = development
VITE_API_URI = https://127.0.0.1:8443/ords/your_dev_schema/
```

## Server Proxy

To prevent [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) problem in local development, need to implement a server proxy in `./vite.config.ts`

```ts
// ...
import { defineConfig, loadEnv } from 'vite'
// ...
export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd())

  return {
    plugins: [
      // ...
    ],
    resolve: {
      // ...
    },
    server: {
      proxy: {
        '/api': {
          target: env.VITE_API_URI,
          changeOrigin: true,
          secure: env.VITE_PROJECT_ENV == 'production' ? true : false,
          rewrite: (path) => path.replace(/^\/api/, ''),
        },
      },
    },
  }
})
```

## HTTP Composable

1. Install `axios` and `axios-retry` libraries.

```ps
npm install axios
npm install axios-retry
```

2. Create `useHttp`composable to wrap `axios` with app's defaults.

::: details `@/composables/http.ts`

```ts
import axios, { type AxiosInstance, type AxiosRequestConfig, AxiosError } from 'axios'
import axiosRetry from 'axios-retry'

const useHttpOptions = {
  baseURL: '' as string,
  timeout: 5000,
  headers: {},
  retries: 5,
  errorMessage: 'error.when.sending.data.over.the.internet',
}

export type UseHttpOptions = Partial<typeof useHttpOptions>

export type HttpResponse<T> = {
  data?: T
  status?: number
  error?: {
    code?: string
    message: string
  }
}

export type UseHttpInstance = {
  get: <T = unknown>(
    url: string,
    params?: Record<string, unknown>,
    config?: AxiosRequestConfig,
  ) => Promise<HttpResponse<T>>
  post: <T = unknown>(
    url: string,
    data?: unknown,
    config?: AxiosRequestConfig,
  ) => Promise<HttpResponse<T>>
  put: <T = unknown>(
    url: string,
    data?: unknown,
    config?: AxiosRequestConfig,
  ) => Promise<HttpResponse<T>>
  delete: <T = unknown>(url: string, config?: AxiosRequestConfig) => Promise<HttpResponse<T>>
}

export function useHttp(options: UseHttpOptions = {}): UseHttpInstance {
  const instance: AxiosInstance = axios.create({
    baseURL: options.baseURL || useHttpOptions.baseURL,
    timeout: options.timeout !== undefined ? options.timeout : useHttpOptions.timeout,
    headers: options.headers || useHttpOptions.headers,
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

  const get = async <T = unknown>(
    url: string,
    params?: Record<string, unknown>,
    config?: AxiosRequestConfig,
  ): Promise<HttpResponse<T>> => {
    try {
      const response = await instance.get<T>(url, {
        ...config,
        params,
      })
      return {
        data: response.data,
        status: response.status,
      }
    } catch (error) {
      if (error instanceof AxiosError) {
        return {
          status: error.response?.status,
          error: {
            code: error.code,
            message: import.meta.env.DEV
              ? error.message
              : options.errorMessage || useHttpOptions.errorMessage,
          },
        }
      }
      throw error
    }
  }

  const post = async <T = unknown>(
    url: string,
    data?: unknown,
    config?: AxiosRequestConfig,
  ): Promise<HttpResponse<T>> => {
    try {
      const response = await instance.post<T>(url, data, config)
      return {
        data: response.data,
        status: response.status,
      }
    } catch (error) {
      if (error instanceof AxiosError) {
        return {
          status: error.response?.status,
          error: {
            code: error.code,
            message: import.meta.env.DEV
              ? error.message
              : options.errorMessage || useHttpOptions.errorMessage,
          },
        }
      }
      throw error
    }
  }

  const put = async <T = unknown>(
    url: string,
    data?: unknown,
    config?: AxiosRequestConfig,
  ): Promise<HttpResponse<T>> => {
    try {
      const response = await instance.put<T>(url, data, config)
      return {
        data: response.data,
        status: response.status,
      }
    } catch (error) {
      if (error instanceof AxiosError) {
        return {
          status: error.response?.status,
          error: {
            code: error.code,
            message: import.meta.env.DEV
              ? error.message
              : options.errorMessage || useHttpOptions.errorMessage,
          },
        }
      }
      throw error
    }
  }

  const del = async <T = unknown>(
    url: string,
    config?: AxiosRequestConfig,
  ): Promise<HttpResponse<T>> => {
    try {
      const response = await instance.delete<T>(url, config)
      return {
        data: response.data,
        status: response.status,
      }
    } catch (error) {
      if (error instanceof AxiosError) {
        return {
          status: error.response?.status,
          error: {
            code: error.code,
            message: import.meta.env.DEV
              ? error.message
              : options.errorMessage || useHttpOptions.errorMessage,
          },
        }
      }
      throw error
    }
  }

  return {
    get,
    post,
    put,
    delete: del,
  }
}
```

:::

## API layer

Crete an API layer for App `@/api/index.ts` to handle type safety

```ts
const http = useHttp({
  baseURL: (import.meta.env.DEV ? '/api/' : import.meta.env.VITE_API_URI) + 'app-v1/',
})

export const appApi = {
  async version(): Promise<HttpResponse<{ version: string }>> {
    return await http.get('version/')
  },
}
```

## Consuming API

Modify `@/stores/index.ts` to display db version or warning in case of error

```ts
// ...
import { appApi } from '@/api'

export const useAppStore = defineStore('app', () => {
// ...
  async function init() {
    const { data, error } = await appApi.version()
    if (error) ui.setWarning(error.message)
    const dbVersion = (data) ? data.version : '...'
    const devVersion = import.meta.env.DEV ? '-dev' : ''
    version.value = `v${packageVersion}-${dbVersion}${devVersion}`
    settings.init()
  }
// ...
```
