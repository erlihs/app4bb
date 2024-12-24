# Application layout

Vuetify provides `v-app` and other components to create [application layout](https://vuetifyjs.com/en/features/application-layout/) for really mature looking apps. Along with centralized Pinia [state management](https://vuejs.org/guide/scaling-up/state-management) it becomes the backbone for the app.

This article shows how to create main layout, backed by Pinia store. Enhancements:

- new layout with app bar, navigation bar and footer.
- responsive theme, language and font size selectors.
- dynamic page title.
- page not found (HTTP 404).

## Layout

1. Do code cleanup

- delete `@/assets/logo.svg`, `@/assets/base.css`
- remove all the content from `@/assets/main.css`
- delete all files and folders under `@/components`, except `@/components/__tests__`
- delete `@/stores.counter.ts`
- replace `./public/favicon.ico`with your own
- replace `./public/logo.svg`with your own

2. Add application title in `./index.html`

```html{5}
<!DOCTYPE html>
<html lang="en">
  <head>
<!-- ... -->
    <title>My App</title>
<!-- ... -->
</head>
  <body>
<!-- ... -->
  </body>
</html>
```

3. Modify Home page `@/pages/index.vue`

```vue
<template>
  <h1>Home</h1>
  <p>Nothing to see here yet.</p>
</template>

<script setup lang="ts">
definePage({ meta: { title: 'Home', icon: '$mdiHome' } })
</script>
```

4. Modify `@/App.vue`

```vue
<template>
  <v-app>
    <v-navigation-drawer v-model="drawer" app>
      <v-list>
        <v-list-item
          v-for="page in pages"
          :key="page.path"
          :prepend-icon="page.icon"
          :to="page.path"
        >
          <v-list-item-title>{{ page.title }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>Bullshit Bingo</v-toolbar-title>
    </v-app-bar>
    <v-main class="ma-4">
      <router-view />
    </v-main>
    <v-footer app>
      <v-row>
        <v-col> v0.3 </v-col>
      </v-row>
    </v-footer>
  </v-app>
</template>

<script setup lang="ts">
const drawer = ref(false)
const pages = ref([
  { title: 'Home', icon: '$mdiHome', path: '/' },
  { title: 'About', icon: '$mdiInformation', path: '/about' },
  { title: 'Sandbox', icon: '$mdiCog', path: '/sandbox' },
])
</script>
```

As a result - new and clean layout with navigation drawer, header and footer.

## Settings

1. Create new main Application store `@/stores/index.ts`

```ts
import { defineStore, acceptHMRUpdate } from 'pinia'

export const useAppStore = defineStore('app', () => {
  const settings = useSettingsStore()

  function init() {
    settings.init()
  }

  return { settings, init }
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useSettingsStore, import.meta.hot))
}
```

2. Move Settings store to `@\stores\app\settings.ts` and add locale and font size settings

```ts
import { defineStore, acceptHMRUpdate } from 'pinia'

export const useSettingsStore = defineStore(
  'settings',
  () => {
    const themes = useTheme()
    const theme = ref('light')
    function themeToggle() {
      theme.value = theme.value === 'light' ? 'dark' : 'light'
      themes.global.name.value = theme.value
    }
    const themeIcon = computed(() => {
      if (themes.global.name.value === 'light') return '$mdiWeatherSunny'
      if (themes.global.name.value === 'dark') return '$mdiWeatherNight'
    })

    const i18n = useI18n()
    const locale = ref(i18n.locale.value)
    const locales = ref(i18n.availableLocales)
    function setLocale(newLocale: string) {
      locale.value = newLocale
      i18n.locale.value = newLocale
    }

    const fontSize = ref(100)
    const fontSizes = [100, 150, 200]
    function setFontSize(newFontSize: number) {
      fontSize.value = newFontSize
      document.documentElement.style.fontSize = `${newFontSize}%`
    }

    function init() {
      themes.global.name.value = theme.value
      setLocale(locale.value)
      setFontSize(fontSize.value)
    }

    return {
      theme,
      themeToggle,
      themeIcon,
      locale,
      locales,
      setLocale,
      fontSize,
      fontSizes,
      setFontSize,
      init,
    }
  },
  {
    persist: {
      include: ['theme', 'locale', 'fontSize'],
    },
  },
)

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useSettingsStore, import.meta.hot))
}
```

3. Implement responsive app bar with setting switches in `@/App.vue`

```vue
<template>
  <v-app>
    <v-navigation-drawer v-model="drawer" app>
      <!-- ... -->
    </v-navigation-drawer>
    <v-app-bar>
      <!-- ... -->
      <v-menu v-if="mobile">
        <template #activator="{ props }">
          <v-btn icon v-bind="props">
            <v-icon :icon="'$mdiDotsVertical'"></v-icon>
          </v-btn>
        </template>
        <v-list>
          <v-list-item>
            <v-menu>
              <template #activator="{ props }">
                <v-btn variant="text" v-bind="props" prepend-icon="$mdiEyePlusOutline"></v-btn>
              </template>
              <v-list>
                <v-list-item v-for="(item, i) in app.settings.fontSizes" :key="i" :value="i">
                  <v-list-item-title @click="app.settings.setFontSize(item)"
                    >{{ item }}%</v-list-item-title
                  >
                </v-list-item>
              </v-list>
            </v-menu>
          </v-list-item>
          <v-list-item>
            <v-menu>
              <template #activator="{ props }">
                <v-btn variant="text" v-bind="props">{{ app.settings.locale }}</v-btn>
              </template>
              <v-list>
                <v-list-item v-for="(item, i) in app.settings.locales" :key="i" :value="i">
                  <v-list-item-title @click="app.settings.setLocale(item)">{{
                    item
                  }}</v-list-item-title>
                </v-list-item>
              </v-list>
            </v-menu>
          </v-list-item>
          <v-list-item>
            <v-btn
              variant="text"
              :prepend-icon="app.settings.themeIcon"
              @click="app.settings.themeToggle()"
            ></v-btn>
          </v-list-item>
        </v-list>
      </v-menu>
      <v-menu v-if="!mobile">
        <template #activator="{ props }">
          <v-btn variant="text" v-bind="props" prepend-icon="$mdiEyePlusOutline"></v-btn>
        </template>
        <v-list>
          <v-list-item v-for="(item, i) in app.settings.fontSizes" :key="i" :value="i">
            <v-list-item-title @click="app.settings.setFontSize(item)"
              >{{ item }}%</v-list-item-title
            >
          </v-list-item>
        </v-list>
      </v-menu>
      <v-menu v-if="!mobile">
        <template #activator="{ props }">
          <v-btn variant="text" v-bind="props">{{ app.settings.locale }}</v-btn>
        </template>
        <v-list>
          <v-list-item v-for="(item, i) in app.settings.locales" :key="i" :value="i">
            <v-list-item-title @click="app.settings.setLocale(item)">{{ item }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
      <v-btn
        v-if="!mobile"
        variant="text"
        :prepend-icon="app.settings.themeIcon"
        @click="app.settings.themeToggle()"
      ></v-btn>
    </v-app-bar>
    <v-main class="ma-4">
      <!-- ... -->
    </v-main>
    <v-footer app>
      <!-- ... -->
    </v-footer>
  </v-app>
</template>

<script setup lang="ts">
// ...
const { mobile } = useDisplay()
const app = useAppStore()
// ...
onMounted(() => {
  app.init()
})
</script>
```

## Navigation

1. Create a new store `@/stores/app/navigation.ts` for populating navigation menu and breadcrumbs.

```ts
import { defineStore, acceptHMRUpdate } from 'pinia'
import { useRouter, useRoute } from 'vue-router'

export const useNavigationStore = defineStore('navigation', () => {
  const routes = useRouter().getRoutes()
  const route = useRoute()

  const allPages = routes.map((route) => {
    return {
      path: route.path,
      level: route.path == '/' ? 0 : route.path.split('/').length - 1,
      children:
        routes.find((r) => r.path.includes(route.path) && r.path !== route.path) !== undefined,
      title:
        route.meta?.title?.toString() ||
        route.path
          .split('/')
          .at(-1)
          ?.split('-')
          .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
          .join(' ') ||
        '',
      description: route.meta?.description?.toString() || '',
      icon: (route.meta?.icon as string) || '',
      color: (route.meta?.color as string) || '',
      role: (route.meta?.role as string) || '',
    }
  })

  const title = computed(() => (path: string) => {
    const page = allPages.find((page) => page.path === path)
    return page ? page.title : ''
  })

  const breadcrumbs = computed(() => {
    const crumbs = allPages
      .sort((a, b) => a.level - b.level)
      .map((page) => {
        return {
          title: page.title,
          disabled: route.path === page.path,
          href: page.path,
          icon: page.icon,
        }
      })
    return crumbs
  })

  const pages = computed(() => {
    return allPages.filter((page) => page.level < 2)
  })

  return {
    pages,
    title,
    breadcrumbs,
  }
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useNavigationStore, import.meta.hot))
}
```

2. Include the new Navigation store in Main store `@/stores/index.ts`

```ts{5,11}
import { defineStore, acceptHMRUpdate } from 'pinia'

export const useAppStore = defineStore('app', () => {
  const settings = useSettingsStore()
  const navigation = useNavigationStore()

  function init() {
    settings.init()
  }

  return { settings, navigation, init }
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useSettingsStore, import.meta.hot))
}
```

3. Add breadcrumbs and navigation store to `@/App.vue`

```vue
<template>
  <v-app>
    <v-navigation-drawer v-model="drawer" app>
      <v-list>
        <v-list-item
          v-for="page in app.navigation.pages"
          :key="page.path"
          :prepend-icon="page.icon"
          :to="page.path"
        >
          <v-list-item-title>{{ page.title }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar>
      <!-- ... -->
    </v-app-bar>
    <v-main class="ma-4">
      <v-breadcrumbs :items="app.navigation.breadcrumbs">
        <template v-slot:title="{ item, index }">
          <v-breadcrumbs-item
            v-if="index !== app.navigation.breadcrumbs.length - 1"
            :to="item.href"
          >
            {{ item.title }}
          </v-breadcrumbs-item>
          <v-breadcrumbs-item v-else>{{ item.title }}</v-breadcrumbs-item>
        </template>
      </v-breadcrumbs>
      <router-view />
    </v-main>
    <v-footer app>
      <!-- ... -->
    </v-footer>
  </v-app>
</template>

<script setup lang="ts">
const drawer = ref(false)
const { mobile } = useDisplay()
const app = useAppStore()
onMounted(() => {
  app.init()
})
</script>
```

4. Add cards to Home view `@/pages/index.vue`

```vue
<template>
  <h1>Home</h1>
  <v-row>
    <v-col
      cols="12"
      md="4"
      v-for="page in navigation.pages.filter((page) => page.path !== '/')"
      :key="page.path"
    >
      <v-card
        min-height="8em"
        :style="cardBackground(page.color)"
        :prepend-icon="page.icon"
        :title="page.title"
        :to="page.path"
        :text="page.description"
      >
      </v-card>
    </v-col>
  </v-row>
</template>

<script setup lang="ts">
definePage({
  meta: {
    title: 'Welcome Home',
    description: 'Welcome to the home page',
    icon: '$mdiHome',
    color: '#ABCDEF',
  },
})
const navigation = useNavigationStore()
const cardBackground = useCardBackground
</script>
```

## Dynamic Page title

1. Install [Unhead](https://unhead.unjs.io/) to enable manipulation of page head data

```ps
npm install @unhead/vue
```

2. Modify `./vite.config.ts` to add `unhead` to auto imports

```ts{2,10}
// ...
import { unheadComposablesImports } from 'unhead'
// ...
export default defineConfig({
  plugins: [
// ...
    AutoImport({
      imports: [
//...
        unheadComposablesImports[0],
//...
      ],
    })
  ],
})
```

3. Create `unhead` instance in `@/main.ts`

```ts
// ...
import { createHead } from '@unhead/vue'
// ...
app.use(createHead())
// ...
```

4. Modify router `@/router/index.ts` to enable dynamic page title

```ts{4-7}
//...
router.beforeEach(async (to) => {
// ...
  const appTitle = 'Bullshit Bingo'
  const pageTitle = useNavigationStore().title(to.path)
  const title = pageTitle ? `${appTitle} - ${pageTitle}` : appTitle
  useHead({ title })

  return true
})
// ...
```

## Page not found

1. Add Page not found page `@/pages/[...path].vue`

```vue
<template>
  <h1>Page not found!</h1>
  <p>Ups! The page you are looking for does not exist.</p>
  <router-link to="/">Go back to the home page</router-link>
</template>
```

2. Exclude Page Not Found from pages and breadcrumbs in `@/stores/app/navigation.ts`

```ts{4,20}
// ...
  const breadcrumbs = computed(() => {
    const crumbs = allPages
      .filter((page) => page.path !== '/:path(.*)')
      .sort((a, b) => a.level - b.level)
      .map((page) => {
        return {
          title: page.title,
          disabled: route.path === page.path,
          href: page.path,
          icon: page.icon,
        }
      })
    return crumbs
  })

  const pages = computed(() => {
    return allPages
      .filter((page) => page.level < 2)
      .filter((page) => page.path !== '/:path(.*)')
  })
// ...
```
