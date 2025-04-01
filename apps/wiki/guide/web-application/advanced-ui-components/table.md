# Table

## Overview

The `VBsbTable` component is a versatile, customizable table designed for displaying tabular data in Vue 3 applications using Vuetify. It includes features such as search, pagination, filtering, sorting, and column actions. The component adapts to both desktop and mobile views, making it responsive to different screen sizes.

## Usage Examples

### Basic Example

The following example demonstrates a basic usage of `VBsbTable`, including search and actions:

```html
<template>
  <v-bsb-table
    :options="tableOptions"
    :loading="loading"
    :t="t"
    @fetch="fetchData"
    @action="handleAction"
  />
</template>

<script setup lang="ts">
  import { ref } from 'vue'
  import { useI18n } from 'vue-i18n'
  
  const { t } = useI18n()
  const loading = ref(false)

  const tableOptions = ref({
    key: 'id',
    columns: [
      { name: 'name' },
      { name: 'email' },
      { name: 'phone' },
      { name: 'website' },
    ],
    actions: [
      { name: 'add', format: { icon: '$mdiPlus' } }
    ],
    search: {
      value: '',
      label: 'search',
      placeholder: 'Search users...'
    }
  })

  const tableData = ref([])

  async function fetchData(data, offset, limit, search, filter, sort) {
    loading.value = true
    // Fetch data from API or use local filtering/sorting logic
    data.value = [...fetchedData]
    loading.value = false
  }

  function handleAction(action, data, value) {
    console.log('Action triggered:', action, value)
  }
</script>
```

### Advanced Example with Filtering, Sorting and Custom Formats

The example below demonstrates the component with advanced features like filtering, sorting, and conditional formatting:

```html
<template>
  <v-bsb-table
    :options="tableOptions"
    :loading="loading"
    :t="t"
    @fetch="fetchData"
    @action="handleAction"
  />
</template>

<script setup lang="ts">
  import { ref } from 'vue'
  import { useI18n } from 'vue-i18n'
  
  const { t } = useI18n()
  const loading = ref(false)

  const tableOptions = ref({
    key: 'id',
    columns: [
      { name: 'name' },
      { name: 'email' },
      { 
        name: 'status', 
        format: [
          {
            rules: { type: 'equals', params: 'active' },
            color: 'green',
          },
          { color: 'red' }
        ],
        align: 'center'
      },
      {
        name: 'actions',
        align: 'right',
        actions: [
          {
            name: 'edit',
            format: { icon: '$mdiPencil' },
            form: {
              fields: [
                { type: 'text', name: 'name', label: 'Name' },
                { type: 'text', name: 'email', label: 'Email' },
                { 
                  type: 'select', 
                  name: 'status', 
                  label: 'Status', 
                  items: ['active', 'inactive'] 
                }
              ],
              actions: [
                { name: 'save', format: { text: 'Save' } },
                { name: 'cancel', format: { variant: 'outlined' } }
              ],
              actionSubmit: 'save',
              actionCancel: 'cancel'
            }
          },
          {
            name: 'delete',
            format: { icon: '$mdiDelete', color: 'red' }
          }
        ]
      }
    ],
    filter: {
      fields: [
        { type: 'text', name: 'name', label: 'Name' },
        { 
          type: 'select', 
          name: 'status', 
          label: 'Status', 
          items: ['active', 'inactive'],
          multiple: true
        }
      ],
      actions: [{ name: 'apply' }],
      actionSubmit: 'apply',
      actionCancel: 'cancel',
      cols: 2
    },
    sort: [
      { name: 'name', label: 'Name' },
      { name: 'email', label: 'Email' },
      { name: 'status', label: 'Status' }
    ],
    search: {
      value: '',
      label: 'search'
    },
    itemsPerPage: 10,
    currentPage: 1
  })

  const tableData = ref([])

  async function fetchData(data, offset, limit, search, filter, sort) {
    loading.value = true
    // Implement data fetching logic with sorting and filtering
    data.value = [...processedData]
    loading.value = false
  }

  function handleAction(action, data, value) {
    if (action === 'edit') {
      // Handle edit action
    } else if (action === 'delete') {
      // Handle delete action
    }
  }
</script>
```

## API

### Props

