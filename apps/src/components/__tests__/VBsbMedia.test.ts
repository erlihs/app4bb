import { describe, it, expect, beforeEach } from 'vitest'
import { mount, VueWrapper } from '@vue/test-utils'
import vuetify from '../../plugins/vuetify'
import VBsbMedia from '../../components/VBsbMedia.vue'

describe('VBsbMedia.vue', () => {
  let wrapper: VueWrapper

  beforeEach(() => {
    wrapper = mount(VBsbMedia, {
      global: {
        components: {
          VBsbMedia,
        },
        plugins: [vuetify],
      },

      props: {
        video: true,
        audio: false,
        snap: true,
      },
    })
  })

  it('renders video element when video prop is true', () => {
    const video = wrapper.find('video')
    expect(video.exists()).toBe(true)
  })

  it('does not render audio element when audio prop is false', () => {
    const audio = wrapper.find('audio')
    expect(audio.exists()).toBe(false)
  })

  it('emits "loading" event on component mount', () => {
    expect(wrapper.emitted('loading')).toBeTruthy()
    expect(wrapper.emitted('loading')?.[0]).toEqual([true])
  })

  it('emits error if no video or audio is enabled', async () => {
    const wrapperWithoutMedia = mount(VBsbMedia, {
      global: {
        components: {
          VBsbMedia,
        },
        plugins: [vuetify],
      },
      props: { video: false, audio: false },
    })

    await wrapperWithoutMedia.vm.$nextTick()

    expect(wrapperWithoutMedia.emitted('error')).toBeTruthy()
    const error = wrapperWithoutMedia.emitted('error')?.[0]?.[0]
    expect((error as Error).message).toBe('At least one of video or audio props must be true')
  })
})
