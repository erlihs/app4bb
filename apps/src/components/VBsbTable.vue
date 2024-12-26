<template>
  <v-text-field
    v-show="props.searchable && showTable"
    v-model="search"
    clearable
    hide-details="auto"
    :label="t(props.searchLabel)"
    :placeholder="props.searchPlaceholder ? t(props.searchPlaceholder) : ''"
    append-icon="$mdiMagnify"
    @keydown.enter.prevent="fetch(1)"
    @click:clear="fetch(1)"
    @click:append="fetch(1)"
  ></v-text-field>
  <v-defaults-provider
    :defaults="{
      VBtn: {
        color: props.actionFormat.color,
        variant: props.actionFormat.variant,
        density: props.actionFormat.density,
        size: props.actionFormat.size,
        class: props.actionFormat.class,
      },
    }"
  >
    <v-sheet v-if="mobile" color="transparent">
      <v-table v-if="currentItems.length == 0">
        <tbody>
          <tr>
            <td>{{ t('No data') }}</td>
          </tr>
        </tbody>
      </v-table>
      <v-table v-for="item in currentItems" :key="String(item[0])">
        <tbody>
          <tr v-for="column in columns" :key="column.column">
            <th class="th-width-auto">{{ column.title }}</th>
            <td :class="column.actions ? 'text-right' : ''">
              <v-bsb-table-cell :column :item :shorten="props.shorten" @action="onAction" />
            </td>
          </tr>
        </tbody>
      </v-table>
    </v-sheet>
    <v-sheet v-else color="transparent">
      <v-table>
        <thead>
          <tr>
            <th v-for="column in columns" :key="column.column">{{ column.title }}</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in currentItems" :key="String(item[0])">
            <td
              v-for="column in columns"
              :key="column.column"
              :class="column.actions ? 'td-width-auto text-right' : ''"
            >
              <v-bsb-table-cell :column :item :shorten="props.shorten" @action="onAction" />
            </td>
          </tr>
          <tr v-for="item in dummyItems" :key="String(item[0])">
            <td v-for="column in columns" :key="column.column"></td>
          </tr>
        </tbody>
      </v-table>
    </v-sheet>
  </v-defaults-provider>
  <v-defaults-provider
    :defaults="{
      VBtn: {
        color: props.navigationFormat.color,
        variant: props.navigationFormat.variant,
        density: props.navigationFormat.density,
        size: props.navigationFormat.size,
        class: props.navigationFormat.class,
      },
    }"
  >
    <v-table class="transparent">
      <tfoot>
        <tr>
          <td class="text-center">
            <v-btn
              :disabled="!hasPrevPage"
              icon="$mdiChevronLeft"
              @click="fetch(currentPage - 1)"
            ></v-btn>
            <v-btn
              :disabled="!hasNextPage"
              icon="$mdiChevronRight"
              @click="fetch(currentPage + 1)"
            ></v-btn>
          </td>
          <td v-if="props.refreshable" class="td-width-auto">
            <v-btn icon="$mdiRefresh" @click="fetch()"></v-btn>
          </td>
          <td class="text-right td-width-auto">
            <v-btn
              data-cy="action"
              v-for="action in actions"
              :key="action.action"
              :text="action.format?.text ? t(action.format?.text) : ''"
              :icon="action.format?.icon"
              :color="action.format?.color"
              :variant="action.format?.variant"
              :density="action.format?.density"
              :size="action.format?.size"
              @click="onAction(action, {})"
            ></v-btn>
          </td>
        </tr>
      </tfoot>
    </v-table>
  </v-defaults-provider>
  <v-dialog activator="parent" v-if="showForm">
    <v-sheet class="pa-4">
      <v-bsb-form :data="formData" :options="formOptions" @cancel="onCancel" @submit="onSubmit" />
    </v-sheet>
  </v-dialog>
  <v-overlay v-model="loading" contained persistent />
</template>

<script setup lang="ts">
import type { BsbFormOptions } from './VBsbForm.vue'
import VBsbTableCell from './VBsbTableCell.vue'

const { t } = useI18n()

export type BsbTableItem = Record<string, unknown>

export type BsbTableFormat = {
  condition?:
    | 'required'
    | 'min-length'
    | 'max-length'
    | 'equals'
    | 'equals-not'
    | 'starts-with'
    | 'ends-with'
    | 'greater-than'
    | 'less-than'
    | 'in-range'
    | 'set'
    | 'password'
    | 'email'
    | 'url'
    | 'ip'
    | 'regexp'
    | 'same-as'
    | 'is-json'
    | 'custom'
  params?: unknown
  text?: string
  icon?: string
  color?: string
  variant?: 'flat' | 'outlined' | 'plain' | 'text' | 'elevated' | 'tonal'
  density?: 'compact' | 'default' | 'comfortable'
  size?: 'x-small' | 'small' | 'default' | 'large' | 'x-large'
  class?: string
  to?: string
  target?: string
}

export type BsbTableAction = {
  action: string
  format?: BsbTableFormat
  form?: BsbFormOptions
}

export type BsbTableColumn = {
  primary?: boolean
  column: string
  title?: string
  actions?: BsbTableAction[]
  format?: BsbTableFormat[] | BsbTableFormat
  shorten?: number
}

