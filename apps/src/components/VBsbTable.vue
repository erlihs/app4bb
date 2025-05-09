<template>
  <v-defaults-provider :defaults>
    <v-container>
      <v-row>
        <v-col>
          <v-table>
            <thead>
              <tr v-if="!mobile">
                <th v-for="column in columns" :key="column.name" :class="column.class">
                  {{ column.title }}
                </th>
              </tr>

              <tr v-if="options.filter || options.sort">
                <td :colspan="colspan - 1">
                  <v-chip
                    v-for="chip in filterChips"
                    :key="`${chip.name}-${chip.value}`"
                    :prepend-icon="chip.icon"
                    class="ma-1"
                    color="primary"
                    closable
                    rounded
                    start
                    @click:close="handleFilterRemove(chip.name, chip.value)"
                  >
                    <strong>{{ chip.value }}</strong
                    >&nbsp;({{ chip.label }})
                  </v-chip>

                  <v-chip
                    v-for="sort in sortChips"
                    :key="sort.name"
                    :prepend-icon="sort.icon"
                    class="ma-1"
                    color="secondary"
                    closable
                    rounded
                    @click="handleSortUpdate(sort.name, sort.value == 'asc' ? 'desc' : 'asc')"
                    @click:close="handleSortUpdate(sort.name, 'close')"
                  >
                    <strong>{{ sort.label }}</strong>
                  </v-chip>
                </td>
                <td class="w-0 text-no-wrap text-right">
                  <v-btn
                    v-if="options.filter"
                    v-bind="bsbActionFormat(undefined, 'filter', options.actionFormat)"
                    icon="$mdiFilterPlus"
                    color="primary"
                    @click="handleFilterShow()"
                  />

                  <v-menu location="start" v-if="options.sort">
                    <template v-slot:activator="{ props }">
                      <v-btn
                        v-bind="{
                          ...props,
                          ...bsbActionFormat(undefined, 'sort', options.actionFormat),
                        }"
                        icon="$mdiSort"
                        color="secondary"
                      />
                    </template>
                    <v-list open-strategy="single">
                      <v-list-group v-for="sort in sortItems" :key="sort.name">
                        <template v-slot:activator="{ props }">
                          <v-list-item v-bind="props" :title="sort.label"></v-list-item>
                        </template>
                        <v-list-item
                          v-for="action in sort.actions"
                          :key="action.name"
                          :prepend-icon="action.icon"
                          :title="action.label"
                          :disabled="action.disabled"
                          @click="handleSortUpdate(sort.name, action.name)"
                        ></v-list-item>
                      </v-list-group>
                    </v-list>
                  </v-menu>
                </td>
              </tr>

              <tr v-if="options.search">
                <td :colspan>
                  <v-text-field
                    v-model="searchValue"
                    clearable
                    hide-details="auto"
                    :label="t(options.search.label || 'search')"
                    :placeholder="t(options.search.placeholder || '')"
                    append-icon="$mdiMagnify"
                    @keydown.enter.prevent="fetch(1)"
                    @click:clear="fetch(1)"
                    @click:append="fetch(1)"
                  ></v-text-field>
                </td>
              </tr>
              <tr v-if="mobile">
                <td colspan="2" class="border-t-xl border-secondary h-0"></td>
              </tr>
            </thead>

            <tbody v-if="!mobile">
              <tr v-for="item in page" :key="String(item[options.key])">
                <td v-for="column in columns" :key="column.name" :class="column.class">
                  <component :is="renderTableCell(item, column.name)" />
                </td>
              </tr>
              <tr v-for="n in emptyRowsCount" :key="n">
                <td v-for="column in columns" :key="column.name" />
              </tr>
            </tbody>
            <tbody v-else v-for="item in page" :key="String(item[options.key])">
              <tr v-for="column in columns" :key="column.name">
                <th class="w-0">{{ column.title }}</th>
                <td :class="column.class">
                  <component :is="renderTableCell(item, column.name)" />
                </td>
              </tr>
              <tr>
                <td colspan="2" class="border-t-xl border-secondary h-0"></td>
              </tr>
            </tbody>

            <tfoot>
              <tr>
                <td class="text-center" :colspan="colspan - 1">
                  <v-btn
                    icon="$mdiChevronLeft"
                    :disabled="!hasPrevPage"
                    @click="fetch(currentPage - 1)"
                  />
                  <v-btn
                    icon="$mdiChevronRight"
                    :disabled="!hasNextPage"
                    @click="fetch(currentPage + 1)"
                  />
                </td>
                <td class="text-right w-0 text-no-wrap">
                  <v-btn v-if="canRefresh" icon="$mdiRefresh" @click="fetch()" />
                  <v-btn
                    v-for="action in actions"
                    :key="action.name"
                    v-bind="action.props"
                    @click="handleTableAction(action.name)"
                  />
                </td>
              </tr>
            </tfoot>
          </v-table>
        </v-col>
      </v-row>

      <v-dialog v-model="form" :width="mobile ? '100%' : '75%'">
        <v-card>
          <v-card-title>{{ formTitle }}</v-card-title>
          <v-card-text>
            <v-bsb-form
              :options="formOptions"
              :data="formData"
              :t
              :loading
              @action="handleFormAction"
              @submit="handleFormSubmit"
              @cancel="form = false"
            />
          </v-card-text>
        </v-card>
      </v-dialog>

      <v-overlay :model-value="loading" persistent contained class="align-center justify-center">
        <v-progress-circular indeterminate />
      </v-overlay>
    </v-container>
  </v-defaults-provider>
