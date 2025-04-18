# Experimental features

## Automated translation

Translation automation will involve following steps:

1. Gathering of missing translations - using [i18n Missing Handler](https://vue-i18n.intlify.dev/api/composition.html#missinghandler)

2. Passing and caching missing translations to vite middleware handler.

3. Processing cached missed translations in timed intervals and adding to translation files.

4. Files can be then AI translated.

### Implementation

1. Create Vite Dev plugin for processing translations 

::: details `@/plugins/i18n-dev.ts`
<<< ../../../src/plugins/i18n-dev.ts 
:::

2. Add plugin to `./vite.config.ts` amd enable middleware

```ts
//
import { i18nDevPlugin}  from './src/plugins/i18n-dev'
//
  return {
    middlewareMode: true,
    plugins: [
//
      i18nDevPlugin(),
//
    ],
  }
//
```      

3. Add missing translated handler to `@/plugins/i18n.ts`

```ts{11-21}
import { createI18n } from 'vue-i18n'
import messages from '@intlify/unplugin-vue-i18n/messages'

const i18n = createI18n({
  legacy: false,
  globalInjection: true,
  locale: 'en',
  fallbackLocale: 'en',
  fallbackWarn: false,
  messages,
  missing: (locale: string, key: string) => {
    fetch('/i18n-add', {
      method: 'POST',
      body: JSON.stringify({
        data: { locale, key },
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    })
  },
})

export default i18n
```


4. Test. 

When navigating through pages, each 30 minutes there should be update of files in `./i18n` with missing translations.
