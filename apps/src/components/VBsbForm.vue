<template>
  <v-form
    :v-model="valid"
    :data="data"
    :options="options"
    ref="form"
    @submit.prevent
    validate-on="invalid-input"
  >
    <v-row>
      <v-col v-for="field in options.fields" :key="field.name" :cols="12 / (options.cols || 1)">
        <v-defaults-provider
          :defaults="{ VTextField: { variant: options.variant, density: options.density } }"
        >
          <v-text-field
            v-if="
              field.type == 'text' ||
              field.type == 'number' ||
              field.type == 'password' ||
              field.type == 'email' ||
              field.type == 'date' ||
              field.type == 'time' ||
              field.type == 'datetime'
            "
            :id="field.name"
            :type="
              field.type == 'password'
                ? showPwd
                  ? 'text'
                  : 'password'
                : field.type == 'datetime'
                  ? 'datetime-local'
                  : field.type
            "
            v-model="field.value"
            v-show="!field.hidden"
            :label="field.label && t(field.label)"
            :placeholder="field.placeholder && t(field.placeholder)"
            :clearable="field.clearable"
            :prefix="field.prefix"
            :suffix="field.suffix"
            :required="field.required"
            :readonly="field.readonly"
            :hidden="field.hidden"
            :disabled="field.disabled"
            :variant="field.variant"
            :density="options.density"
            :color="field.color"
            :hint="field.hint && t(field.hint)"
            :prepend-icon="field.prependIcon"
            :prepend-inner-icon="field.prependInnerIcon"
            :append-icon="field.appendIcon"
            :append-inner-icon="
              field.appendInnerIcon
                ? field.appendInnerIcon
                : field.type == 'password'
                  ? showPwd
                    ? '$mdiEye'
                    : '$mdiEyeOff'
                  : ''
            "
            @click:append-inner="showPwd = field.type == 'password' ? !showPwd : showPwd"
            :rules="rules(field.rules)"
            :error-messages="errorMessages(field.name)"
          />
          <v-textarea
            v-if="field.type == 'textarea'"
            :id="field.name"
            v-model="field.value"
            v-show="!field.hidden"
            :label="field.label && t(field.label)"
            :placeholder="field.placeholder && t(field.placeholder)"
            :clearable="field.clearable"
            :prefix="field.prefix"
            :suffix="field.suffix"
            :required="field.required"
            :readonly="field.readonly"
            :hidden="field.hidden"
            :disabled="field.disabled"
            :variant="field.variant"
            :density="options.density"
            :color="field.color"
            :hint="field.hint && t(field.hint)"
            :prepend-icon="field.prependIcon"
            :prepend-inner-icon="field.prependInnerIcon"
            :append-icon="field.appendIcon"
            :append-inner-icon="field.appendInnerIcon"
            :rules="rules(field.rules)"
            :error-messages="errorMessages(field.name)"
            :rows="field.rows || 5"
            :counter="field.counter"
            :no-resize="field.noResize"
            :auto-grow="field.autoGrow"
          />
          <v-switch
            v-if="field.type == 'switch'"
            :id="field.name"
            v-model="field.value"
            v-show="!field.hidden"
            :label="field.label && t(field.label)"
            :required="field.required"
            :readonly="field.readonly"
            :disabled="field.disabled"
            :color="field.color || 'primary'"
            :rules="rules(field.rules)"
            :error-messages="errorMessages(field.name)"
          />
          <v-label class="d-block" v-if="field.type == 'rating'" :for="field.name">{{
            t(field.label || '')
          }}</v-label>
          <v-rating
            v-if="field.type == 'rating'"
            :color="field.color || 'primary'"
            :id="field.name"
            v-model="field.value as number"
            v-show="!field.hidden"
            :label="field.label && t(field.label)"
            :required="field.required"
            :readonly="field.readonly"
            :disabled="field.disabled"
            :rules="rules(field.rules)"
            :error-messages="errorMessages(field.name)"
            :length="field.length || 5"
            :size="field.size || 24"
          />
          <v-checkbox
            v-if="field.type == 'checkbox'"
            :id="field.name"
            v-model="field.value"
            v-show="!field.hidden"
            :label="field.label && t(field.label)"
            :required="field.required"
            :readonly="field.readonly"
            :disabled="field.disabled"
            :color="field.color || 'primary'"
            :rules="rules(field.rules)"
            :error-messages="errorMessages(field.name)"
          />
          <v-select
            v-if="field.type == 'select'"
            :id="field.name"
            v-model="field.value as string"
            v-show="!field.hidden"
            :label="field.label && t(field.label)"
            :required="field.required"
            :readonly="field.readonly"
            :disabled="field.disabled"
            :variant="field.variant"
            :density="options.density"
            :color="field.color"
            :hint="field.hint && t(field.hint)"
            :items="field.items || []"
            :multiple="field.multiple || false"
            :chips="field.chips || false"
            :clearable="field.clearable || true"
            :rules="rules(field.rules)"
            :error-messages="errorMessages(field.name)"
          />
          <v-combobox
            v-if="field.type == 'combobox'"
            :id="field.name"
            v-model="field.value as string"
            v-show="!field.hidden"
            :label="field.label && t(field.label)"
            :required="field.required"
            :readonly="field.readonly"
            :disabled="field.disabled"
            :variant="field.variant"
            :density="options.density"
            :color="field.color"
            :hint="field.hint && t(field.hint)"
            :items="field.items || []"
            :multiple="field.multiple || false"
            :chips="field.chips || false"
            :clearable="field.clearable || true"
            :rules="rules(field.rules)"
            :error-messages="errorMessages(field.name)"
          />
          <v-autocomplete
            v-if="field.type == 'autocomplete'"
            :id="field.name"
            v-model="field.value as string"
            v-show="!field.hidden"
            :label="field.label && t(field.label)"
            :required="field.required"
            :readonly="field.readonly"
            :disabled="field.disabled"
            :variant="field.variant"
            :density="options.density"
            :color="field.color"
            :hint="field.hint && t(field.hint)"
            :items="field.items || []"
            :multiple="field.multiple || false"
            :chips="field.chips || false"
            :clearable="field.clearable || true"
            :rules="rules(field.rules)"
            :error-messages="errorMessages(field.name)"
          />
          <v-file-input
            v-if="field.type == 'file'"
            :id="field.name"
            v-model="field.value as File | File[] | null"
            v-show="!field.hidden"
            :label="field.label && t(field.label)"
            :required="field.required"
            :readonly="field.readonly"
            :disabled="field.disabled"
            :variant="field.variant"
            :density="options.density"
            :color="field.color"
            :hint="field.hint && t(field.hint)"
            :multiple="field.multiple || false"
            :chips="field.chips || false"
            :clearable="field.clearable || true"
            :prepend-icon="field.prependIcon"
            :prepend-inner-icon="field.prependInnerIcon"
            :rules="rules(field.rules)"
            :error-messages="errorMessages(field.name)"
          />
        </v-defaults-provider>
      </v-col>
    </v-row>
    <v-row v-if="options.actions">
      <v-col :class="options.actionsAlign == 'right' ? 'text-right' : ''">
        <v-btn
          v-for="action in options.actions"
          :key="action.type"
          @click="onAction(action.type as string)"
          :color="action.color"
          :prepend-icon="action.icon"
          :variant="action.variant"
          :density="action.density"
          :class="options.actionsClass"
          >{{ t(action.title || '') }}</v-btn
        >
      </v-col>
    </v-row>
  </v-form>
