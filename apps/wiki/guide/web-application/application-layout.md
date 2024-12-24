# Application layout

Vuetify provides `v-app` and other components to create [application layout](https://vuetifyjs.com/en/features/application-layout/) for really mature looking apps. Along with centralized Pinia [state management](https://vuejs.org/guide/scaling-up/state-management) it becomes the backbone for the app.

This article shows how to create main layout, backed by Pinia store. Enhancements:

- new layout with app bar, navigation bar and footer.

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