</template>

<script setup lang="ts">
import { type BsbTableOptions, type BsbTableData, bsbFormat, bsbActionFormat } from './index'

const { defaults } = useDefaults({
  name: 'VBsbForm',
  defaults: {
    VContainer: {
      class: 'position-relative',
    },
    VOverlay: {
      class: 'rounded',
    },
    VTable: {
      hover: true,
      class: 'border rounded',
      VTextField: {
        density: 'compact',
      },
      VChip: {
        variant: 'text',
      },
      VBtn: {
        size: 'small',
        variant: 'tonal',
        class: 'ma-1',
      },
    },
  },
})

const {
  options,
  data = [],
  t = (text?: string) => text || '',
  loading = false,
} = defineProps<{
  options: BsbTableOptions
  data?: BsbTableData[]
  t?: (text?: string) => string
  loading?: boolean
}>()

const emits = defineEmits<{
  (event: 'action', name: string, data: unknown, value?: unknown): void
  (
    event: 'fetch',
    data: Ref<BsbTableData[]>,
    offset: number,
    limit: number,
    search?: string,
    filter?: string,
    sort?: string,
  ): void
}>()

const { mobile } = useDisplay()

const localData = ref(data)
const page = computed(() => localData.value.slice(0, itemsPerPage.value))
const currentPage = ref(options.currentPage || 1)
const itemsPerPage = ref(options.itemsPerPage || 10)
const hasNextPage = computed(() => localData.value.length > itemsPerPage.value)
const hasPrevPage = computed(() => currentPage.value > 1)
const canRefresh = computed(() => options.canRefresh ?? true)
const emptyRowsCount = computed(() =>
  page.value.length < itemsPerPage.value ? itemsPerPage.value - page.value.length : 0,
)

const columns = computed(() => {
  return options.columns.map((column) => {
    const { name, title } = column
    return {
      name,
      title: t(title || name),
      align: column.align || options.align ? `text-${column.align || options.align}` : '',
      class: [
        column.align || options.align ? `text-${column.align || options.align}` : '',
        column.actions ? `text-no-wrap` : '',
        column.actions ? `w-0` : '',
      ],
    }
  })
})

const actions = computed(() => {
  return (options.actions || []).map((action) => {
    const props = bsbActionFormat(undefined, action, options.actionFormat)
    props.text = props.text ? t(String(props.text)) : undefined
    return {
      name: props.name as string,
      props,
    }
  })
})

