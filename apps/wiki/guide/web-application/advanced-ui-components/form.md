# VBsbForm Component Documentation

## Overview

The `VBsbForm` component is a dynamic and flexible form generator built using Vuetify components. It is designed to handle a wide variety of form inputs and actions, making it suitable for complex forms that can be customized through props like `fields`, `options`, and `actions`. This component dynamically generates form elements based on the configuration passed via props and supports validation, submit, and cancel actions.

## Features

### Automatic Behaviors

- **First Field Auto-Focus**: Automatically focuses the first enabled and visible field when the form loads
- **Enter Key Submission**: Pressing Enter on the last field triggers form submission
- **Password Visibility Toggle**: Password fields include a show/hide toggle button
- **Data Synchronization**: Automatically syncs form field values with the provided data prop
- **Translation Support**: Built-in support for internationalization of labels, placeholders, and messages
- **Default Actions**: Pre-configured submit, cancel, and validate actions with customizable appearance

### Form Validation

- Validates on invalid input by default
- Supports extensive validation rules
- Provides field-level and form-level error handling
- Real-time validation feedback

## Usage Examples

### Basic Example

```vue
<template>
  <VBsbForm
    :data="formData"
    :options="formOptions"
    @submit="onSubmit"
    @cancel="onCancel"
    @validate="onValidate"
  />
</template>

<script setup lang="ts">
const formData = ref({
  username: '',
  email: '',
  password: '',
})

const formOptions = {
  fields: [
    { name: 'username', type: 'text', label: 'Username', required: true },
    { name: 'email', type: 'email', label: 'Email', required: true },
    { name: 'password', type: 'password', label: 'Password', required: true },
  ],
  actions: ['submit', 'cancel'],
}

const onSubmit = (data) => {
  console.log('Form submitted with data:', data)
}

const onCancel = () => {
  console.log('Form cancelled')
}

const onValidate = (data, errors) => {
  console.log('Form validation result:', data, errors)
}
</script>
```

### Example with Complex Validation and Custom Actions

```vue
<template>
  <VBsbForm 
    :data="formData" 
    :options="formOptions" 
    :loading="isSubmitting"
    @submit="onSubmit" 
  />
</template>

<script setup lang="ts">
import { ref } from 'vue'

const isSubmitting = ref(false)
const formData = ref({
  username: '',
  email: '',
  password: '',
  confirmPassword: '',
})

const formOptions = {
  fields: [
    {
      name: 'username',
      type: 'text',
      label: 'Username',
      required: true,
      rules: [
        { type: 'min-length', params: 3, message: 'Username must be at least 3 characters long' },
      ],
    },
    {
      name: 'email',
      type: 'email',
      label: 'Email',
      required: true,
      rules: [{ type: 'email', params: true, message: 'Email is not valid' }],
    },
    {
      name: 'password',
      type: 'password',
      label: 'Password',
      required: true,
      rules: [
        {
          type: 'password',
          params: true,
          message: 'Password must be at least 8 characters with letters and numbers',
        },
      ],
    },
    {
      name: 'confirmPassword',
      type: 'password',
      label: 'Confirm Password',
      required: true,
      rules: [{ type: 'same-as', params: 'password', message: 'Passwords must match' }],
    },
  ],
  actions: [
    { name: 'submit', format: { text: 'Create Account', color: 'success', icon: 'mdi-account-plus' } },
    { name: 'validate', format: { color: 'info', variant: 'outlined' } },
    { name: 'cancel', format: { color: 'error', variant: 'text' } },
  ],
  actionAlign: 'center',
  cols: 2,
  focusFirst: true,
}

async function onSubmit(newData) {
  isSubmitting.value = true
  // Simulate API call
  await new Promise(resolve => setTimeout(resolve, 2000))
  isSubmitting.value = false
  console.log('Form submitted with data:', newData)
}
</script>
```

## API

### Props

| Prop      | Type             | Required | Default | Description                                                                              |
| --------- | ---------------- | -------- | ------- | ---------------------------------------------------------------------------------------- |
| `data`    | `Object`         | No       | `{}`    | Initial form data object. This object is reactive and updated as the form inputs change. |
| `options` | `BsbFormOptions` | Yes      | `{}`    | Configuration object that defines the fields, actions, and settings for the form.        |
| `loading` | `Boolean`        | No       | `false` | Shows a loading overlay with progress indicator when true.                               |
| `t`       | `Function`       | No       | `(text) => text` | Translation function for internationalizing form content.                       |

