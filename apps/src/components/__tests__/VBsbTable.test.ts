import { mount } from '@vue/test-utils'
import { describe, it, expect, beforeEach, vi } from 'vitest'
import VBsbTable from '@/components/VBsbTable.vue'
//import vuetify from '../../plugins/vuetify'

// Mock Data and Options
const items = [
  { name: 'Leanne Graham', email: 'leanne@example.com', phone: '123', website: 'example.com' },
  { name: 'Ervin Howell', email: 'ervin@example.com', phone: '456', website: 'example.com' },
  // Add more items as needed
]

const options = {
  title: 'Table Title',
  columns: [
    { column: 'name', title: 'Name' },
    { column: 'email', title: 'Email' },
    { column: 'phone', title: 'Phone' },
    { column: 'website', title: 'Website' },
  ],
  actions: [{ action: 'new', format: { icon: '$mdiPlus' } }],
}

// Helper function to mount the component
const factory = (props = {}) => {
  return mount(VBsbTable, {
    //    global: {
    //      plugins: [vuetify]
    //    },
    props: {
      items,
      options,
      searchable: true,
      refreshable: true,
      ...props,
    },
  })
}

describe('VBsbTable Component', () => {
  let wrapper: ReturnType<typeof factory>

  beforeEach(() => {
    window.innerWidth = 2048
    window.dispatchEvent(new Event('resize'))
    wrapper = factory()
  })

  it('displays the correct number of items', () => {
    const rows = wrapper.findAll('tbody tr')
    expect(rows.length).toBeGreaterThanOrEqual(items.length)
  })

  it('renders table headers according to columns', () => {
    const headers = wrapper.findAll('thead th')
    expect(headers.length).toBe(options.columns.length)
    headers.forEach((header, index) => {
      expect(header.text()).toBe(options.columns[index].title)
    })
  })

  it('emits `beforeFetch` and `afterFetch` events on fetch', async () => {
    const beforeFetch = vi.fn()
    const afterFetch = vi.fn()

    wrapper = factory({
      onBeforeFetch: beforeFetch,
      onAfterFetch: afterFetch,
    })

    await wrapper.vm.fetch(1) // Manually trigger fetch

    expect(beforeFetch).toHaveBeenCalled()
    expect(afterFetch).toHaveBeenCalled()
  })

  it('filters items based on search input', async () => {
    const searchInput = wrapper.find('input[type="text"]')
    await searchInput.setValue('Leanne')
    await wrapper.vm.$nextTick()

    const rows = wrapper.findAll('tbody tr')
    expect(rows.length).toBeGreaterThan(1)
    expect(rows[0].text()).toContain('Leanne Graham')
  })

  it('emits `submit` event when form is submitted', async () => {
    const submitSpy = vi.fn()
    wrapper = factory({
      onSubmit: submitSpy,
    })

    // Assume `showForm` is triggered and we submit a form
    if (wrapper.vm.onSubmit) {
      await wrapper.vm.onSubmit({ name: 'Test', email: 'test@example.com' })
    }
    expect(submitSpy).toHaveBeenCalledWith({ name: 'Test', email: 'test@example.com' })
  })
})
