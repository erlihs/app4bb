import { defineStore, acceptHMRUpdate } from 'pinia'

export const useSettingsStore = defineStore(
  'settings',
  () => {
    const setTheme = useTheme()

    const theme = ref('light')

    function themeToggle() {
      theme.value = theme.value === 'light' ? 'dark' : 'light'
      setTheme.global.name.value = theme.value
    }

    const themeIcon = computed(() => {
      if (setTheme.global.name.value === 'light') return '$mdiWeatherSunny'
      if (setTheme.global.name.value === 'dark') return '$mdiWeatherNight'
    })

    function init() {
      setTheme.global.name.value = theme.value
    }

    return { theme, themeToggle, themeIcon, init }
  },
  {
    persist: {
      include: ['theme'],
    },
  },
)

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useSettingsStore, import.meta.hot))
}