</template>

<script setup lang="ts">
export type BsbFormValidationRule = {
  type:
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
  value?: unknown
  message: string
}

export type BsbFormField = {
  type:
    | 'text'
    | 'number'
    | 'password'
    | 'email'
    | 'textarea'
    | 'switch'
    | 'rating'
    | 'checkbox'
    | 'select'
    | 'combobox'
    | 'autocomplete'
    | 'file'
    | 'date'
    | 'time'
    | 'datetime'
  name: string
  value?: unknown
  label?: string
  required?: boolean
  readonly?: boolean
  hidden?: boolean
  disabled?: boolean
  placeholder?: string
  clearable?: boolean
  prefix?: string
  suffix?: string
  variant?:
    | 'underlined'
    | 'outlined'
    | 'filled'
    | 'solo'
    | 'solo-inverted'
    | 'solo-filled'
    | 'plain'
  density?: 'default' | 'comfortable' | 'compact'
  color?: string
  hint?: string
  prependIcon?: string
  appendIcon?: string
  prependInnerIcon?: string
  appendInnerIcon?: string
  rules?: Array<BsbFormValidationRule>
  errors?: string[]
  //textarea
  rows?: number
  counter?: string | number | true | undefined
  noResize?: boolean
  autoGrow?: boolean
  //rating
  length?: number
  size?: number
  //select, combobox, autocomplete
  items?: string[]
  chips?: boolean
  multiple?: boolean
}

