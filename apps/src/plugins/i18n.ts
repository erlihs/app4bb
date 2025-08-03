import { createI18n } from 'vue-i18n'
import messages from '@intlify/unplugin-vue-i18n/messages'

const isDev = process.env.NODE_ENV === 'development' || (import.meta as any).env?.DEV

const i18n = createI18n({
  legacy: false,
  globalInjection: true,
  locale: 'en',
  fallbackLocale: 'en',
  fallbackWarn: false,
  messages,
  missing: isDev ? (locale: string, key: string) => {
    fetch('/i18n-add', {
      method: 'POST',
      body: JSON.stringify({
        data: { locale, key },
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    })
  } : undefined,
})

export default i18n
