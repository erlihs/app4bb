import { fileURLToPath, URL } from 'node:url'
import { promises as fs } from 'node:fs'

import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'
import VueRouter from 'unplugin-vue-router/vite'
import Markdown from 'unplugin-vue-markdown/vite'
import Vuetify from 'vite-plugin-vuetify'
import VueI18nPlugin from '@intlify/unplugin-vue-i18n/vite'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import AutoImportMdiIcons from './src/plugins/icons'
import { unheadComposablesImports } from 'unhead'
import { VitePWA } from 'vite-plugin-pwa'
import { LocalStorageWatcherPlugin } from './src/plugins/i18n'

async function extractMetaFromMarkdown(absolutePath: string): Promise<Record<string, unknown> | null> {
  try {
    const mdContent = await fs.readFile(absolutePath, 'utf-8');
    const metaRegex = /^---\n([\s\S]*?)\n---/;
    const match = mdContent.match(metaRegex);
    if (match && match[1]) {
      const metaString = match[1];
      const metaLines = metaString.split("\n");
      const metaObject: Record<string, unknown> = {};
      for (const line of metaLines) {
        const [key, ...valueParts] = line.split(":");
        if (key && valueParts.length) {
          const value = valueParts.join(":").trim();
          metaObject[key.trim()] = value.startsWith('"') && value.endsWith('"')
            ? value.slice(1, -1)
            : value;
        }
      }
      return metaObject;
    }
    return null;
  } catch (error) {
    console.error(`Error reading file at ${absolutePath}:`, error);
    return null;
  }
}

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd())

  return {
    plugins: [
      Markdown({}),
      VueRouter({
        extensions: ['.vue', '.md'], async extendRoute(route) {
          if (route.component?.endsWith('.md')) {
            const meta = await extractMetaFromMarkdown(route.component)
            if (meta) route.meta = { ...route.meta, ...meta }
          }
        }
      }),
      vue({
        include: [/\.vue$/, /\.md$/]
      }),
      Vuetify(),
      VueI18nPlugin({}),
      AutoImport({
        imports: [
          'vue',
          'vue-router',
          'vue-i18n',
          {
            from: 'vuetify',
            imports: [
              'useDisplay',
              'useDate',
              'useDefaults',
              'useDisplay',
              'useGoTo',
              'useLayout',
              'useLocale',
              'useRtl',
              'useTheme'
            ]
          },
          unheadComposablesImports[0],
        ],
        dirs: ['./src/composables/**', './src/stores/**']
      }),
      Components({}),
      AutoImportMdiIcons({}),
      VitePWA({
        includeAssets: ['favicon.ico', 'apple-touch-icon.png', 'mask-icon.svg'],
        manifest: {
          name: 'Bullshit Bingo',
          short_name: 'BB',
          description: 'Release the energy to focus on business',
          theme_color: '#fcbf49',
          icons: [
            {
              src: 'pwa-64x64.png',
              sizes: '64x64',
              type: 'image/png'
            },
            {
              src: 'pwa-192x192.png',
              sizes: '192x192',
              type: 'image/png'
            },
            {
              src: 'pwa-512x512.png',
              sizes: '512x512',
              type: 'image/png'
            },
            {
              src: 'maskable-icon-512x512.png',
              sizes: '512x512',
              type: 'image/png',
              purpose: 'maskable'
            }
          ]
        }
      }),
      LocalStorageWatcherPlugin({}),
      vueDevTools(),
    ],
    resolve: {
      alias: {
        '@': fileURLToPath(new URL('./src', import.meta.url))
      },
    },
    server: {
      proxy: {
        '/api': {
          target: env.VITE_API_URI,
          changeOrigin: true,
          secure: env.VITE_PROJECT_ENV == 'production' ? true : false,
          rewrite: (path) => path.replace(/^\/api/, '')
        }
      }
    },
  }
})
