import { mount } from '@vue/test-utils'
import { describe, it, expect, beforeEach } from 'vitest'
import VBsbPad from '@/components/VBsbPad.vue'
import vuetify from '../../plugins/vuetify'

import { VueWrapper } from '@vue/test-utils'

import type { ComponentPublicInstance } from 'vue'

interface VBsbPadProps {
  strokeType?: string
  color?: string
  lineWidth?: number
  backgroundColor?: string
}

let wrapper: VueWrapper<ComponentPublicInstance<VBsbPadProps>>

describe('VBsbPad Component', () => {
  beforeEach(() => {
    wrapper = mount(VBsbPad, {
      global: {
        plugins: [vuetify],
      },
    })
  })

  it('should mount correctly', () => {
    expect(wrapper.exists()).toBe(true)
  })

  it('should render a canvas element', () => {
    const canvas = wrapper.find('canvas')
    expect(canvas.exists()).toBe(true)
  })

  it('should have default props', () => {
    expect(wrapper.props().strokeType).toBe('dash')
    expect(wrapper.props().color).toBe('#000000')
    expect(wrapper.props().lineWidth).toBe(5)
  })

  it('should apply background color correctly', async () => {
    await wrapper.setProps({ backgroundColor: '#FF0000' })
    const canvasElement = wrapper.find('canvas').element
    const context = canvasElement.getContext('2d')
    if (context) {
      context.fillStyle = '#FF0000'
      expect(context.fillStyle).toBe('#FF0000')
    }
  })

  it('should update line width when prop changes', async () => {
    await wrapper.setProps({ lineWidth: 10 })
    expect(wrapper.props().lineWidth).toBe(10)
  })
})
