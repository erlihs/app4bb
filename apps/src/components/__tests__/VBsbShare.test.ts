import { mount, VueWrapper } from '@vue/test-utils'
import { describe, it, expect, beforeEach, vi } from 'vitest'
import VBsbShare from '../VBsbShare.vue'
import vuetify from '../../plugins/vuetify'

vi.mock('navigator.clipboard', () => ({
  writeText: vi.fn(() => Promise.resolve()),
}))

describe('VBsbShare.vue', () => {
  let wrapper: VueWrapper

  beforeEach(() => {
    wrapper = mount(VBsbShare, {
      global: {
        plugins: [vuetify],
      },
      props: {
        share: ['twitter', 'facebook', 'linkedin', 'whatsapp', 'copy'],
        windowFeatures: { width: 600, height: 400, top: 100, left: 100 },
        shareOptions: { text: 'Share this text', url: 'http://example.com', number: '123' },
        useNativeBehavior: false,
        variant: 'flat',
        density: 'default',
        color: 'primary',
      },
    })
  })

  it('renders the correct number of share buttons', () => {
    const buttons = wrapper.findAll('button')
    expect(buttons.length).toBe(5)
  })

  it('renders the Twitter share button', () => {
    const twitterBtn = wrapper.find('button[data-cy="v-bsb-share-twitter"]')
    expect(twitterBtn.exists()).toBe(true)
  })

  it('renders the Facebook share button', () => {
    const facebookBtn = wrapper.find('button[data-cy="v-bsb-share-facebook"]')
    expect(facebookBtn.exists()).toBe(true)
  })

  it('renders the LinkedIn share button', () => {
    const linkedInBtn = wrapper.find('button[data-cy="v-bsb-share-linkedin"]')
    expect(linkedInBtn.exists()).toBe(true)
  })

  it('renders the WhatsApp share button', () => {
    const whatsappBtn = wrapper.find('button[data-cy="v-bsb-share-whatsapp"]')
    expect(whatsappBtn.exists()).toBe(true)
  })

  it('renders the Copy button', () => {
    const copyBtn = wrapper.find('button[data-cy="v-bsb-share-copy"]')
    expect(copyBtn.exists()).toBe(true)
  })

  it('does not render social buttons when they are not in the share prop', async () => {
    await wrapper.setProps({ share: ['copy'] })

    const twitterBtn = wrapper.find('button[data-cy="v-bsb-share-twitter"]')
    const copyBtn = wrapper.find('button[data-cy="v-bsb-share-copy"]')

    expect(twitterBtn.exists()).toBe(false)
    expect(copyBtn.exists()).toBe(true)
  })
})