#### BsbFormOptions

| Property        | Type                       | Required | Default     | Description                                                                            |
| --------------- | -------------------------- | -------- | ----------- | -------------------------------------------------------------------------------------- |
| `fields`        | `Array<BsbFormField>`      | Yes      | `[]`        | Defines the fields to be rendered in the form.                                         |
| `cols`          | `number`                   | No       | `1`         | Number of columns the form should use for layout (e.g., 3 columns).                    |
| `actions`       | `Array<BsbAction>`         | No       | `[]`        | Defines the action buttons that are rendered below the form fields.                    |
| `actionFormat`  | `BsbFormat`                | No       | `{}`        | Default format for action buttons.                                                     |
| `actionAlign`   | `'left'/'right'/'center'`  | No       | `'left'`    | Alignment of action buttons.                                                           |
| `actionSubmit`  | `string`                   | No       | `'submit'`  | Name of the submit action.                                                             |
| `actionReset`   | `string`                   | No       | `'reset'`   | Name of the reset action.                                                              |
| `actionValidate`| `string`                   | No       | `'validate'`| Name of the validate action.                                                           |
| `actionCancel`  | `string`                   | No       | `'cancel'`  | Name of the cancel action.                                                             |
| `autocomplete`  | `'on'/'off'`               | No       | `undefined` | Form autocomplete behavior.                                                            |
| `disabled`      | `boolean`                  | No       | `false`     | Disables all form fields.                                                              |
| `readonly`      | `boolean`                  | No       | `false`     | Makes all form fields read-only.                                                       |
| `fastFail`      | `boolean`                  | No       | `false`     | If true, stops validation on first error.                                              |
| `errors`        | `Array<BsbFormFieldError>` | No       | `[]`        | Array of form-level errors to show on specific fields.                                 |
| `focusFirst`    | `boolean`                  | No       | `false`     | Automatically focus the first field when form loads.                                   |

#### BsbFormField

| Property           | Type                           | Required | Default     | Description                                                                                                |
| ------------------ | ------------------------------ | -------- | ----------- | ---------------------------------------------------------------------------------------------------------- |
| `type`             | `string`                       | Yes      | -           | The type of form input to render (text, email, password, etc).                                             |
| `name`             | `string`                       | Yes      | -           | The unique name identifier for the field.                                                                  |
| `value`            | `any`                          | No       | `undefined` | Default value for the field.                                                                               |
| `label`            | `string`                       | No       | `''`        | Label for the form field. Supports translation.                                                            |
| `placeholder`      | `string`                       | No       | `''`        | Placeholder text for the field. Supports translation.                                                      |
| `autocomplete`     | `'on'/'off'`                   | No       | `undefined` | Browser autocomplete behavior for the field.                                                               |
| `required`         | `boolean`                      | No       | `false`     | Whether the field is required.                                                                             |
| `readonly`         | `boolean`                      | No       | `false`     | Whether the field is read-only.                                                                            |
| `hidden`           | `boolean`                      | No       | `false`     | Whether the field is hidden.                                                                               |
| `disabled`         | `boolean`                      | No       | `false`     | Whether the field is disabled.                                                                             |
| `clearable`        | `boolean`                      | No       | `false`     | Whether the field has a clear button.                                                                      |
| `prefix`           | `string`                       | No       | `''`        | Prefix text for the field.                                                                                 |
| `suffix`           | `string`                       | No       | `''`        | Suffix text for the field.                                                                                 |
| `variant`          | `string`                       | No       | `undefined` | The visual variant of the input field.                                                                     |
| `density`          | `string`                       | No       | `undefined` | Density of the field.                                                                                      |
| `color`            | `string`                       | No       | `undefined` | Color of the field when active.                                                                            |
| `hint`             | `string`                       | No       | `''`        | Hint text to display below the field. Supports translation.                                                |
| `prependIcon`      | `string`                       | No       | `undefined` | Icon to display before the field.                                                                          |
| `appendIcon`       | `string`                       | No       | `undefined` | Icon to display after the field.                                                                           |
| `prependInnerIcon` | `string`                       | No       | `undefined` | Icon to display inside the field before the content.                                                       |
| `appendInnerIcon`  | `string`                       | No       | `undefined` | Icon to display inside the field after the content. For password fields, this shows the visibility toggle. |
| `rules`            | `Array<BsbRule>`               | No       | `[]`        | Array of validation rules applied to the field.                                                            |
| `counter`          | `boolean/number`               | No       | `undefined` | Character counter for text fields.                                                                         |

