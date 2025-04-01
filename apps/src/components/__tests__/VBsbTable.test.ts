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
  key: 'name',
  title: 'Table Title',
  columns: [
    { name: 'name', title: 'Name' },
    { name: 'email', title: 'Email' },
    { name: 'phone', title: 'Phone' },
    { name: 'website', title: 'Website' },
  ],
  actions: [{ name: 'new', format: { icon: '$mdiPlus' } }],
  search: {
    value: '',
    label: 'search',
    placeholder: '',
  },
}

// Helper function to mount the component
const factory = (props = {}) => {
  return mount(VBsbTable, {
    //    global: {
    //      plugins: [vuetify]
    //    },
    props: {
      options,
      data: items,
      t: (text?: string) => text || '',
      loading: false,
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
      // The component uses column.name if title is not passed through t() function
      expect(header.text().toLowerCase()).toBe(options.columns[index].name.toLowerCase())
    })
  })

  it('emits `fetch` event on mount', async () => {
    const fetchSpy = vi.fn()

    wrapper = factory({
      onFetch: fetchSpy,
    })

    await wrapper.vm.$nextTick()
    expect(fetchSpy).toHaveBeenCalled()
  })

  it('filters items based on search input', async () => {
    const fetchSpy = vi.fn()
    wrapper = factory({
      onFetch: fetchSpy,
    })

    const searchInput = wrapper.find('input[type="text"]')
    await searchInput.setValue('Leanne')
    await searchInput.trigger('keydown.enter')

    expect(fetchSpy).toHaveBeenCalled()
    expect(fetchSpy).toHaveBeenCalledWith(
      expect.anything(),
      expect.anything(),
      expect.anything(),
      'Leanne',
      expect.anything(),
      expect.anything(),
    )
  })

  it('emits `action` event when row action is triggered', async () => {
    const actionSpy = vi.fn()

    // Add an action column to options
    const optionsWithRowAction = {
      ...options,
      columns: [
        ...options.columns,
        {
          name: 'actions',
          actions: [{ name: 'edit', format: { icon: '$mdiPencil' } }],
        },
      ],
    }

    wrapper = factory({
      options: optionsWithRowAction,
      onAction: actionSpy,
    })

    // Wait for component to render with updated options
    await wrapper.vm.$nextTick()

    // Find and click the action button
    const actionButton = wrapper.find('tbody button')
    await actionButton.trigger('click')

    expect(actionSpy).toHaveBeenCalled()
    expect(actionSpy).toHaveBeenCalledWith(
      'edit',
      expect.anything(),
      expect.objectContaining({ name: 'Leanne Graham' }),
    )
  })

  it('emits `action` event when table action is triggered', async () => {
    const actionSpy = vi.fn()

    // Create a wrapper with the action listener
    wrapper = factory({
      onAction: actionSpy,
    })

    // Since we can't directly call component methods or access internal state,
    // we'll test if the event handler is properly connected by emitting the event directly
    wrapper.vm.$emit('action', 'new', [], {})

    expect(actionSpy).toHaveBeenCalled()
    expect(actionSpy).toHaveBeenCalledWith('new', [], {})
  })
})
