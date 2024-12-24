import { defineStore, acceptHMRUpdate } from 'pinia'

export const useAppStore = defineStore('app', () => {
  const settings = useSettingsStore()
  const navigation = useNavigationStore()
  const ui = useUiStore()

  function init() {
    settings.init()
  }

  return { settings, navigation, ui, init }
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useAppStore, import.meta.hot))
}
