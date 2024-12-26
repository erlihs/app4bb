# Progressive Web Application

A progressive web app (PWA) is an app that is built using web platform technologies, but that provides a user experience like that of a platform-specific app.

[Progressive Web Apps](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps)

## PWA for Vite and Vue

There is a [Vite PWA plugin](https://vite-pwa-org.netlify.app/) that will help you to add PWA, with almost zero configuration, to your existing applications. The plugin will add sensible built-in default configuration for common use cases.

Before starting, it is recommended to [learn about PWA](https://web.dev/learn/pwa/).

## Setting up

Install the Vite PWA plugin

```ps
npm install -D vite-plugin-pwa
```

## Manifest

1. Create logo and all needed icons for PWA

Prepare your logo (512x512) that will be used to generate all necessary icons. Preferably in SVG format.

SVG format can be obtained by converting any PNG or JPEG with [Adobe online tools](https://new.express.adobe.com/tools/convert-to-svg).

Save your file as `/public/logo.svg`.

Then either online PWA generators like [PWA builder](https://www.pwabuilder.com/imageGenerator) or [Vite PWA Assets generator](https://github.com/vite-pwa/assets-generator).

Will use the second option as it provides easy way how to regenerate icons any time.

Install PWA asset generator.

```ps
npm i @vite-pwa/assets-generator -D
```

Create `/pwa-assets.config.ts` file in root directory.

```ts
import { defineConfig, minimalPreset as preset } from '@vite-pwa/assets-generator/config'

export default defineConfig({
  preset,
  images: ['public/logo.svg'],
})
```

Add command to `/package.json`

```json
{
  "scripts": {
...
    "generate-pwa-assets": "pwa-assets-generator"
  }
...
}
```

Run generator

```ps
npm run generate-pwa-assets
```

And it will generate icon files in `/public` folder.

2. Add manifest

Modify `/index.html` with information required for PWA

```html{5-11}
<!doctype html>
<html lang="en">
  <head>
    ...
    <link rel="icon" href="/favicon.ico">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Your app title</title>
    <meta name="description" content="Your app description">
    <link rel="apple-touch-icon" href="/apple-touch-icon.png" sizes="180x180">
    <link rel="mask-icon" href="/mask-icon.svg" color="#fcbf49">
    <meta name="theme-color" content="#fcbf49">
  </head>
  ...
</html>
```

Also you can choose some specific background color.

And add manifest details to `/vite.config.ts`

```ts
...
import { VitePWA } from 'vite-plugin-pwa'
...
 return defineConfig({
    plugins: [
...
      VitePWA({
       includeAssets: ['favicon.ico', 'apple-touch-icon.png', 'mask-icon.svg'],
       manifest: {
          name: "Your App Name",
          short_name: "Your App",
          description: "Your App Description",
          theme_color: "#fcbf49",
          icons: [
            {
              src: "pwa-64x64.png",
              sizes: "64x64",
              type: "image/png"
            },
            {
              src: "pwa-192x192.png",
              sizes: "192x192",
              type: "image/png"
            },
            {
              src: "pwa-512x512.png",
              sizes: "512x512",
              type: "image/png"
            },
            {
              src: "maskable-icon-512x512.png",
              sizes: "512x512",
              type: "image/png",
              purpose: "maskable"
            }
          ]
        },
      }),
    ],
```

There are other attributes, if you decide to add application to store (e.g. Google Play) - check how to create [Rich Install UI](https://developer.chrome.com/blog/richer-install-ui-desktop/)

## Upgrade

1. Add automatic version increment on build

To have automatically increment version, add pre-build script in `/package.json`

```json{7}
{
...
  "version": "0.0.1",
...
  "scripts": {
...
    "prebuild": "npm --no-git-tag-version version patch",
...
```

2. Include support for search engines

Add `./public/robots.txt`

```txt
User-agent: *
Allow: /
```

3. Implement reload prompt and offline indicator

Add types to `/.env.d.ts`

```ts{3}
/// <reference types="vite/client" />
/// <reference types="unplugin-vue-router/client" />
/// <reference types="vite-plugin-pwa/vue" />
```

Add service worker script and reload prompt and offline indicator in `@/App.vue`

```vue
...
<v-footer app>
      <v-row>
        <v-col>
          {{ appStore.version }}
          <v-btn
            v-if="needRefresh"
            variant="outlined"
            density="compact"
            class="ml-2"
            @click="refresh = true"
          >
            Upgrade
          </v-btn>
          <v-snackbar v-model="refresh" multi-line vertical>
            New version is available, click OK to upgrade now.
            <template v-slot:actions>
              <v-btn color="primary" variant="text" @click="updateServiceWorker()"> Ok </v-btn>
              <v-btn color="secondary" variant="text" @click="refresh = false"> Cancel </v-btn>
            </template>
          </v-snackbar>
        </v-col>
      </v-row>
    </v-footer>
...
<script setup lang="ts">
...
import { useRegisterSW } from 'virtual:pwa-register/vue'
const { needRefresh, updateServiceWorker } = useRegisterSW()
const refresh = ref(false)
...
</script>
```

## Testing

Use `npm run preview` and `npm run build` to test upgrade behavior.
