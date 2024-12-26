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
      sameSite: 'strict' as const,
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

    const login = async (username: string, password: string): Promise<boolean> => {
      startLoading()
      const { data, status, error } = await appApi.login(username, password)
      if (error) {
        accessToken.value = ''
        Cookies.remove('refresh_token', refreshCookieOptions)
        isAuthenticated.value = false
        if (status == 401) {
          setError(data?.error || 'Unauthorized')
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

    const logout = async () => {
      startLoading()
      await appApi.logout()
      _logout()
      stopLoading()
      router.push('/')
    }

    const refresh = async () => {
      const { data, status, error } = await appApi.refresh()
      if (error) {
        _logout()
        if (status == 401) {
          setError(data?.error || 'Unauthorized')
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