import { VIcon, VChip, VBtn } from 'vuetify/components'
function renderTableCell(item: Record<string, unknown>, columnName: string) {
  const column = options.columns.find((column) => column.name == columnName)
  if (!column) return
  return () => {
    const rawValue = item[column.name] ? String(item[column.name]) : ''

    const maxLen = column.maxLength == 0 ? 0 : column.maxLength || options.maxLength || 32767
    const value = rawValue.slice(0, maxLen)
    const isTrimmed = column.maxLength == 0 || rawValue.length > value.length

    const children = []

    if (column.format) {
      const chipProps = bsbFormat(item[column.name], column.format)
      const hasIcon = chipProps.icon as string | undefined
      const slots: Record<string, () => unknown> = {}

      if (chipProps.to && typeof chipProps.to === 'string') {
        chipProps.to = chipProps.to.replace('${value}', String(rawValue))
      }

      if (hasIcon) {
        slots.prepend = () =>
          h(VIcon, {
            icon: hasIcon,
            start: true,
          })
      }
      slots.default = () => (chipProps.icon ? '' : value)
      children.push(h(VChip, chipProps, slots))
    } else {
      if (value) children.push(h('span', {}, value as string))
    }
    if (isTrimmed) {
      children.push(
        h(VBtn, {
          icon: '$mdiDotsHorizontal',
          onClick: () => {
            formOptions.value = {
              fields: [{ type: 'textarea', name: column.name, value: String(item[column.name]) }],
              actions: ['ok'],
              actionCancel: 'ok',
            }
            formData.value = {}
            formTitle.value = t('details')
            formIsFilter.value = false
            form.value = true
          },
        }),
      )
    }

    column.actions?.forEach((action) => {
      if (typeof action === 'string') action = { name: action }
      const value = action.key ? item[action.key] : undefined
      const props = bsbActionFormat(value, action, options.actionFormat)
      children.push(
        h(VBtn, {
          ...props,
          onClick: () => handleRowAction(column.name, action.name, item[options.key]),
        }),
      )
    })

    return h('span', {}, children)
  }
}

// search

const searchValue = ref(options.search?.value || '')
const colspan = computed(() => (mobile.value ? 2 : options.columns.length))

//filter

const filter = ref(options.filter?.fields || [])

const filterChips = computed(() => {
  if (!options.filter) return []

  return filter.value.flatMap((field) => {
    const baseChip = {
      name: field.name,
      label: t(field.label || field.name),
      icon: '$mdiFilter',
      color: 'primary',
    }

    if (Array.isArray(field.value)) {
      return field.value
        .filter((value) => value !== undefined)
        .map((value) => ({ ...baseChip, value }))
    }

    return field.value !== undefined ? [{ ...baseChip, value: field.value }] : []
  })
})

const filterValue = computed(() => {
  if (!options.filter) return ''

  return filter.value
    .filter((field) => field.value !== undefined)
    .reduce((result, field) => {
      const values = Array.isArray(field.value)
        ? field.value.filter((v) => v !== undefined)
        : [field.value]

      if (values.length > 0) {
        result.push(`${field.name}[${values.join(',')}]`)
      }

      return result
    }, [] as string[])
    .join(',')
})

async function handleFilterRemove(filterName: string, filterValue?: unknown) {
  if (!options.filter) return

  const filterField = options.filter.fields.find((filter) => filter.name === filterName)
  if (!filterField) return

  if (Array.isArray(filterField.value)) {
    const index = filterField.value.indexOf(filterValue)
    if (index >= 0) {
      filterField.value =
        filterField.value.length === 1 ? undefined : filterField.value.filter((_, i) => i !== index)
    }
  } else {
    filterField.value = undefined
  }

  await fetch(1)
}

function handleFilterShow() {
  if (!options.filter) return
  formOptions.value = options.filter

  if (!formOptions.value.actionSubmit) {
    formOptions.value.actions?.push({ name: 'apply' })
    formOptions.value.actionSubmit = 'apply'
  }

  if (!formOptions.value.actionCancel) {
    formOptions.value.actions?.push({ name: 'cancel' })
    formOptions.value.actionCancel = 'cancel'
  }

  formData.value = options.filter.fields.reduce((acc, field) => {
    acc[field.name] = field.value
    return acc
  }, {} as BsbFormData)
  formTitle.value = t('filter')
  formIsFilter.value = true
  form.value = true
}

// sort

const sort = ref(options.sort || [])

const sortChips = computed(() => {
  if (!options.sort) return []
  return sort.value
    .filter((sort) => sort.value)
    .map((sort) => {
      return {
        name: sort.name,
        label: t(sort.label || sort.name),
        value: sort.value,
        sort: sort.value == 'desc' ? `-${sort.name}` : sort.name,
        icon: sort.value == 'desc' ? '$mdiSortDescending' : '$mdiSortAscending',
      }
    })
})