| Prop       | Type               | Default | Description                                           |
|------------|-------------------|---------|-------------------------------------------------------|
| `options`  | `BsbTableOptions` | Required | Configuration options for the table                   |
| `data`     | `BsbTableData[]`  | `[]`    | Initial data for the table (if not using fetch event) |
| `loading`  | `Boolean`         | `false` | Controls loading state of the table                   |
| `t`        | `Function`        | Identity function | Translation function for internationalization |

### Emits

| Event    | Arguments                                                                   | Description                                          |
|----------|-----------------------------------------------------------------------------|------------------------------------------------------|
| `fetch`  | `(data, offset, limit, search, filter, sort)`                               | Emitted when data needs to be fetched or refreshed   |
| `action` | `(action: string, data: Ref<BsbTableData[]>, value?: BsbTableData)`         | Emitted when an action button is clicked             |

### Types

#### `BsbTableOptions`

Options object used to configure the table:

```typescript
type BsbTableOptions = {
  key: string                // Primary key field name
  columns: BsbTableColumn[]  // Column definitions
  actions?: BsbAction[]      // Table-level actions
  actionFormat?: BsbFormat | BsbFormat[]  // Default formatting for actions
  search?: {                 // Search configuration
    value?: string
    label?: string
    placeholder?: string
  }
  filter?: BsbFormOptions    // Filter form configuration
  sort?: BsbTableSort[]      // Sortable columns configuration
  itemsPerPage?: number      // Number of items per page
  currentPage?: number       // Initial page number
  canRefresh?: boolean       // Whether to show refresh button
  maxLength?: number         // Default max length for text values
  align?: BsbAlign           // Default text alignment
}
```

#### `BsbTableColumn`

Defines each column in the table:

```typescript
type BsbTableColumn = {
  name: string                           // Column identifier/data field name
  title?: string                         // Defines column title
  format?: BsbFormat | BsbFormat[]       // Formatting options for the column
  actions?: BsbAction[]                  // Actions available for this column
  actionFormat?: BsbFormat | BsbFormat[] // Formatting for column actions
  maxLength?: number                     // Number of characters to show before truncation
  align?: BsbAlign                       // Text alignment for this column
}
```

#### `BsbTableSort`

Defines sortable columns:

```typescript
type BsbTableSort = {
  name: string             // Field name to sort by
  label?: string           // Display label
  value?: 'asc' | 'desc'   // Sort direction
}
```

#### `BsbFormat`

Format object used for defining styles, conditions, and other configurations:

```typescript
type BsbFormat = {
  rules?: BsbRule | BsbRule[]  // Conditional rules
  text?: string                // Button/chip text
  icon?: string                // Icon name (e.g. '$mdiPencil')
  color?: string               // Color name from theme
  variant?: 'flat' | 'outlined' | 'plain' | 'text' | 'elevated' | 'tonal'
  density?: 'compact' | 'default' | 'comfortable'
  size?: 'x-small' | 'small' | 'default' | 'large' | 'x-large'
  rounded?: boolean           // Whether to round the component
  class?: string              // Additional CSS classes
  to?: string                 // Vue Router destination
  href?: string               // Regular URL for links
  target?: string             // Link target attribute
  hidden?: boolean            // Whether to hide the element
}
```

#### `BsbRule`

Rules for conditional formatting:

```typescript
type BsbRule = {
  type: 'required' | 'min-length' | 'max-length' | 'equals' | 'equals-not' | 
        'starts-with' | 'ends-with' | 'contains' | 'greater-than' | 
        'less-than' | 'in-range' | 'includes' | 'set' | 'password' | 
        'email' | 'url' | 'ip' | 'regexp' | 'same-as' | 'is-json' | 'custom'
  params: unknown
  message?: string
}
```

#### `BsbAction`

Describes actions available on rows or the table:

```typescript
type BsbAction =
  | {
      key?: string                       // Optional field to evaluate against format rules
      name: string                       // Action identifier
      format?: BsbFormat | BsbFormat[]   // Formatting options
      form?: BsbFormOptions              // Form configuration if action opens a form
    }
  | string                               // Simple action with just a name
```

Check [Form](./form.md) component for `BsbFormOptions` details.

## Source

:::details Component
<<< @../../src/components/VBsbTable.vue
:::

:::details Test
<<< @../../src/components/__tests__/VBsbTable.test.ts
:::
