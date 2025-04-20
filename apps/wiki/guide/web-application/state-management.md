# State Management

## Pinia

Current application setup comes with prebuilt state management library [Pinia](https://pinia.vuejs.org/).

It is a recommended. It is type-safe, extensible, and modular by design.

This article will show how to enhance Pinia stores with configurable persistence and rehydration.

1. Create a Pinia plugin for persisted state.

::: details `@/plugins/pinia.ts`
<<< ../../../src/plugins/pinia.ts
:::

2. Modify `@/main.ts` to add persist plugin to pinia.

```ts
// ...
import { createPiniaLocalStoragePlugin } from './plugins/pinia'
// ...
app.use(createPinia().use(createPiniaLocalStoragePlugin()))
// ...
```

3. Create app store `@/stores/settings.ts`

```ts
import { defineStore, acceptHMRUpdate } from 'pinia'

export const useSettingsStore = defineStore(
  'settings',
  () => {
    const setTheme = useTheme()

    const theme = ref('light')

    function themeToggle() {
      theme.value = theme.value === 'light' ? 'dark' : 'light'
      setTheme.global.name.value = theme.value
    }

    const themeIcon = computed(() => {
      if (setTheme.global.name.value === 'light') return '$mdiWeatherSunny'
      if (setTheme.global.name.value === 'dark') return '$mdiWeatherNight'
    })

    function init() {
      setTheme.global.name.value = theme.value
    }

    return { theme, themeToggle, themeIcon, init }
  },
  {
    persist: {
      include: ['theme'],
    },
  },
)

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useSettingsStore, import.meta.hot))
}
```

4. Modify `@/pages/sandbox/index.vue` to use store for persisting theme - after closing and reopening browser theme is as it was set before

```vue{10,18-22}
<template>
  <v-card :style="cardBackground('#00AA00')">
    <v-card-title><v-icon icon="$mdiHome" />{{ t('sandbox.title') }}</v-card-title>
    <v-card-text>{{ t('sandbox.content') }}</v-card-text>
    <v-card-text>{{ t('sandbox.missing') }}</v-card-text>
    <v-card-actions>
      <v-btn color="primary">Primary</v-btn>
      <v-btn color="secondary">Secondary</v-btn>
      <v-spacer></v-spacer>
      <v-btn :prepend-icon="settings.themeIcon" @click="settings.themeToggle()">Toggle theme</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script setup lang="ts">
const cardBackground = useCardBackground
const { t } = useI18n()
import { useSettingsStore } from '@/stores/settings';
const settings = useSettingsStore()
onMounted(() => {
  settings.init()
})
</script>
```

## useSorage

For simple, local scenarios a custom made simple composable can be used to have a reactive value or object kept in local storage.

```ts
const admin = useStorage('admin', {tab: 'key'})
```

::: details `@/composables/storage.ts`
<<< @../../src/composables/storage.ts
:::
