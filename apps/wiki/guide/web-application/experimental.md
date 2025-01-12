# Experimental features

## Automated translation

Translation automation will involve following steps:

1. Gathering of missing translations - using [i18n Missing Handler](https://vue-i18n.intlify.dev/api/composition.html#missinghandler) and write in local storage
2. Batch send missing translations to backend
3. Process (translate with AI)
4. Lazy load from back end processed translations as user navigates

Check i18n API of [odb4bb](https://github.com/erlihs/odb4bb).

### Implementation

1. Add new api methods at `@/api/index.ts`

```ts
// ...
export type I18nData = {
  module: string
  locale: string
  key: string
  value: string
}
// ...
export const appApi = {
  // ...

  async getI18n(module: string, locale: string): Promise<HttpResponse<{ [key: string]: string }>> {
    return await http.get('i18n/', { module, locale })
  },

  async setI18n(i18n: string): Promise<HttpResponse<void>> {
    return await http.post('i18n_batch/', { i18n })
  },
}
```

2. Organize all features, a new store is created

::: details `@/stores/app/i18n.ts`
<<< ../../../src/stores/app/i18n.ts
:::

3. Add handler to `@/plugins/i18n.ts` to process missing translations

```ts
//...
const i18n = createI18n({
  //...
  missing: (locale, key) => {
    if (process.env.NODE_ENV === 'production') return
    // @ts-ignore
    const i18nStore = useI18nStore()
    i18nStore.addTranslation(locale, key)
    },
  },
)
```

4. Upgrade `@/router/index.ts` with the new lazy loading feature

```ts
// ...
router.beforeEach(async (to) => {
  // ...
  await useI18nStore().loadTranslations(to.path)
  // ...
})
// ...
```
