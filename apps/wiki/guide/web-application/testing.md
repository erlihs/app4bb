# Testing

Vue and Vite has its own ecosystem for [unit and component testing](https://vuejs.org/guide/scaling-up/testing.html).

And one of recommended options is Cypress that provide both - [Component testing](https://docs.cypress.io/guides/component-testing/vue/overview#Vue-with-Vite) and [End to end testing](https://docs.cypress.io/guides/end-to-end-testing/writing-your-first-end-to-end-test).

## Getting started

When the project was [set up](./install-vite-vue-ts.md) with these options, **Vitest** and **Cypress** both are enabled out-of-the-box.

> ✔ Add Vitest for Unit testing? … Yes
> ✔ Add an End-to-End Testing Solution? … Cypress

## Component tests

1. Create global configuration to always include vuetify plugin for component tests.

- Add Vuetify plugin and related imports to `@tsconfig.json`

```json
{
  // ...
  "include": [
    // ...
    "./src/plugins/vuetify.ts",
    "./src/plugins/i18n.ts",
    "./src/themes/*.ts"
  ]
  // ...
}
```

- Modify imports in `@/plugins/vuetify` to avoid type check errors

```ts
// ...
import light from '../themes/light'
import dark from '../themes/dark'
import defaults from '../themes/defaults'
import icons from '../themes/icons'
// ...
```

- modify Vitest configuration

::: details `@./vitest.config.setup.ts`
<<< ../../../vitest.config.setup.ts
:::

::: details `@./vitest.config.ts`
<<< ../../../vitest.config.ts
:::

Now component tests can be created without adding vuetify for each component individually

```ts
import { mount } from '@vue/test-utils'
import { describe, it, expect, beforeEach, vi } from 'vitest'
import VBsbTable from '@/components/VBsbTable.vue'
//import vuetify from '../../plugins/vuetify'

const factory = (props = {}) => {
  return mount(VBsbTable, {
    //    global: {
    //      plugins: [vuetify]
    //    },
  })
}
//...
```

2. Run tests

```ps
npm run test:unit
```

## e2e testing - Cypress

1. Rename `./cypress/e2e/example.cy.ts` to `./cypress/e2e/App.cy.ts` and modify to test, if App opens and navigation works.

```ts
describe('Open app', () => {
  it('visits the app root url', () => {
    cy.visit('http://localhost:4173/')
    cy.contains('h1', 'Home')
  })
})

describe('Navigate to About', () => {
  it('visits the about page', () => {
    cy.visit('http://localhost:4173/about')
    cy.contains('h1', 'About')
  })
})
```

2. Run Cypress and select e2e testing

```ps
npm run dev --port 5173
npx cypress open
```

or, alternatively, tests can be run from command line

```ps
npm run test:e2e
```

3. Recording (optional)

Notable feature is option to save files as video by adding to `/cypress.config.ts` (when e2e tests run from command line).

```ts{7,8}
import { defineConfig } from 'cypress'

export default defineConfig({
  e2e: {
    specPattern: 'cypress/e2e/**/*.{cy,spec}.{js,jsx,ts,tsx}',
    baseUrl: 'http://localhost:4173',
    video: true,
    videosFolder: "./cypress/videos",
  }
})

```
