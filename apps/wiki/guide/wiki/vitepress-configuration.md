# VitePress Configuration

VitePress provides wast set of [configuration options](https://vitepress.dev/reference/site-config)

Some examples are provided below.

## Home page

1. Place logo and favicon in `/apps/wiki/public` folder and reference in `/apps/wiki/.vitepress/config.ts` like this:

```ts{4,7}
export default defineConfig({
  title: "My Site",
  description: "My Site",
  head: [['link', { rel: 'icon', href: '/favicon.ico' }]],
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    logo: "/logo.png",
```

2. Enhance home page by modifying and styling home page

::: details `./apps/wiki/index.md`
<<< ../../index.md
:::

::: details `./apps/wiki/.vitepress/theme/style.css`
<<< ../../.vitepress/theme/style.css
:::

See more at [VitePress - Default Theme Configuration](https://vitepress.dev/reference/default-theme-config).

## Navigation

Set top level navigation `nav` and multilevel navigation `sidebar`.

::: details `/apps/wiki/.vitepress/config.ts`

```ts
import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: 'My site',
  description: 'My site',
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'My site', link: 'https://my.site' },
      { text: 'Apps', link: 'https://apps.my.site' },
      { text: 'Introduction', link: '/introduction/introduction' },
      { text: 'Guide', link: '/guide/getting-started/getting-started' },
    ],

    sidebar: {
      '/introduction/': [
        {
          text: 'Why?',
          items: [
            { text: 'Vision', link: '/introduction/vision' },
            //
          ],
        },
      ],
      '/guide/': [
        //
        {
          text: 'Wiki',
          items: [
            { text: 'Setting up VitePress', link: '/guide/wiki/setting-up-vitepress' },
            { text: 'VitePress configuration', link: '/guide/wiki/vitepress-configuration' },
            { text: 'Custom markdown', link: '/guide/wiki/custom-markdown' },
          ],
        },
      ],
    },

    socialLinks: [{ icon: 'github', link: 'https://github.com/vuejs/vitepress' }],
  },
})
```

:::

## Local search

Local search can be enabled in `/apps/wiki/.vitepress/config.ts`

```ts{6-8}
export default defineConfig({
  title: "My site",
  description: "My site",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    search: {
      provider: "local",
    },
    //
  },
  //
}
```
