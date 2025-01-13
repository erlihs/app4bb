import axios, { type AxiosInstance, type AxiosRequestConfig, AxiosError } from 'axios'
import axiosRetry from 'axios-retry'

const useHttpOptions = {
  baseURL: '' as string,
  timeout: 5000,
  headers: {},
  retries: 5,
  errorMessage: 'error.when.sending.data.over.the.internet',
  convertKeys: '',
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

      if (
        err.response?.status === 401 &&
        originalRequest &&
        !originalRequest.url?.includes('/refresh') &&
        !originalRequest.url?.includes('/login')
      ) {
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
