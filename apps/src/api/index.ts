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
    privileges?: {
      role: string
      permission: string
      validfrom: string
      validto: string
    }[]
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
