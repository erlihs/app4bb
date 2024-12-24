import { defineStore, acceptHMRUpdate } from 'pinia'

export const useAppStore = defineStore('app', () => {
  const settings = useSettingsStore()
  const navigation = useNavigationStore()

  function init() {
    settings.init()
  }

  return { settings, navigation, init }
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useSettingsStore, import.meta.hot))
}
