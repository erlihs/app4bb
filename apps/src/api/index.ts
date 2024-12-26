const http = useHttp({
  baseURL: (import.meta.env.DEV ? '/api/' : import.meta.env.VITE_API_URI) + 'app-v1/',
})

export const appApi = {
  async version(): Promise<HttpResponse<{ version: string }>> {
    return await http.get('version/')
  },
}