export type BsbTableOptions = {
  title?: string
  columns: BsbTableColumn[]
  actions?: BsbTableAction[]
}

const props = defineProps({
  title: {
    type: String,
    default: '',
  },
  searchable: {
    type: Boolean,
    default: false,
  },
  searchLabel: {
    type: String,
    default: 'Search',
  },
  searchPlaceholder: {
    type: String,
    default: '',
  },
  refreshable: {
    type: Boolean,
    default: true,
  },
  items: {
    type: Array as PropType<BsbTableItem[]>,
    required: false,
  },
  itemsPerPage: {
    type: Number,
    default: 10,
  },
  currentPage: {
    type: Number,
    default: 1,
  },
  options: {
    type: Object as PropType<BsbTableOptions>,
    default: () => ({}),
  },
  shorten: Number,
  navigationFormat: {
    type: Object as PropType<BsbTableFormat>,
    default: () => ({
      color: 'primary',
      variant: 'outlined',
      density: 'default',
      size: 'default',
      class: 'mt-2 ml-2',
    }),
  },
  actionFormat: {
    type: Object as PropType<BsbTableFormat>,
    default: () => ({
      color: 'primary',
      variant: 'outlined',
      density: 'default',
      size: 'default',
      class: 'mt-2 mb-2 ml-2',
    }),
  },
  api: {
    type: String,
    default: '',
  },
})

const emits = defineEmits(['action', 'beforeFetch', 'afterFetch', 'submit'])

const http = props.api ? useHttp({ baseURL: props.api }) : undefined

const search = ref('')

const { mobile } = useDisplay()
const showTable = ref(true)
const loading = ref(false)

const currentItems = ref<BsbTableItem[]>([])
const itemsPerPage = ref(props.itemsPerPage)
const currentPage = ref(props.currentPage)
const hasPrevPage = computed(() => currentPage.value > 1)
const hasNextPage = ref(false)
const dummyItems = ref<BsbTableItem[]>([])

const columns = props.options.columns
const actions = props.options.actions || []

const showForm = ref(false)
const formData = ref<Record<string, unknown>>({})
const formOptions = ref<BsbFormOptions>({
  fields: [],
  errors: [],
})

async function onAction(action: BsbTableAction, item: BsbTableItem) {
  emits('action', { action: action.action, item })
  if (action.form) {
    formData.value = item
    formOptions.value = action.form
    showForm.value = true
  }
}

async function onCancel() {
  showForm.value = false
}

async function onSubmit(data: Record<string, unknown>) {
  emits('submit', data)
  const primaryKey = columns.find((column) => column.primary)?.column
  if (primaryKey) {
    const index = currentItems.value.findIndex(
      (item) => item[primaryKey] === formData.value[primaryKey],
    )
    if (index !== -1) currentItems.value[index] = { ...currentItems.value[index], ...data }
  }
  showForm.value = false
}

async function fetch(newPage?: number) {
  loading.value = true
  emits('beforeFetch', {
    items: currentItems.value,
    itemsPerPage: itemsPerPage.value,
    currentPage: currentPage.value,
    newPage: newPage,
    search: search.value,
  })
  if (newPage) currentPage.value = newPage
  let newItems = props.items || []
  if (http) {
    const { data } = await http.get('', {
      search: search.value,
      offset: itemsPerPage.value * (currentPage.value - 1),
      limit: itemsPerPage.value + 1,
    })
    newItems = (data as { items: BsbTableItem[] })?.items
    hasNextPage.value = newItems.length > itemsPerPage.value
    currentItems.value = newItems.slice(0, itemsPerPage.value)
  } else {
    if (search.value)
      newItems = newItems.filter((item: BsbTableItem) => {
        return Object.values(item).some((value: unknown) => {
          return String(value).toLowerCase().includes(search.value.toLowerCase())
        })
      })
    hasNextPage.value = currentPage.value < newItems.length / itemsPerPage.value
    currentItems.value = newItems.slice(
      itemsPerPage.value * (currentPage.value - 1),
      itemsPerPage.value * (currentPage.value - 1) + itemsPerPage.value,
    )
  }
  dummyItems.value =
    currentItems.value.length < itemsPerPage.value
      ? Array.from({ length: itemsPerPage.value - currentItems.value.length }, () => ({}))
      : []
  emits('afterFetch', {
    items: currentItems.value,
    itemsPerPage: itemsPerPage.value,
    currentPage: currentPage.value,
    newPage: newPage,
    search: search.value,
  })
  loading.value = false
}

onMounted(async () => fetch(1))

defineExpose({
  fetch,
})
</script>

<style scoped>
.v-theme--light.v-table tbody tr:nth-of-type(odd) {
  background-color: rgba(0, 0, 0, 0.03);
}
.v-theme--dark.v-table tbody tr:nth-of-type(odd) {
  background-color: rgba(0, 0, 0, 0.5);
}

thead th,
tbody th {
  font-weight: bold !important;
}

.th-width-auto,
.td-width-auto {
  width: 1px;
  white-space: nowrap;
}

.transparent {
  background-color: transparent;
}
</style>

<i18n>
{
  "en": {
    "No data": "No data",
    "Search": "Search"
  }
}
</i18n>