export type BsbFormAction = {
  type: 'submit' | 'cancel' | 'validate'
  title?: string
  icon?: string
  color?: string
  variant?: 'flat' | 'text' | 'elevated' | 'tonal' | 'outlined' | 'plain'
  density?: 'default' | 'comfortable' | 'compact'
}

export type BsbFormError = {
  name?: string
  message?: string
  errors?: string[]
}

export type BsbFormOptions = {
  fields: Array<BsbFormField>
  cols?: number
  variant?:
    | 'underlined'
    | 'outlined'
    | 'filled'
    | 'solo'
    | 'solo-inverted'
    | 'solo-filled'
    | 'plain'
  density?: 'default' | 'comfortable' | 'compact'
  actions?: Array<BsbFormAction> | []
  actionsAlign?: 'left' | 'right'
  actionsClass?: string
  errors: Array<BsbFormError>
  api?: string
}

const props = defineProps({
  data: {
    type: Object as PropType<Record<string, unknown>>,
    default: () => ({ cols: 1 }),
    required: false,
  },
  options: {
    type: Object as PropType<BsbFormOptions>,
    default: () => ({ fields: [] }),
    required: true,
  },
})

const emits = defineEmits(['submit', 'cancel', 'validate', 'action'])

const http = props.options.api ? useHttp({ baseURL: props.options.api }) : undefined

const { t, locale } = useI18n()
watch(
  () => locale.value,
  async () => {
    await validate()
  },
)

const data = ref(props.data)
watch(
  () => props.data,
  async (newData: Record<string, unknown>) => {
    data.value = newData
    await refresh()
  },
)

const options = ref(props.options)
watch(
  () => props.options,
  (newOptions: BsbFormOptions) => {
    options.value = newOptions
  },
)

import { VForm } from 'vuetify/components'
const form = ref<InstanceType<typeof VForm> | null>(null)
const valid = ref(false)

const showPwd = ref(false)

const defaultActions: Array<BsbFormAction> = [
  {
    type: 'submit',
    title: 'Submit',
    icon: '$mdiCheck',
    color: 'success',
  },
  {
    type: 'cancel',
    title: 'Cancel',
    icon: '$mdiClose',
    color: 'error',
    variant: 'outlined',
  },
  {
    type: 'validate',
    title: 'Validate',
    icon: '$mdiCheck',
    color: 'info',
    variant: 'outlined',
  },
]

function rules(r?: BsbFormValidationRule[]): (() => boolean | string)[] {
  function isValidJson(str: string) {
    try {
      const result = JSON.parse(str)
      const type = Object.prototype.toString.call(result)
      return type === '[object Object]' || type === '[object Array]'
    } catch {
      return false
    }
  }
  const result: (() => boolean | string)[] = []

  r?.map((rule) => {
    let f: (v: string) => boolean | string
    switch (rule.type) {
      case 'required':
        f = (v: string) => !!v || t(rule.message)
        break
      case 'min-length':
        f = (v: string) =>
          v.length >= Number(rule.value) ||
          t(rule.message).replace('{{ value }}', String(rule.value))
        break
      case 'max-length':
        f = (v: string) =>
          v.length <= Number(rule.value) ||
          t(rule.message).replace('{{ value }}', String(rule.value))
        break
      case 'equals':
        f = (v: string) => v === rule.value || t(rule.message)
        break
      case 'equals-not':
        f = (v: string) => v !== rule.value || t(rule.message)
        break
      case 'starts-with':
        f = (v: string) => v.startsWith(String(rule.value)) || t(rule.message)
        break
      case 'ends-with':
        f = (v: string) => v.endsWith(String(rule.value)) || t(rule.message)
        break
      case 'greater-than':
        f = (v: string) => Number(v) > Number(rule.value) || t(rule.message)
        break
      case 'less-than':
        f = (v: string) => Number(v) < Number(rule.value) || t(rule.message)
        break
      case 'in-range':
        f = (v: string) => {
          const [min, max] = rule.value as [number, number]
          return (Number(v) >= min && Number(v) <= max) || t(rule.message)
        }
        break
      case 'set':
        f = (v: string) => (Array.isArray(rule.value) && rule.value.includes(v)) || t(rule.message)
        break
      case 'password':
        f = (v: string) => /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/.test(v) || t(rule.message)
        break
      case 'email':
        f = (v: string) => /^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$/.test(v) || t(rule.message)
        break
      case 'url':
        f = (v: string) => /^(https?:\/\/)?([\w-]+\.)+[\w-]+(\/\S*)?$/.test(v) || t(rule.message)
        break
      case 'ip':
        f = (v: string) =>
          /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(
            v,
          ) || t(rule.message)
        break
      case 'regexp':
        f = (v: string) => new RegExp(String(rule.value)).test(v) || t(rule.message)
        break
      case 'same-as':
        f = (v: string) =>
          v == options.value.fields.find((field) => field.name == String(rule.value))?.value ||
          t(rule.message)
        break
      case 'is-json':
        f = (v: string) => isValidJson(v) || t(rule.message)
        break
      case 'custom':
        f = (v: string) => {
          const validationResult = typeof rule.value === 'function' ? rule.value(v) : true
          return validationResult === true ? true : t(validationResult || rule.message)
        }
        break
    }

    result.push(f! as () => boolean | string)
  })

  return result
}

