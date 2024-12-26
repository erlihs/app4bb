# Table

## Overview

The `VBsbTable` component is a versatile, customizable table designed for displaying tabular data in Vue 3 applications using Vuetify. It includes features such as search, pagination, conditional formatting, and actions. The component can be used for desktop and mobile views, making it adaptable to responsive layouts.

## Usage Examples

### Basic Example

The following example demonstrates a basic usage of `VBsbTable`, including search, conditional formatting, and actions:

```html
<template>
  <v-bsb-table
    searchable
    :options="tableOptions"
    :items="tableData"
    @action="handleAction"
    @beforeFetch="beforeFetchHandler"
    @afterFetch="afterFetchHandler"
    @submit="submitHandler"
  />
</template>

<script setup lang="ts">
  import { ref } from 'vue'

  const tableOptions = ref({
    title: 'User Data Table',
    columns: [
      { column: 'name', title: 'Name' },
      { column: 'email', title: 'Email' },
      { column: 'phone', title: 'Phone' },
      { column: 'website', title: 'Website' },
    ],
    actions: [{ action: 'new', format: { icon: '$mdiPlus' } }],
  })

  const tableData = ref([
    {
      name: 'Leanne Graham',
      email: 'leanne@example.com',
      phone: '123-456',
      website: 'example.com',
    },
    { name: 'Ervin Howell', email: 'ervin@example.com', phone: '456-789', website: 'example.com' },
  ])

  function handleAction(action) {
    console.log('Action triggered:', action)
  }

  function beforeFetchHandler(data) {
    console.log('Before fetch:', data)
  }

  function afterFetchHandler(data) {
    console.log('After fetch:', data)
  }

  function submitHandler(data) {
    console.log('Form submit:', data)
  }
</script>
```

### Advanced Example with Conditional Formatting and Form Actions

The example below demonstrates the component with custom actions and conditional formatting for specific data fields:

```html
<template>
  <v-bsb-table
    searchable
    :options="tableOptions"
    :items="tableData"
    @action="handleAction"
    @submit="submitHandler"
  />
</template>

<script setup lang="ts">
  import { ref } from 'vue'

  const tableOptions = ref({
    title: 'Employee Data',
    columns: [
      {
        column: 'name',
        title: 'Employee Name',
        format: { condition: 'starts-with', params: 'A', color: 'blue' },
      },
      { column: 'email', title: 'Email', format: { condition: 'email', color: 'green' } },
      { column: 'role', title: 'Role' },
    ],
    actions: [
      { action: 'edit', format: { icon: '$mdiPencil', text: 'Edit' } },
      { action: 'delete', format: { icon: '$mdiDelete', color: 'red', variant: 'flat' } },
    ],
  })

  const tableData = ref([
    { name: 'Alice Johnson', email: 'alice@example.com', role: 'Manager' },
    { name: 'Bob Smith', email: 'bob@example.com', role: 'Developer' },
  ])

  function handleAction(action) {
    console.log('Action triggered:', action)
  }

  function submitHandler(data) {
    console.log('Form submitted:', data)
  }
</script>
```

## API

### Props

| Prop                | Type                  | Default                      | Description                                           |
| ------------------- | --------------------- | ---------------------------- | ----------------------------------------------------- |
| `title`             | `String`              | `""`                         | Title for the table.                                  |
| `searchable`        | `Boolean`             | `false`                      | If `true`, enables a search bar.                      |
| `searchLabel`       | `String`              | `"Search"`                   | Label for the search input field.                     |
| `searchPlaceholder` | `String`              | `""`                         | Placeholder for the search input field.               |
| `refreshable`       | `Boolean`             | `true`                       | If `true`, adds a refresh button to the footer.       |
| `items`             | `Array<BsbTableItem>` | Required                     | Array of items (data rows) to display in the table.   |
| `itemsPerPage`      | `Number`              | `10`                         | Number of items displayed per page.                   |
| `currentPage`       | `Number`              | `1`                          | Current page of the table.                            |
| `options`           | `BsbTableOptions`     | `{}`                         | Configuration options for columns, actions, and more. |
| `shorten`           | `Number`              | `null`                       | Length to which text fields will be shortened.        |
| `navigationFormat`  | `BsbTableFormat`      | Object with styling defaults | Format options for navigation buttons.                |
| `actionFormat`      | `BsbTableFormat`      | Object with styling defaults | Format options for action buttons.                    |

### Emits

| Event         | Arguments                                                                                      | Description                                                   |
| ------------- | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| `action`      | `{ action: string, item: BsbTableItem }`                                                       | Emitted when an action button is clicked.                     |
| `beforeFetch` | `{ items: Array, itemsPerPage: number, currentPage: number, newPage: number, search: string }` | Fired before fetching items.                                  |
| `afterFetch`  | `{ items: Array, itemsPerPage: number, currentPage: number, newPage: number, search: string }` | Fired after fetching items.                                   |
| `submit`      | `Record<string, unknown>`                                                                      | Emitted with form data when a form is submitted in an action. |

### Exposes

| Method  | Description                                              |
| ------- | -------------------------------------------------------- |
| `fetch` | Method to manually trigger data fetching and pagination. |

### Types

#### `BsbTableItem`

An object representing a single item (row) in the table. The object keys should match the column identifiers in `options.columns`.

#### `BsbTableFormat`

Format object used for defining styles, icons, and other configurations for table actions, navigation, and conditional formatting.

```typescript
export type BsbTableFormat = {
  condition?:
    | 'required'
    | 'min-length'
    | 'max-length'
    | 'equals'
    | 'equals-not'
    | 'starts-with'
    | 'ends-with'
    | 'greater-than'
    | 'less-than'
    | 'in-range'
    | 'set'
    | 'password'
    | 'email'
    | 'url'
    | 'ip'
    | 'regexp'
    | 'same-as'
    | 'is-json'
    | 'custom'
  params?: unknown
  text?: string
  icon?: string
  color?: string
  variant?: 'flat' | 'outlined' | 'plain' | 'text' | 'elevated' | 'tonal'
  density?: 'compact' | 'default' | 'comfortable'
  size?: 'x-small' | 'small' | 'default' | 'large' | 'x-large'
  class?: string
  to?: string
  target?: string
}
```

#### `BsbTableOptions`

Options object used to configure the table columns, actions, and overall layout.

```typescript
export type BsbTableOptions = {
  title?: string
  columns: Array<BsbTableColumn>
  actions?: Array<BsbTableAction>
}
```

#### `BsbTableColumn`

Defines each column in the table, including the title, formatting, and optional actions.

```typescript
export type BsbTableColumn = {
  column: string
  title?: string
  actions?: Array<BsbTableAction>
  format?: Array<BsbTableFormat> | BsbTableFormat
  shorten?: number
}
```

#### `BsbTableAction`

Describes each action that can be performed on a row item, including its label, icon, and any associated form.

```typescript
export type BsbTableAction = {
  action: string
  format?: BsbTableFormat
  form?: BsbFormOptions
}
```

Check [Form](./form.md) component for `BsbFormOptions`

## Source

:::details Component
<<< @../../src/components/VBsbTable.vue
:::

:::details Cell Sub Component
<<< @../../src/components/VBsbTableCell.vue
:::

:::details Test

<!-- prettier-ignore -->
<<< @../../src/components/__tests__/VBsbTable.test.ts
:::
