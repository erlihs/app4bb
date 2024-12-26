# Advanced UI Components

Follow Vue3 [Component Basics](https://vuejs.org/guide/essentials/component-basics) and [Components in Depth](https://vuejs.org/guide/components/registration.html) guidelines as well as [Vuetify Labs](https://vuetifyjs.com/en/labs/introduction/#what-is-labs) for new components.

In sections below see descriptions of component wrappers and usage examples for advanced UI components. The naming convention for new components will be `v-bsb-*`.

- [**Chart**](./chart.md) - Chart component based on [ChartJs](https://www.chartjs.org/)
- [**Editor**](./editor.md) - WYSIWYG editor, based on [TipTap](https://tiptap.dev/)
- [**Form**](./form.md) - Dynamic form builder
- [**Media**](./media.md) - Audio and video recording and playback
- [**Map**](./map.md) - Wrapper of [Google Maps](https://www.npmjs.com/package/vue3-google-map)
- [**Pad**](./pad.md) - Drawing canvas, credits to [vue-drawing-canvas](https://github.com/razztyfication/vue-drawing-canvas)
- [**Table**](./table.md) - Responsive data table
- [**Share**](./share.md) - Social sharing button set based on [Vue Socials](https://github.com/webistomin/vue-socials)

### Sandbox

Create sandbox item for each component. An example:

::: details `@/pages/sandbox/sandbox-chart.vue`
<<< ../../../../src/pages/sandbox/sandbox-chart.vue
:::

Add links in Sandbox page

::: details `@/pages/sandbox/index.vue`

```vue
<template>
  <!-- ... -->
  <v-container fluid>
    <h1 class="mb-4">Components</h1>
    <v-row>
      <v-col cols="12" md="6" lg="4" v-for="comp in compontents" :key="comp.to">
        <v-card :to="comp.to">
          <v-card-title><v-icon :icon="comp.icon" />{{ comp.text }}</v-card-title>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
// ...
const compontents = ref([
  { icon: '$mdiChartLine', to: '/sandbox/sandbox-chart', text: 'Chart' },
  // ...
])
</script>
```

:::
