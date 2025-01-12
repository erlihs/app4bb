import { createI18n } from 'vue-i18n'

const i18n = createI18n({
  legacy: false,
  globalInjection: true,
  locale: 'en',
  fallbackLocale: 'en',
  messages: {
    en: {},
    fr: {},
  },
  fallbackWarn: false,
  missing: (locale, key) => {
    // @ts-ignore
    const i18nStore = useI18nStore()
    i18nStore.addTranslation(locale, key)
    },
})

export default i18n
