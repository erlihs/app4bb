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

export type AuditData = {
  severity: string
  action: string
  details?: string
  created?: string
}

export type VoidResponse = {
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

  async audit(data: AuditData[]): Promise<HttpResponse<void>> {
    return await http.post('audit/', { data: JSON.stringify(data) })
  },

  async signup(
    username: string,
    password: string,
    fullname: string,
  ): Promise<HttpResponse<AuthResponse>> {
    return await http.post('signup/', { username, password, fullname })
  },

  async confirmEmail(confirmtoken: string): Promise<HttpResponse<VoidResponse>> {
    return await http.post('confirmemail/', { confirmtoken })
  },

  async recoverPassword(username: string): Promise<HttpResponse<VoidResponse>> {
    return await http.post('recoverpassword/', { username })
  },

  async resetPassword(
    username: string,
    password: string,
    recovertoken: string,
  ): Promise<HttpResponse<AuthResponse>> {
    return await http.post('resetpassword/', { username, password, recovertoken })
  },
}
