import { describe, it, expect, beforeEach } from 'vitest'
import { mount, VueWrapper } from '@vue/test-utils'
import VBsbEditor from '../../components/VBsbEditor.vue'

describe('VBsbEditor.vue', () => {
  let wrapper: VueWrapper

  beforeEach(() => {
    wrapper = mount(VBsbEditor, {
      props: {
        toolbar: ['bold', 'italic', 'underline'],
        toolbarClass: 'test-toolbar-class',
      },
    })
  })
  it('renders the toolbar buttons based on the "toolbar" prop', () => {
    const buttons = wrapper.findAllComponents({ name: 'v-btn' })
    expect(buttons.length).toBe(3) // bold, italic, underline
  })

  it('applies the toolbarClass to the toolbar container', () => {
    const toolbarDiv = wrapper.find('.editor-toolbar')
    expect(toolbarDiv.classes()).toContain('test-toolbar-class')
  })
})
