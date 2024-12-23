import { createI18n } from 'vue-i18n'
import en from '../i18n/en.json'
import fr from '../i18n/fr.json'

const missingTranslations = new Set<string>()

const i18n = createI18n({
  legacy: false,
  globalInjection: true,
  locale: 'en',
  fallbackLocale: 'en',
  messages: {
    en,
    fr,
  },
  missing: (locale, key) => {
    const missingKey = `${locale}:${key}`
    if (!missingTranslations.has(missingKey)) {
      console.warn(`[i18n] Translation missing for key: ${key}, locale: ${locale}`)
      missingTranslations.add(missingKey)
    }
  },
})

export default i18n

const mergedModules = new Set<string>()

export async function loadPageTranslations(path: string) {
  const moduleName = path.split('/')[1]
  if (moduleName) {
    const moduleKey = `${moduleName}`
    if (mergedModules.has(moduleKey)) {
      return
    }
    const messages = i18n.global.messages.value as Record<string, Record<string, unknown>>
    const supportedLocales = Object.keys(messages)
    await Promise.all(
      supportedLocales.map(async (locale) => {
        const moduleMessages = messages[locale]?.[moduleName]
        if (!moduleMessages) {
          try {
            const moduleTranslations = await import(`../i18n/${moduleName}/${locale}.json`)
            i18n.global.mergeLocaleMessage(locale, {
              [moduleName]: moduleTranslations.default[moduleName],
            })
          } catch {
            console.warn(
              `[i18n] No translations found for module: ${moduleName}, locale: ${locale}`,
            )
          }
        }
      }),
    )
    mergedModules.add(moduleKey)
  }
}