For specific field types, additional properties are available:

- **Textarea fields**:
  - `rows`: Number of visible text rows (default: 5)
  - `noResize`: Prevent user from resizing (default: false)
  - `autoGrow`: Automatically adjust height to content (default: false)

- **Rating fields**:
  - `length`: Number of rating items (default: 5)
  - `size`: Size of rating items (default: 24)
  - `itemLabels`: Labels for rating items

- **Selection fields** (select, combobox, autocomplete):
  - `items`: Array of items or option values
  - `chips`: Display selected items as chips (default: false)
  - `multiple`: Allow multiple selections (default: false)

#### BsbAction

Actions can be either strings (using default settings) or objects for customization:

```typescript
type BsbAction = string | {
  key?: string
  name: string
  format?: BsbFormat | BsbFormat[]
}
```

#### BsbFormat

```typescript
type BsbFormat = {
  rules?: BsbRule | BsbRule[]
  text?: string
  icon?: string
  color?: string
  variant?: 'flat' | 'outlined' | 'plain' | 'text' | 'elevated' | 'tonal'
  density?: 'compact' | 'default' | 'comfortable'
  size?: 'x-small' | 'small' | 'default' | 'large' | 'x-large'
  rounded?: boolean
  class?: string
  to?: string
  href?: string
  target?: string
}
```

#### BsbRule

```typescript
type BsbRule = {
  type: string
  params: unknown
  message?: string
}
```

Supported rule types include: `required`, `min-length`, `max-length`, `equals`, `equals-not`, `starts-with`, `ends-with`, `contains`, `greater-than`, `less-than`, `in-range`, `includes`, `set`, `password`, `email`, `url`, `ip`, `regexp`, `same-as`, `is-json`, and `custom`.

### Events

| Event      | Payload                      | Description                                                              |
| ---------- | ---------------------------- | ------------------------------------------------------------------------ |
| `submit`   | `formData: BsbFormData`      | Emitted when the form is successfully validated and submitted.           |
| `cancel`   | none                         | Emitted when the form's cancel action is triggered.                      |
| `reset`    | none                         | Emitted when the form's reset action is triggered.                       |
| `validate` | `formData, errors?`          | Emitted after form validation, with data and optional error information. |
| `action`   | `actionName, formData`       | Emitted when a custom action is triggered.                               |

### Form Behavior

#### Validation

- The form validates on invalid input by default (`validate-on="invalid-input"`)
- Validation happens when:
  - A field value changes
  - The form is submitted
  - The validate action is triggered

#### Data Synchronization

- The form watches for changes in the `data` prop and updates field values accordingly
- Initial field values can be set via the field's `value` property or through the `data` prop

#### Focus Management

- When `focusFirst` is true, the first enabled and visible field is automatically focused
- Enter key on the last field triggers form submission if a submit action is defined
- Password fields include a visibility toggle button (eye icon)

#### Default Actions

The form supports several pre-configured action types:

1. `submit` - Triggers form validation and submission
2. `cancel` - Emits the cancel event
3. `reset` - Resets form fields to initial values
4. `validate` - Performs form validation

Custom actions can be defined and will emit the `action` event with the action name and current form data.

## Supported Field Types

The component supports the following field types:

- `text` - Standard text input
- `email` - Email input with validation
- `password` - Password input with visibility toggle
- `textarea` - Multi-line text input
- `number` - Numeric input
- `switch` - Toggle switch
- `rating` - Star rating input
- `checkbox` - Checkbox input
- `select` - Dropdown selection
- `combobox` - Searchable dropdown
- `autocomplete` - Text input with suggestions
- `file` - File upload
- `date` - Date picker
- `time` - Time picker
- `datetime` - Date and time picker

## Source

:::details Component `'components/VBsbForm.vue`' (see below for file content)
<<< @../../src/components/VBsbForm.vue
:::

:::details Test `'components/__tests__/VBsbForm.test.ts`' (see below for file content)
<<< @../../src/components/__tests__/VBsbForm.test.ts
:::
