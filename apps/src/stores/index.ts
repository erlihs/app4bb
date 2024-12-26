import { defineStore, acceptHMRUpdate } from 'pinia'
import { version as packageVersion } from '../../package.json'
import { appApi } from '@/api'

export const useAppStore = defineStore('app', () => {
  const auth = useAuthStore()
  const settings = useSettingsStore()
  const navigation = useNavigationStore()
  const ui = useUiStore()
  const version = ref('...')

  async function init() {
    const { data, error } = await appApi.version()
    if (error) ui.setWarning(error.message)
    const dbVersion = data ? data.version : '...'
    const devVersion = import.meta.env.DEV ? '-dev' : ''
    version.value = `v${packageVersion}-${dbVersion}${devVersion}`
    settings.init()
  }

  return { auth, settings, navigation, ui, version, init }
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useAppStore, import.meta.hot))
}