function errorMessages(name: string): string[] {
  if (!options.value.errors) return []
  return options.value.errors
    .filter((error) => error.name == name)
    .map((error) => t(error.message || '')) as string[]
}

const validate = async () => {
  if (!form.value) return false
  const result = await form.value.validate()
  valid.value = result.valid
  emits('validate', { valid: valid.value, errors: result.errors })
  return valid.value
}

const cancel = async () => {
  data.value = props.data
  options.value.errors = []
  refresh()
  emits('cancel')
}

import { type HttpResponse } from '@/composables/http'

const submit = async () => {
  if (!form.value) return false
  if (await validate()) {
    const newData = { ...data.value }
    options.value.fields.forEach((field) => {
      newData[field.name] = field.value
    })
    if (props.options.api) {
      const response = (await http?.post('', newData)) as HttpResponse<{ errors: [BsbFormError] }>
      if (response.data?.errors && response.data.errors.length > 0) {
        options.value.errors = response.data.errors
        valid.value = false
        return false
      } else {
        data.value = { ...newData }
        valid.value = true
        options.value.errors = []
        emits('submit', newData)
      }
    } else {
      options.value.errors = []
      emits('submit', newData)
    }
  }
}

const action = async (actionType: string) => {
  const newData = { ...data.value }
  options.value.fields.forEach((field) => {
    newData[field.name] = field.value
  })
  emits('action', { action: actionType, data: newData })
}

const onAction = async (actionType: string) => {
  switch (actionType) {
    case 'submit':
      await submit()
      break
    case 'cancel':
      await cancel()
      break
    case 'validate':
      await validate()
      break
    default:
      action(actionType)
      break
  }
}

const refresh = async () => {
  if (
    Array.isArray(options.value.actions) &&
    options.value.actions.every((item) => typeof item === 'string')
  ) {
    const actions = options.value.actions as string[]
    options.value.actions = defaultActions.filter((item: BsbFormAction) =>
      actions.includes(item.type),
    )
  }
  options.value.fields.forEach((field) => {
    if (field.name in data.value) {
      field.value = data.value[field.name]
    }
  })
}

const focusFirstField = () => {
  const firstField = options.value.fields.find((field) => !field.hidden && !field.disabled)
  if (firstField) {
    const inputElement = document.getElementById(firstField.name) as HTMLInputElement | null
    if (inputElement) {
      inputElement.focus()
    }
  }
}

let lastFieldInputElement: HTMLInputElement | null = null
let enterKeyListener: ((event: KeyboardEvent) => Promise<void>) | null = null

const addEnterKeyListenerToLastField = () => {
  const lastField = [...options.value.fields]
    .reverse()
    .find((field) => !field.hidden && !field.disabled)
  if (lastField) {
    lastFieldInputElement = document.getElementById(lastField.name) as HTMLInputElement | null
    if (lastFieldInputElement) {
      enterKeyListener = async (event: KeyboardEvent) => {
        if (event.key === 'Enter') {
          event.preventDefault()
          await submit()
        }
      }
      lastFieldInputElement.addEventListener('keydown', enterKeyListener)
    }
  }
}

onMounted(async () => {
  await refresh()
  focusFirstField()
  addEnterKeyListenerToLastField()
})

onBeforeUnmount(() => {
  if (lastFieldInputElement && enterKeyListener) {
    lastFieldInputElement.removeEventListener('keydown', enterKeyListener)
  }
})
</script>
