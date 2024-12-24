import { defineStore, acceptHMRUpdate } from 'pinia'

export const useSettingsStore = defineStore(
  'settings',
  () => {
    const themes = useTheme()
    const theme = ref('light')
    function themeToggle() {
      theme.value = theme.value === 'light' ? 'dark' : 'light'
      themes.global.name.value = theme.value
    }
    const themeIcon = computed(() => {
      if (themes.global.name.value === 'light') return '$mdiWeatherSunny'
      if (themes.global.name.value === 'dark') return '$mdiWeatherNight'
    })

    const i18n = useI18n()
    const locale = ref(i18n.locale.value)
    const locales = ref(i18n.availableLocales)
    function setLocale(newLocale: string) {
      locale.value = newLocale
      i18n.locale.value = newLocale
    }

    const fontSize = ref(100)
    const fontSizes = [100, 150, 200]
    function setFontSize(newFontSize: number) {
      fontSize.value = newFontSize
      document.documentElement.style.fontSize = `${newFontSize}%`
    }

    function init() {
      themes.global.name.value = theme.value
      setLocale(locale.value)
      setFontSize(fontSize.value)
    }

    return {
      theme,
      themeToggle,
      themeIcon,
      locale,
      locales,
      setLocale,
      fontSize,
      fontSizes,
      setFontSize,
      init,
    }
  },
  {
    persist: {
      include: ['theme', 'locale', 'fontSize'],
    },
  },
)

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useSettingsStore, import.meta.hot))
}
