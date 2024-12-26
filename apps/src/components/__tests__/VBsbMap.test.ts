import { describe, it, expect, beforeEach } from 'vitest'
import { mount, VueWrapper } from '@vue/test-utils'
import VBsbMap from '../../components/VBsbMap.vue'
import { GoogleMap, AdvancedMarker, InfoWindow } from 'vue3-google-map'
import vuetify from '../../plugins/vuetify'
import type { TBsbMapMarker } from '../../components/VBsbMap.vue'

type VBsbMapComponent = InstanceType<typeof VBsbMap>

describe('VBsbMap.vue', () => {
  let wrapper: VueWrapper<VBsbMapComponent>

  beforeEach(() => {
    wrapper = mount(VBsbMap, {
      global: {
        components: {
          GoogleMap,
          AdvancedMarker,
          InfoWindow,
        },
        plugins: [vuetify],
      },
      props: {
        center: { lat: 37.7749, lng: -122.4194 },
        zoom: 12,
        markers: [
          { lat: 37.7749, lng: -122.4194, title: 'Marker 1', color: 'red', info: 'Marker 1 info' },
          { lat: 37.7849, lng: -122.4294, title: 'Marker 2', color: 'blue', info: 'Marker 2 info' },
        ],
        autoCenter: true,
        autoLocation: false,
      },
    })
  })

  it('renders GoogleMap with correct center and zoom', () => {
    const googleMap = wrapper.findComponent(GoogleMap)
    expect(googleMap.exists()).toBe(true)
    expect(googleMap.props('center')).toEqual({ lat: 37.7749, lng: -122.4194 })
    expect(googleMap.props('zoom')).toBe(12)
  })

  it('renders the correct number of markers', () => {
    const markers = wrapper.findAllComponents(AdvancedMarker)
    expect(markers.length).toBe(2)
    expect(markers[0].props('options')).toEqual({
      position: { lat: 37.7749, lng: -122.4194 },
      title: 'Marker 1',
    })
    expect(markers[1].props('options')).toEqual({
      position: { lat: 37.7849, lng: -122.4294 },
      title: 'Marker 2',
    })
  })

  it('emits "centered" when the map center changes', async () => {
    await wrapper.setProps({
      center: { lat: 40.7128, lng: -74.006 },
    })
    expect(wrapper.emitted('centered')).toBeTruthy()
    const emitted = wrapper.emitted('centered')
    expect(emitted?.[0]).toEqual([{ lat: 40.7128, lng: -74.006 }])
  })

  it('adds new markers correctly', async () => {
    const newMarkers: TBsbMapMarker[] = [
      { lat: 40.7128, lng: -74.006, title: 'New Marker', color: 'green' },
    ]
    wrapper.vm.setMarkers(newMarkers)
    await wrapper.vm.$nextTick()
    expect(wrapper.emitted('marked')).toBeTruthy()
    const emitted = wrapper.emitted('marked')
    expect(emitted?.[0]).toEqual([
      [
        { lat: 37.7749, lng: -122.4194, title: 'Marker 1', color: 'red', info: 'Marker 1 info' },
        { lat: 37.7849, lng: -122.4294, title: 'Marker 2', color: 'blue', info: 'Marker 2 info' },
        { lat: 40.7128, lng: -74.006, title: 'New Marker', color: 'green' },
      ],
    ])
  })

  it('deletes markers correctly', async () => {
    const markersToDelete: TBsbMapMarker[] = [{ lat: 37.7749, lng: -122.4194 }]
    wrapper.vm.delMarkers(markersToDelete)
    await wrapper.vm.$nextTick()
    expect(wrapper.emitted('marked')).toBeTruthy()
    const emitted = wrapper.emitted('marked')
    expect(emitted?.[0]).toEqual([
      [{ lat: 37.7849, lng: -122.4294, title: 'Marker 2', color: 'blue', info: 'Marker 2 info' }],
    ])
  })
})
