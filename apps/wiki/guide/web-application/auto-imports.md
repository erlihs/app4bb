# Automatic import

Auto import in Vue refers to a feature that automatically imports components, plugins, modules or other resources into your Vue application without the need for manually specifying each import statement at the top of your files. This can greatly simplify codebase and reduce boilerplate, especially in large projects with many components.

There are side effects of using this technique. Some impact on build server start and reload time, as plugin scans all files. And dependencies are not clearly visible. Nevertheless, the positive impact on development speed is significant.

## Routes

Check [File Based Routing](file-based-routing.md).

## Composables

1. Install unplugin libraries

```ps
npm i -D unplugin-auto-import
```

2. Add aut o import configuration to `vite.config.ts`

```ts
// ...
import AutoImport from 'unplugin-auto-import/vite'
// ...
plugins: [
  // ...
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
          'useTheme',
        ],
      },
    ],
    dirs: ['./src/composables/**', './src/stores/**', './src/components/**'],
  }),
]
//...
```

This will create file `auto-imports.d.ts` containing auto imports for:

- vue, vue-router and i18n
- all composables for vuetify
- all composables from `@/composables` folder.

3. Add this file to `tsconfig.app,json`

```json
...
  "include": ["src/**/*.ts", "src/**/*.tsx", "src/**/*.vue", "cypress", "./cypress.d.ts", "./auto-imports.d.ts"],
...
```

4. Modify `@/pages/sandbox/index.vue` - remove all imports, add route in card text, modify how card background is set.

```vue
<template>
  <v-card :style="cardBackground('#00AA00')">
    <v-card-title><v-icon icon="$mdiHome" />{{ t('sandbox.title') }}</v-card-title>
    <v-card-text>{{ t('sandbox.content') }}</v-card-text>
    <v-card-text>{{ t('sandbox.missing') }}</v-card-text>
    <v-card-actions>
      <v-btn color="primary">Primary</v-btn>
      <v-btn color="secondary">Secondary</v-btn>
      <v-spacer></v-spacer>
      <v-btn @click="toggleTheme()">Toggle theme</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script setup lang="ts">
const { t } = useI18n()
const theme = useTheme()
const cardBackground = useCardBackground
function toggleTheme() {
  theme.global.name.value = theme.global.current.value.dark ? 'light' : 'dark'
}
</script>
```

## Components

1. Install [unplugin-vue-components](https://github.com/unplugin/unplugin-vue-components)

```ps
npm i unplugin-vue-components -D
```

2. Add component auto import in `./vite.config.ts`

```ts{2,7}
// ...
import Components from 'unplugin-vue-components/vite'
// ...
export default defineConfig({
  plugins: [
// ...
    Components({})
// ...
  ],
})
```

3. Remove `import HelloWorld from './components/HelloWorld.vue'` from `@/App.vue` to check that app still works.

## Icons

As on moment there is no native support yet - see [Feature request](https://github.com/vuetifyjs/vuetify-loader/issues/86), here is a custom plugin to generate icon includes based on `$mdi` pattern.

1. Create a plugin file

::: details `@/plugins/icons.ts`
<<< ../../../src/plugins/icons.ts
:::

### Options (`AutoImportMdiIconsOptions`):

- **`dirs`** (optional):

  - Type: `string[]`
  - Description: An array of directories to search for files that may contain Material Design Icons. The default is `['./src']`.
  - Example: `dirs: ['./src/components', './src/views']`

- **`exts`** (optional):

  - Type: `string[]`
  - Description: An array of file extensions to look for when scanning files. The default is `['.vue', '.ts']`.
  - Example: `exts: ['.vue', '.js']`

- **`pattern`** (optional):

  - Type: `string`
  - Description: A string pattern used to detect icon references in the files. The default is `'$mdi'`, so it looks for identifiers like `$mdiHome`, `$mdiAccount`, etc.
  - Example: `pattern: '$mdi'`

- **`outputPath`** (optional):

  - Type: `string`
  - Description: The path where the generated TypeScript file that consolidates the icons will be written. The default is `./src/themes/`.
  - Example: `outputPath: './src/assets/icons/'`

- **`outputFile`** (optional):

  - Type: `string`
  - Description: The name of the TypeScript file that will be generated to import and export the icons. The default is `icons.ts`.
  - Example: `outputFile: 'mdi-icons.ts'`

- **`log`** (optional):
  - Type: `boolean`
  - Description: Whether or not to log the plugin's actions (e.g., scanning files, detecting icons). The default is `false`.
  - Example: `log: true`

2. Add plugin to includes in `./tsconfig.node.json`

```json{5}
{
  "extends": "@tsconfig/node20/tsconfig.json",
  "include": [
// ...
    "./src/plugins/**/*.ts",
  ],
// ...
}
```

3. Add plugin to `./vite.config.ts`

```ts{2,7}
// ...
import { AutoImportMdiIcons } from './src/plugins/icons'
// ...
export default defineConfig({
  plugins: [
// ...
    AutoImportMdiIcons({})
// ...
  ],
// ...
})
```

4. Add new icon to `@/pages/sandbox/index.vue` and check that it is auto imported.

```vue
<!-- ... -->
<v-card-title><v-icon icon="$mdiHome" /><v-icon icon="$mdiHeart" />{{ t('sandbox.title') }}</v-card-title>
<!-- ... -->
```
