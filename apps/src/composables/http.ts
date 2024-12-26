import axios, { type AxiosInstance, type AxiosRequestConfig, AxiosError } from 'axios'
import axiosRetry from 'axios-retry'

const useHttpOptions = {
  baseURL: '' as string,
  timeout: 5000,
  headers: {},
  retries: 5,
  errorMessage: 'app.errors.http',
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
