import { defineStore, acceptHMRUpdate } from 'pinia'
import { appApi, type I18nData } from '@/api'

export const useI18nStore = defineStore(
  'i18n',
  () => {
    let initialTranslations: I18nData[] = []
    try {
      const stored = localStorage.getItem('i18n')
      if (stored) initialTranslations = JSON.parse(stored)
    } catch {
      initialTranslations = []
    }

    const translations = ref<I18nData[]>(initialTranslations)

    watch(
      () => translations.value,
      (newData) => {
        try {
          localStorage.setItem('i18n', JSON.stringify(newData))
        } finally {
          // do nothing
        }
      },
      { deep: true },
    )

    const i18n = useI18n()

    const addTranslation = (locale: string, key: string) => {
      if (process.env.NODE_ENV === 'production') return
      try {
        const route = useRoute()
        const module = route ? route.path.split('/')[1] : ''
        if (
          !translations.value.some(
            (t) => (t.module === module || t.module === '') && t.locale === locale && t.key === key,
          )
        ) {
          const value = key
            .split('.')
            .join(' ')
            .replace(/^./, (c) => c.toUpperCase())
          translations.value.push({ module, locale, key, value })
          console.log(`[i18n] Translation added`, module, locale, key, value)
        }
      } catch (error) {
        console.warn(`[i18n] Failed to add translation`, locale, error)
      }
    }

    const loadedTranslations = new Set<string>()

    async function syncTranslations() {
      if (!translations) return
      const { error } = await appApi.setI18n(JSON.stringify(translations.value))
      if (error) console.warn('[i18n] Failed to sync translations', error.message)
      else {
        translations.value = []
        console.log('[i18n] Synced translations', translations.value)
      }
    }

    async function loadTranslations(path: string) {
      if (process.env.NODE_ENV !== 'production') await syncTranslations()
      const module = path.split('/')[1] || ''
      const locale = i18n.locale.value
      if (loadedTranslations.has(`${module}:${locale}`)) return

      const { data } = await appApi.getI18n(module, locale)
      if (data) {
        const translationData = JSON.parse(data.i18n)
        if (translationData) {
          i18n.mergeLocaleMessage(locale, translationData[locale])
          loadedTranslations.add(`${module}:${locale}`)
          if (process.env.NODE_ENV !== 'production')
            console.log('[i18n] Translations loaded', module, locale, translationData)
        }
      }
    }

    const route = useRoute()

    interface LocaleChangeHandler {
      (newLocale: string, oldLocale: string): void
    }

    watch(() => i18n.locale.value, (() => {
      if (process.env.NODE_ENV !== 'production')
        console.log('[i18n] Locale changed', i18n.locale.value)
      if (route) loadTranslations(route.path)
    }) as LocaleChangeHandler)

    return {
      addTranslation,
      loadTranslations,
    }
  }
)

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useI18nStore, import.meta.hot))
}
