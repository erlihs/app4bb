import { defineStore, acceptHMRUpdate } from 'pinia'
import { version as packageVersion } from '../../package.json'

export const useAppStore = defineStore('app', () => {
  const settings = useSettingsStore()
  const navigation = useNavigationStore()
  const ui = useUiStore()
  const version = ref('...')

  function init() {
    version.value = 'v' + packageVersion + (import.meta.env.DEV ? '-dev' : '')
    settings.init()
  }

  return { settings, navigation, ui, version, init }
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useAppStore, import.meta.hot))
}
