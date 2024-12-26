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
const formData = {
  username: '',
  email: '',
  password: '',
}

const formOptions = {
  cols: 2,
  fields: [
    { name: 'username', type: 'text', label: 'Username', required: true },
    { name: 'email', type: 'email', label: 'Email', required: true },
    { name: 'password', type: 'password', label: 'Password', required: true },
  ],
  actions: [
    { type: 'submit', title: 'Submit', color: 'success' },
    { type: 'cancel', title: 'Cancel', color: 'error', variant: 'outlined' },
  ],
}

const onSubmit = (data: any) => {
  console.log('Form submitted with data:', data)
}

const onCancel = () => {
  console.log('Form cancelled')
}

const onValidate = ({ valid, errors }: { valid: boolean; errors: any[] }) => {
  console.log('Form validation result:', valid, errors)
}
</script>
```

### Example with Complex Validation and Custom Actions

```vue
<template>
  <VBsbForm :data="formData" :options="formOptions" @submit="onSubmit" />
</template>

<script setup lang="ts">
const formData = {
  username: '',
  email: '',
  password: '',
  confirmPassword: '',
}

const formOptions = {
  fields: [
    {
      name: 'username',
      type: 'text',
      label: 'Username',
      required: true,
      rules: [
        { type: 'min-length', value: 3, message: 'Username must be at least 3 characters long' },
      ],
    },
    {
      name: 'email',
      type: 'email',
      label: 'Email',
      required: true,
      rules: [{ type: 'email', message: 'Email is not valid' }],
    },
    {
      name: 'password',
      type: 'password',
      label: 'Password',
      required: true,
      rules: [
        {
          type: 'password',
          message: 'Password must be at least 8 characters with letters and numbers',
        },
      ],
    },
    {
      name: 'confirmPassword',
      type: 'password',
      label: 'Confirm Password',
      required: true,
      rules: [{ type: 'same-as', value: 'password', message: 'Passwords must match' }],
    },
  ],
  actions: [
    { type: 'submit', title: 'Create Account', color: 'success', icon: '$mdiAccountPlus' },
    { type: 'validate', title: 'Check Form', color: 'info', variant: 'outlined' },
    { type: 'cancel', title: 'Reset', color: 'error', variant: 'text' },
  ],
  actionsAlign: 'right',
  actionsClass: 'mt-4',
}
</script>
```

## API

### Props

| Prop      | Type             | Required | Default | Description                                                                              |
| --------- | ---------------- | -------- | ------- | ---------------------------------------------------------------------------------------- |
| `data`    | `Object`         | No       | `{}`    | Initial form data object. This object is reactive and updated as the form inputs change. |
| `options` | `BsbFormOptions` | Yes      | `{}`    | Configuration object that defines the fields, actions, and settings for the form.        |

#### BsbFormOptions

| Property       | Type                                      | Required | Default     | Description                                                                            |
| -------------- | ----------------------------------------- | -------- | ----------- | -------------------------------------------------------------------------------------- |
| `fields`       | `Array<BsbFormField>`                     | Yes      | `[]`        | Defines the fields to be rendered in the form.                                         |
| `cols`         | `number`                                  | No       | `1`         | Number of columns the form should span.                                                |
| `variant`      | `string`                                  | No       | `outlined`  | The visual variant of form fields (e.g., `outlined`, `filled`, etc.).                  |
| `density`      | `'default' \| 'comfortable' \| 'compact'` | No       | `'default'` | Density of the form fields (spacing and padding).                                      |
| `actions`      | `Array<BsbFormAction>`                    | No       | `[]`        | Defines the action buttons that are rendered below the form fields.                    |
| `actionsAlign` | `'left' \| 'right'`                       | No       | `'left'`    | Alignment of action buttons.                                                           |
| `actionsClass` | `string`                                  | No       | `''`        | CSS class to apply to the actions container.                                           |
| `errors`       | `Array<BsbFormError>`                     | No       | `[]`        | Array of form-level errors. This is used to display error messages at the field level. |

#### BsbFormField

| Property           | Type                                                                                                                                                                                      | Required | Default      | Description                                                                                                |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------ | ---------------------------------------------------------------------------------------------------------- |
| `type`             | `'text' \| 'number' \| 'password' \| 'email' \| 'textarea' \| 'switch' \| 'rating' \| 'checkbox' \| 'select' \| 'combobox' \| 'autocomplete' \| 'file' \| 'date' \| 'time' \| 'datetime'` | Yes      | `text`       | The type of form input to render.                                                                          |
| `name`             | `string`                                                                                                                                                                                  | Yes      | `''`         | The unique name identifier for the field.                                                                  |
| `value`            | `any`                                                                                                                                                                                     | No       | `''`         | The current value of the field.                                                                            |
| `label`            | `string`                                                                                                                                                                                  | No       | `''`         | Label for the form field. Supports translation.                                                            |
| `placeholder`      | `string`                                                                                                                                                                                  | No       | `''`         | Placeholder text for the field. Supports translation.                                                      |
| `required`         | `boolean`                                                                                                                                                                                 | No       | `false`      | Whether the field is required.                                                                             |
| `readonly`         | `boolean`                                                                                                                                                                                 | No       | `false`      | Whether the field is read-only.                                                                            |
| `hidden`           | `boolean`                                                                                                                                                                                 | No       | `false`      | Whether the field is hidden.                                                                               |
| `disabled`         | `boolean`                                                                                                                                                                                 | No       | `false`      | Whether the field is disabled.                                                                             |
| `clearable`        | `boolean`                                                                                                                                                                                 | No       | `false`      | Whether the field has a clear button.                                                                      |
| `prefix`           | `string`                                                                                                                                                                                  | No       | `''`         | Prefix text or icon for the field.                                                                         |
| `suffix`           | `string`                                                                                                                                                                                  | No       | `''`         | Suffix text or icon for the field.                                                                         |
| `variant`          | `'outlined' \| 'filled' \| 'underlined' \| 'solo' \| 'solo-inverted' \| 'solo-filled' \| 'plain'`                                                                                         | No       | `'outlined'` | The visual variant of the input field.                                                                     |
| `density`          | `'default' \| 'comfortable' \| 'compact'`                                                                                                                                                 | No       | `'default'`  | Density of the field.                                                                                      |
| `color`            | `string`                                                                                                                                                                                  | No       | `undefined`  | Color of the field when active.                                                                            |
| `hint`             | `string`                                                                                                                                                                                  | No       | `''`         | Hint text to display below the field. Supports translation.                                                |
| `prependIcon`      | `string`                                                                                                                                                                                  | No       | `undefined`  | Icon to display before the field.                                                                          |
| `appendIcon`       | `string`                                                                                                                                                                                  | No       | `undefined`  | Icon to display after the field.                                                                           |
| `prependInnerIcon` | `string`                                                                                                                                                                                  | No       | `undefined`  | Icon to display inside the field before the content.                                                       |
| `appendInnerIcon`  | `string`                                                                                                                                                                                  | No       | `undefined`  | Icon to display inside the field after the content. For password fields, this shows the visibility toggle. |
| `rules`            | `Array<BsbFormValidationRule>`                                                                                                                                                            | No       | `[]`         | Array of validation rules applied to the field.                                                            |
| `errors`           | `string[]`                                                                                                                                                                                | No       | `[]`         | Array of error messages to display for this field.                                                         |
| `rows`             | `number`                                                                                                                                                                                  | No       | `5`          | Number of rows for textarea fields.                                                                        |
| `counter`          | `boolean \| number \| string`                                                                                                                                                             | No       | `undefined`  | Character counter for textarea fields.                                                                     |
| `noResize`         | `boolean`                                                                                                                                                                                 | No       | `false`      | Prevents textarea resizing.                                                                                |
| `autoGrow`         | `boolean`                                                                                                                                                                                 | No       | `false`      | Enables textarea auto-growing.                                                                             |
| `length`           | `number`                                                                                                                                                                                  | No       | `5`          | Number of stars for rating fields.                                                                         |
| `size`             | `number`                                                                                                                                                                                  | No       | `24`         | Size of rating stars in pixels.                                                                            |
| `items`            | `string[]`                                                                                                                                                                                | No       | `[]`         | Array of items for select, combobox, and autocomplete fields.                                              |
| `chips`            | `boolean`                                                                                                                                                                                 | No       | `false`      | Display selected items as chips.                                                                           |
| `multiple`         | `boolean`                                                                                                                                                                                 | No       | `false`      | Allow multiple selections.                                                                                 |

#### BsbFormAction

| Property  | Type                                                                 | Required | Default     | Description                                                                          |
| --------- | -------------------------------------------------------------------- | -------- | ----------- | ------------------------------------------------------------------------------------ |
| `type`    | `'submit' \| 'cancel' \| 'validate'`                                 | Yes      | `submit`    | The type of action button. Determines its functionality (e.g., submitting the form). |
| `title`   | `string`                                                             | No       | `''`        | The text label of the action button. Supports translation.                           |
| `icon`    | `string`                                                             | No       | `''`        | Icon name to show on the button.                                                     |
| `color`   | `string`                                                             | No       | `'primary'` | The color of the action button.                                                      |
| `variant` | `'flat' \| 'text' \| 'elevated' \| 'tonal' \| 'outlined' \| 'plain'` | No       | `'text'`    | The visual style of the action button.                                               |
| `density` | `'default' \| 'comfortable' \| 'compact'`                            | No       | `'default'` | Density of the action button (spacing and padding).                                  |

#### BsbFormValidationRule

| Property  | Type                                                                                                                                                                                                                                                         | Required | Default    | Description                                                                             |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | ---------- | --------------------------------------------------------------------------------------- |
| `type`    | `'required' \| 'min-length' \| 'max-length' \| 'equals' \| 'equals-not' \| 'starts-with' \| 'ends-with' \| 'greater-than' \| 'less-than' \| 'in-range' \| 'set' \| 'password' \| 'email' \| 'url' \| 'ip' \| 'regexp' \| 'same-as' \| 'is-json' \| 'custom'` | Yes      | `required` | The type of validation rule applied to the form field.                                  |
| `value`   | `any`                                                                                                                                                                                                                                                        | No       | `null`     | The value associated with the validation rule (e.g., minimum length, comparison value). |
| `message` | `string`                                                                                                                                                                                                                                                     | Yes      | `''`       | The validation error message to show if the rule is violated. Supports translation.     |

### Events

| Event      | Payload                                         | Description                                                                               |
| ---------- | ----------------------------------------------- | ----------------------------------------------------------------------------------------- |
| `submit`   | `data: Record<string, any>`                     | Emitted when the form is successfully validated and submitted.                            |
| `cancel`   | `void`                                          | Emitted when the form's cancel action is triggered.                                       |
| `validate` | `{ valid: boolean, errors: any[] }`             | Emitted after form validation occurs, providing whether the form is valid and any errors. |
| `action`   | `{ action: string, data: Record<string, any> }` | Emitted when a custom action is triggered.                                                |

### Form Behavior

#### Validation

- The form validates on invalid input by default (`validate-on="invalid-input"`)
- Validation is performed when:
  - A field value changes
  - The form is submitted
  - The validate action is triggered
- Field-level validation uses the rules defined in the field configuration
- Form-level validation aggregates all field validations

#### Data Synchronization

- The form watches for changes in the `data` prop and updates field values accordingly
- When form values change, the parent component is updated through events
- The `refresh()` method is called internally to sync data and field values

#### Focus Management

- On mount, the first enabled and visible field is automatically focused
- Enter key on the last field triggers form submission
- Password fields include a visibility toggle button

#### Default Actions

The form comes with three pre-configured actions:

1. Submit (`type: 'submit'`)
   - Icon: check mark
   - Color: success
   - Triggers form validation and submission
2. Cancel (`type: 'cancel'`)
   - Icon: close
   - Color: error
   - Variant: outlined
   - Resets form to initial values
3. Validate (`type: 'validate'`)
   - Icon: check mark
   - Color: info
   - Variant: outlined
   - Triggers form validation

These default actions can be:

- Used directly by specifying action types as strings
- Customized by providing full action objects
- Mixed with custom actions
- Reordered or subset selected

#### Internationalization

The component supports translation through the `t()` function for:

- Field labels
- Placeholders
- Hints
- Validation messages
- Action button texts
- Error messages

## Source

:::details Component `'components/VBsbForm.vue`' (see below for file content)
<<< @../../src/components/VBsbForm.vue
:::

:::details Test `'components/__tests__/VBsbForm.test.ts`' (see below for file content)

<!-- prettier-ignore -->
<<< @../../src/components/__tests__/VBsbForm.test.ts
:::
