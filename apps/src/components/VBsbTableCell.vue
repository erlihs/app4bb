<template>
  <v-chip
    v-if="formatted && !href && format.text"
    :color="format.color"
    :prepend-icon="format.icon"
    :variant="format.variant"
    :text="text"
  />
  <span v-if="formatted && !href && !format.text && format.icon"
    ><v-icon :icon="format.icon" :color="format.color"
  /></span>
  <a v-if="href" :href="href" :target="format.target ?? '_self'">{{ text }}</a>
  <span v-if="!formatted && !href">{{ text }}</span>

  <v-dialog v-if="shortened">
    <template v-slot:activator="{ props: activatorProps }">
      <v-btn
        v-bind="activatorProps"
        text="..."
        variant="tonal"
        density="default"
        size="x-small"
        rounded="lg"
      ></v-btn>
    </template>
    <template v-slot:default="{ isActive }">
      <v-card>
        <v-card-title>{{ column.title }}</v-card-title>
        <v-card-text>{{ item[column.column] }}</v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn :text="t('Close')" @click="isActive.value = false"></v-btn>
        </v-card-actions>
      </v-card>
    </template>
  </v-dialog>

  <span v-for="action in column.actions" :key="action.action">
    <v-btn
      v-if="showAction(action, item)"
      data-cy="action"
      @click="onAction(action, item)"
      :key="action.action"
      :text="t(action.format?.text ?? '')"
      :icon="action.format?.icon"
      :color="action.format?.color"
      :variant="action.format?.variant"
      :density="action.format?.density"
      :size="action.format?.size"
      :class="action.format?.class"
    ></v-btn>
  </span>
</template>
<script setup lang="ts">
import type {
  BsbTableItem,
  BsbTableColumn,
  BsbTableFormat,
  BsbTableAction,
  BsbTableCondition,
} from './VBsbTable.vue'

const { t } = useI18n()

const { item, column, shorten } = defineProps<{
  item: BsbTableItem
  column: BsbTableColumn
  shorten?: number
}>()

const emits = defineEmits<{
  action: [BsbTableAction, BsbTableItem]
}>()

function onAction(action: BsbTableAction, item: BsbTableItem) {
  emits('action', action, item)
}

const text = ref('')
const shortened = ref(false)
const format = ref<BsbTableFormat>({})
const formatted = ref(false)
const href = ref('')

type ConditionChecker = (condition: BsbTableCondition) => boolean
type ConditionEvaluator = (condition: BsbTableAction['condition']) => boolean
function showAction(action: BsbTableAction, item: BsbTableItem): boolean {
  if (!action.condition) return true

  const checkCondition: ConditionChecker = ({ name, type, value }) => {
    const itemValue = item[name]
    const numValue = Number(itemValue)

    switch (type) {
      case 'equals':
        return itemValue === value
      case 'not-equals':
        return itemValue !== value
      case 'greater-than':
        return numValue > Number(value)
      case 'less-than':
        return numValue < Number(value)
      case 'in-range': {
        const [min, max] = value as [number, number]
        return numValue >= min && numValue <= max
      }
      default:
        return false
    }
  }

  const evaluateCondition: ConditionEvaluator = (condition) => {
    return Array.isArray(condition)
      ? condition.some(evaluateCondition)
      : checkCondition(condition as BsbTableCondition)
  }

  return evaluateCondition(action.condition)
}

function validate(
  condition?: string,
  params?: unknown,
  value?: unknown,
  message?: string,
): boolean | string {
  const validationRules: { [key: string]: () => boolean | string } = {
    required: () => !!value || message || false,
    'min-length': () =>
      (typeof value === 'string' && value.length >= Number(params)) || message || false,
    'max-length': () =>
      (typeof value === 'string' && value.length <= Number(params)) || message || false,
    equals: () => value === params || message || false,
    'equals-not': () => value !== params || message || false,
    'starts-with': () =>
      (typeof value === 'string' && value.startsWith(params as string)) || message || false,
    'ends-with': () =>
      (typeof value === 'string' && value.endsWith(params as string)) || message || false,
    'greater-than': () => Number(value) > Number(params) || message || false,
    'less-than': () => Number(value) < Number(params) || message || false,
    'in-range': () => {
      const [min, max] = params as [number, number]
      return (Number(value) >= min && Number(value) <= max) || message || false
    },
    set: () => (Array.isArray(params) && params.includes(value)) || message || false,
    password: () =>
      /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/.test(value as string) || message || false,
    email: () => /^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$/.test(value as string) || message || false,
    url: () =>
      /^(https?:\/\/)?([\w-]+\.)+[\w-]+(\/\S*)?$/.test(value as string) || message || false,
    ip: () =>
      /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(
        value as string,
      ) ||
      message ||
      false,
    regexp: () => new RegExp(String(params)).test(value as string) || message || false,
    'same-as': () => value === params || message || false,
    'is-json': () =>
      (typeof value === 'string' &&
        (() => {
          try {
            JSON.parse(value)
            return true
          } catch {
            return false
          }
        })()) ||
      message ||
      false,
    custom: () => (typeof params === 'function' && params(value)) || message || false,
  }

  return condition && validationRules[condition] ? validationRules[condition]() : message || false
}

watchEffect(() => {
  text.value = item[column.column] as string
  if (text.value) {
    const maxLength = column.shorten ?? shorten ?? Number.MAX_SAFE_INTEGER
    shortened.value = text.value.length > maxLength || maxLength === 0
    if (shortened.value) {
      text.value = maxLength === 0 ? '' : text.value.slice(0, maxLength)
    }
  }
  format.value = Array.isArray(column.format)
    ? column.format.find((f) => validate(f.condition, f.params, item[column.column])) || {}
    : column.format || {}
  formatted.value = Object.values(format.value).some((value) => value)
  href.value =
    !Array.isArray(column.format) && column.format?.to
      ? column.format.to.replace('$value', item[column.column] as string)
      : ''
})

defineExpose({ validate })
</script>
