<template>
  <v-bsb-form :data :options @submit="submit" @cancel="cancel" @validate="validate" />
</template>

<script setup lang="ts">
const data = ref({
  text1: 'Hello World!',
  text2: 'Hello World, again!',
  text3: 'Hello World, some more!',
  number: 2,
  password: '',
  rating: 4,
  checkbox: false,
})

const customValidation = (value: string) => {
  return value.includes('custom') ? true : "Value must contain 'custom'"
}

const options = ref({
  fields: [
    {
      type: 'text',
      name: 'text1',
      label: 'Text 1',
      placeholder: 'Enter some text',
    },
    {
      type: 'text',
      name: 'text2',
      label: 'Text 2',
      placeholder: 'Enter some text',
      rules: [
        { type: 'required', value: true, message: 'Text 2 is required' },
        { type: 'is-json', value: true, message: 'Text 2 must be a valid JSON' },
      ],
    },
    {
      type: 'text',
      name: 'text3',
      label: 'Text 3',
      placeholder: 'Enter some text',
      variant: 'underlined',
      rules: [
        { type: 'required', value: true, message: 'Text 3 is required' },
        { type: 'custom', value: customValidation, message: 'Text 3 must contain "custom"' },
      ],
    },
    {
      type: 'email',
      name: 'email',
      label: 'Email',
      placeholder: 'Enter valid e-mail address',
    },
    {
      type: 'number',
      name: 'number',
      label: 'Number',
      placeholder: 'Enter some number',
      color: 'green',
      rules: [
        { type: 'required', value: true, message: 'Number is required' },
        { type: 'less-than', value: 10, message: 'Number must be at least 10' },
      ],
    },
    {
      type: 'password',
      name: 'password',
      label: 'Password',
      placeholder: 'Enter password, at least 12 characters',
      required: true,
    },
    {
      type: 'textarea',
      name: 'textarea',
      label: 'Textarea',
      placeholder: 'Enter some larger text here',
      rows: 3,
      counter: true,
      noResize: true,
    },
    {
      type: 'switch',
      name: 'acceptTerms',
      label: 'Accept Terms and Conditions',
      required: true,
      value: false,
    },
    {
      type: 'rating',
      name: 'rating',
      label: 'Rating',
      length: 6,
      //size:48,
      color: 'amber',
    },
    {
      type: 'checkbox',
      name: 'checkbox',
      label: 'Checkbox',
    },
    {
      type: 'select',
      name: 'select',
      label: 'Select',
      items: ['Alfa', 'Bravo', 'Charlie', 'Delta'],
      chips: true,
      multiple: true,
    },
    {
      type: 'combobox',
      name: 'combobox',
      label: 'Combo',
      items: ['Alfa', 'Bravo', 'Charlie', 'Delta'],
      chips: true,
      multiple: true,
    },
    {
      type: 'autocomplete',
      name: 'autocomplete',
      label: 'Autocomplete',
      items: ['Alfa', 'Bravo', 'Charlie', 'Delta'],
      chips: true,
      multiple: true,
    },
    {
      type: 'file',
      name: 'file',
      label: 'File!',
    },
    {
      type: 'date',
      name: 'date',
      label: 'Date',
      placeholder: 'Select date',
    },
    {
      type: 'time',
      name: 'time',
      label: 'Time',
      placeholder: 'Select time',
    },
    {
      type: 'datetime',
      name: 'datetime',
      label: 'Date and Time',
      placeholder: 'Select date and time',
      format: 'YYYY-MM-DD HH:MI',
    },
  ],
  cols: 3,
  variant: 'outlined',
  // density: 'compact',
  actions: ['validate', 'cancel', 'submit'],
  actions2: [
    { type: 'cancel' },
    {
      type: 'submit',
      icon: '$mdiCheck',
      color: 'success',
      variant: 'elevated',
      density: 'compact',
    },
  ],
  actionsAlign: 'right',
  actionsClass: 'ml-2',
  errors: [{ name: 'text1', message: 'Error from outside' }],
})

function submit(newData: unknown) {
  console.log('submit', newData)
}
function cancel(newData: unknown) {
  console.log('cancel', newData)
}
function validate(newData: unknown) {
  console.log('validate', newData)
}
</script>
