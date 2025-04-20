import { defineStore, acceptHMRUpdate } from 'pinia'
import Cookies from 'js-cookie'
import { appApi } from '@/api'

export const useAuthStore = defineStore(
  'auth',
  () => {
    const { startLoading, stopLoading, setInfo, setError, setWarning } = useUiStore()

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
      privileges: [] as {
        role: string
        permission: string
        validfrom: string
        validto: string
      }[],
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
          setError(data?.error || 'unauthorized')
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
          privileges: data.user?.[0]?.privileges || [],
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
          setError(data?.error || 'unauthorized')
          router.push('/login')
        } else {
          setWarning(error.message)
        }
      } else if (data) {
        accessToken.value = data.accessToken
        Cookies.set('refresh_token', data.refreshToken, refreshCookieOptions)
        isAuthenticated.value = !!accessToken.value
      }
    }

    async function signup(username: string, password: string, fullname: string): Promise<boolean> {
      startLoading()
      const { data, error } = await appApi.signup(username, password, fullname)
      if (error || data?.error) {
        setError(error?.message || data?.error || 'An unknown error occurred')
      } else if (data) {
        accessToken.value = data.accessToken
        Cookies.set('refresh_token', data.refreshToken, refreshCookieOptions)
        isAuthenticated.value = !!accessToken.value
        user.value = {
          ...defaultUser,
          ...data.user?.[0],
          privileges: data.user?.[0]?.privileges || [],
        }
      }
      stopLoading()
      return isAuthenticated.value
    }

    async function confirmEmail(confirmToken: string): Promise<boolean> {
      startLoading()
      const { data } = await appApi.confirmEmail(confirmToken)
      if (data?.error) {
        setError('email.confirmation.failed')
      } else {
        setInfo('email.confirmed')
      }
      stopLoading()
      return !data?.error
    }

    async function recoverPassword(username: string): Promise<boolean> {
      startLoading()
      const { data } = await appApi.recoverPassword(username)
      if (data?.error) {
        setError('password.recovery.failed')
      } else {
        setInfo('password.recovery.email.sent')
      }
      stopLoading()
      return !data?.error
    }

    async function resetPassword(
      username: string,
      password: string,
      recoverToken: string,
    ): Promise<boolean> {
      startLoading()
      const { data, status, error } = await appApi.resetPassword(username, password, recoverToken)
      if (error) {
        accessToken.value = ''
        Cookies.remove('refresh_token', refreshCookieOptions)
        isAuthenticated.value = false
        if (status == 401) {
          setError('invalid.username.or.password')
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
          privileges: data.user?.[0]?.privileges || [],
        }
        setInfo('password.reset')
      }
      stopLoading()
      return isAuthenticated.value
    }

    async function signupSocial(
      username: string,
      password: string,
      fullname: string,
    ): Promise<boolean> {
      startLoading()
      const logged = await login(username, password)
      if (!logged) await signup(username, password, fullname)
      stopLoading()
      return isAuthenticated.value
    }

    function hasRole(role: string): boolean {
      return user.value.privileges.some((privilege) => privilege.role === role)
    }

    return {
      accessToken,
      refreshToken,
      isAuthenticated,
      user,
      login,
      logout,
      refresh,
      signup,
      confirmEmail,
      recoverPassword,
      resetPassword,
      signupSocial,
      hasRole,
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