const sortItems = computed(() => {
  if (!options.sort) return []
  return sort.value.map((sort) => {
    return {
      name: sort.name,
      label: t(sort.label || sort.name),
      actions: [
        {
          name: 'asc',
          label: t('ascending'),
          icon: '$mdiSortAscending',
          disabled: sort.value == 'asc',
        },
        {
          name: 'desc',
          label: t('descending'),
          icon: '$mdiSortDescending',
          disabled: sort.value == 'desc',
        },
        {
          name: 'left',
          label: t('left'),
          icon: '$mdiChevronLeft',
          disabled:
            !['asc', 'desc'].includes(String(sort.value)) ||
            sortChips.value.findIndex((chip) => chip.name === sort.name) == 0,
        },
        {
          name: 'right',
          label: t('right'),
          icon: '$mdiChevronRight',
          disabled:
            !['asc', 'desc'].includes(String(sort.value)) ||
            sortChips.value.findIndex((chip) => chip.name === sort.name) ==
              sortChips.value.length - 1,
        },
        {
          name: 'close',
          label: t('close'),
          icon: '$mdiClose',
          disabled: !sort.value,
        },
      ],
    }
  })
})

const sortValue = computed(() => {
  if (!sort.value) return ''
  return sortChips.value.map((sort) => sort.sort).join(',')
})

async function handleSortUpdate(sortName: string, sortAction: string) {
  if (!options.sort) return
  const foundSort = sort.value.find((sort) => sort.name === sortName)
  if (foundSort) {
    if (sortAction == 'asc') foundSort.value = sortAction
    if (sortAction == 'desc') foundSort.value = sortAction
    if (sortAction == 'close') foundSort.value = undefined
    if (sortAction == 'left') {
      const index = sort.value.findIndex((sort) => sort.name === sortName)
      if (index > 0) {
        const temp = sort.value[index]
        sort.value[index] = sort.value[index - 1]
        sort.value[index - 1] = temp
      }
    }
    if (sortAction == 'right') {
      const index = sort.value.findIndex((sort) => sort.name === sortName)
      if (index < sort.value.length - 1) {
        const temp = sort.value[index]
        sort.value[index] = sort.value[index + 1]
        sort.value[index + 1] = temp
      }
    }
    await fetch()
  }
}

// form

const form = ref(false)
const formTitle = ref('')
const formOptions = ref<BsbFormOptions>({ fields: [] })
const formData = ref<BsbTableData>({})
const formIsFilter = ref(false)
const formActionName = ref('')
const formRowIndex = ref(-1)

// actions

async function handleFormAction(actionName: string, actionData: BsbFormData) {
  await emits('action', actionName, localData, actionData)
}

async function handleFormSubmit(actionData: BsbFormData) {
  if (formIsFilter.value) {
    Object.entries(actionData).forEach(([fieldName, value]) => {
      if (value === undefined) return
      const filterField = options.filter?.fields.find((filter) => filter.name === fieldName)
      if (filterField) filterField.value = value
    })
    await fetch(1)
    form.value = false
    return
  }

  await emits('action', formActionName.value, localData, actionData)
  localData.value[formRowIndex.value] = actionData
  form.value = false
}

async function handleRowAction(columnName: string, actionName: string, keyValue?: unknown) {
  const column = options.columns.find((column) =>
    typeof column === 'string' ? column === columnName : column.name == columnName,
  )
  if (!column || !column.actions) return
  const action = column.actions.find((action) =>
    typeof action === 'string' ? action === actionName : action.name === actionName,
  )
  if (!action) return

  const rowIndex = localData.value.findIndex((item) => item[options.key] == keyValue)

  if (typeof action !== 'string' && action.form) {
    formOptions.value = action.form
    formData.value = localData.value[rowIndex]
    formTitle.value = t(action.name)
    formIsFilter.value = false
    formActionName.value = action.name
    formRowIndex.value = rowIndex
    form.value = true
    return
  }

  await emits('action', actionName, localData, localData.value[rowIndex])
}

async function handleTableAction(actionName: string) {
  const action = options.actions?.find(
    (action) => typeof action !== 'string' && action.name == actionName,
  )
  if (!action) return
  if (action && typeof action !== 'string' && action.form) {
    formOptions.value = action.form
    formData.value = {}
    const fmt = bsbActionFormat(undefined, action, options.actionFormat)
    formTitle.value = t(fmt.text || action.name)
    formIsFilter.value = false
    formRowIndex.value = -1
    formActionName.value = action.name
    form.value = true
  } else await emits('action', actionName, localData, formData.value)
}

async function fetch(newPage?: number) {
  if (newPage) currentPage.value = newPage
  await emits(
    'fetch',
    localData,
    (currentPage.value - 1) * itemsPerPage.value,
    itemsPerPage.value + 1,
    searchValue.value,
    filterValue.value,
    sortValue.value,
  )
}

defineExpose({
  fetch,
})

onMounted(async () => {
  fetch()
})
</script>
<style scoped>
th {
  font-weight: 800 !important;
}
</style>
