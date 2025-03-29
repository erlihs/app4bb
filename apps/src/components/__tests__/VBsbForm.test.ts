// tests/VBsbForm.spec.ts
import { mount, VueWrapper } from '@vue/test-utils'
import { describe, expect, it, beforeEach } from 'vitest'
import VBsbForm from '../VBsbForm.vue'
import vuetify from '../../plugins/vuetify'
import type { BsbFormOptions } from '../index' // Import the required types

describe('VBsbForm', () => {
  let wrapper: VueWrapper
  const options: BsbFormOptions = {
    fields: [
      {
        name: 'username',
        type: 'text' as const,
        label: 'Username',
        value: '',

        errors: [],
      },
      {
        name: 'checkbox',
        type: 'checkbox' as const,
        label: 'Checkbox',
        value: false,

        errors: [],
      },
      {
        name: 'password',
        type: 'password' as const,
        label: 'Password',
        value: '',

        errors: [],
      },
    ],
    actions: ['submit', 'cancel'],
    actionSubmit: 'submit',
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

    const checkboxField = wrapper.findComponent({ name: 'VCheckbox' })
    expect(checkboxField.props('label')).toBe('Checkbox')
  })

  it('renders action buttons correctly', () => {
    const buttons = wrapper.findAllComponents({ name: 'VBtn' })
    expect(buttons).toHaveLength(2)
    expect(buttons[0].html()).toContain('submit')
    expect(buttons[1].html()).toContain('cancel')
  })
})
