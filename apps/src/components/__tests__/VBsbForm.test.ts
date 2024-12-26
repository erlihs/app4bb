// tests/VBsbForm.spec.ts
import { mount, VueWrapper } from '@vue/test-utils'
import { describe, expect, it, beforeEach } from 'vitest'
import VBsbForm from '../VBsbForm.vue'
import vuetify from '../../plugins/vuetify'

describe('VBsbForm', () => {
  let wrapper: VueWrapper

  const options = {
    fields: [
      {
        name: 'username',
        type: 'text' as const,
        label: 'Username',
        value: '',
        required: true,
        errors: [],
      },
      {
        name: 'checkbox',
        type: 'checkbox' as const,
        label: 'Checkbox',
        value: false,
        required: true,
        errors: [],
      },
      {
        name: 'password',
        type: 'password' as const,
        label: 'Password',
        value: '',
        required: true,
        errors: [],
      },
    ],
    actions: [
      { type: 'submit' as const, title: 'Submit', color: 'success' },
      { type: 'cancel' as const, title: 'Cancel', color: 'error', variant: 'outlined' as const },
    ],
    errors: [],
  }

  const data = {
    username: '',
    email: '',
    password: '',
  }

  beforeEach(() => {
    wrapper = mount(VBsbForm, {
      props: {
        data,
        options,
      },
      global: {
        plugins: [vuetify],
      },
    })
  })

  it('renders form fields correctly', () => {
    const textFields = wrapper.findAllComponents({ name: 'VTextField' })
    expect(textFields).toHaveLength(2)
    expect(textFields[0].props('label')).toBe('Username')
    expect(textFields[1].props('label')).toBe('Password')

    const passwordField = wrapper.findComponent({ name: 'VCheckbox' })
    expect(passwordField.props('label')).toBe('Checkbox')
  })

  it('renders action buttons correctly', () => {
    const buttons = wrapper.findAllComponents({ name: 'VBtn' })
    expect(buttons).toHaveLength(2) // Submit, Cancel
    expect(buttons[0].text()).toBe('Submit')
    expect(buttons[1].text()).toBe('Cancel')
  })
})
