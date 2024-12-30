import { createI18n } from 'vue-i18n'
import { useRoute } from 'vue-router'
import type { Plugin } from 'vite'
import path from 'path'
import fs from 'fs'

const i18nPath = '../i18n'

export type Translation = {
  module: string
  locale: string
  key: string
  value: string
}

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
  missing: (globLocale, key) => {
    if (process.env.NODE_ENV === 'production') return
    try {
      const route = useRoute()
      const module = route ? route.path.split('/')[1] : ''
      const storedTranslations = localStorage.getItem('i18n')
      const translations = (
        storedTranslations ? JSON.parse(storedTranslations) : []
      ) as Translation[]
      i18n.global.availableLocales.forEach((locale) => {
        if (
          !translations.some(
            (t) => (t.module === module || t.module === '') && t.locale === locale && t.key === key,
          )
        ) {
          const value = key
            .split('.')
            .join(' ')
            .replace(/^./, (c) => c.toUpperCase())
          translations.push({ module, locale, key, value })
          console.log(`[i18n] Translation added`, module, locale, key, value)
        }
      })
      localStorage.setItem('i18n', JSON.stringify(translations))
    } catch (error) {
      console.warn(`[i18n] Failed to add translation`, globLocale, error)
    }
  },
})

export default i18n

const loadedTranslations = new Set<string>()

export async function loadPageTranslations(path: string) {
  i18n.global.availableLocales.forEach(async (locale) => {
    const newPath = `${i18nPath}/${path}/${locale}.json`.replace('//', '/').replace('//', '/')
    if (loadedTranslations.has(newPath)) return
    try {
      const translations =
        path == '/'
          ? await import(`./../i18n/${locale}.json`)
          : await import(`./../i18n/${path.split('/')[1]}/${locale}.json`)
      i18n.global.mergeLocaleMessage(locale, translations.default)
      loadedTranslations.add(newPath)
      console.warn('[i18n] Translations loaded', newPath)
    } catch (error) {
      console.warn('[i18n] Failed to load translations', error)
    }
  })
}

export function LocalStorageWatcherPlugin({
  keysToWatch = ['i18n'] as string[],
  checkLocalStorageChangesInterval = 2000,
} = {}): Plugin {
  let config: { command?: string } = {}

  return {
    name: 'vite-plugin-local-storage-watcher',
    enforce: 'post',
    configResolved(resolvedConfig) {
      config = resolvedConfig
    },
    transformIndexHtml(html) {
      if (config.command !== 'serve') return html

      const keys = JSON.stringify(keysToWatch)
      const interval = checkLocalStorageChangesInterval

      return html.replace(
        '</body>',
        `<script>
          (function() {
            const keysToWatch = ${keys};
            const interval = ${interval};
            let lastStorageState = {};

            keysToWatch.forEach(key => {
              lastStorageState[key] = localStorage.getItem(key);
            });

            function checkLocalStorageChanges() {
              keysToWatch.forEach(key => {
                const currentValue = localStorage.getItem(key);
                if (currentValue !== lastStorageState[key]) {
                  handleLocalStorageChange(key, currentValue);
                  lastStorageState[key] = currentValue;
                }
              });
            }

            function handleLocalStorageChange(key, value) {
              let parsedValue;
              try {
                parsedValue = JSON.parse(value);
              } catch (e) {
                console.error('Invalid JSON in localStorage for key:', key, value);
                return;
              }

              fetch('/__write-to-files', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ key, data: parsedValue }),
              });
            }

            setInterval(checkLocalStorageChanges, interval);

            window.addEventListener('storage', (event) => {
              if (keysToWatch.includes(event.key)) {
                handleLocalStorageChange(event.key, event.newValue);
              }
            });
          })();
        </script></body>`,
      )
    },
    configureServer(server) {
      server.middlewares.use('/__write-to-files', async (req, res) => {
        if (req.method === 'POST') {
          let body = ''
          req.on('data', (chunk) => (body += chunk))
          req.on('end', () => {
            const translations = JSON.parse(body).data as Translation[]
            translations.forEach(async (translation) => {
              const resolvedPath = path.resolve(
                `${__dirname}/../i18n/${translation.module}/${translation.locale}.json`,
              )
              let storedTranslationJson = '{}'
              try {
                storedTranslationJson = fs.readFileSync(resolvedPath, 'utf-8')
              } catch (error) {
                console.warn(`[i18n] Failed reading file:`, resolvedPath, error)
              }
              const storedTranslations = JSON.parse(storedTranslationJson) as Record<string, string>
              if (!storedTranslations[translation.key]) {
                storedTranslations[translation.key] = translation.value
                console.log(
                  `[i18n] Saving new translation`,
                  resolvedPath,
                  translation.key,
                  translation.value,
                )
              }
              try {
                const dir = path.dirname(resolvedPath)
                if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true })
                fs.writeFileSync(resolvedPath, JSON.stringify(storedTranslations, null, 2) + '\n')
                console.log(`[i18n] Saved file`, resolvedPath)
              } catch (error) {
                console.warn(`[i18n] Failed saving file:`, resolvedPath, error)
              }
            })
            res.writeHead(200)
            res.end('Data saved')
          })
        }
      })
    },
  }
}
