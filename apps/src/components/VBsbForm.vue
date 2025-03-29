<template>
  <v-defaults-provider :defaults>
    <v-container>
      <v-form
        ref="form"
        validate-on="invalid-input"
        :autocomplete="options.autocomplete"
        :disabled="options.disabled"
        :readonly="options.readonly"
        :fast-fail="options.fastFail"
        @submit.prevent
      >
        <v-row>
          <v-col
            v-for="field in fields"
            :key="field.name"
            :cols="12 / (mobile ? 1 : options.cols || 1)"
          >
            <component
              :is="field.component"
              :id="field.name"
              v-model="values[field.name]"
              v-bind="field.props"
              :rules="field.rules()"
              :error-messages="field.errors()"
              @keyup.enter="handleFieldEnter(field.name)"
            />
          </v-col>
        </v-row>
        <v-row v-if="actions.length > 0">
          <v-col :class="bsbTextAlign(options.actionAlign)">
            <v-btn
              v-for="action in actions"
              :key="action.name"
              v-bind="action.props"
              @click="handleAction(action.name)"
            />
          </v-col>
        </v-row>
      </v-form>
      <v-overlay :model-value="loading" persistent contained class="align-center justify-center">
        <v-progress-circular indeterminate />
      </v-overlay>
    </v-container>
  </v-defaults-provider>
</template>

<script setup lang="ts">
import {
  VTextField,
  VSelect,
  VCombobox,
  VAutocomplete,
  VFileInput,
  VSwitch,
  VCheckbox,
  VRating,
  VTextarea,
} from 'vuetify/components'

import {
  type BsbFormOptions,
  type BsbFormData,
  bsbTextAlign,
  bsbActionsFormat,
  bsbRuleValidate,
} from './index'

const { defaults } = useDefaults({
  name: 'VBsbForm',
  defaults: {
    VContainer: {
      class: 'position-relative',
    },
    VOverlay: {
      class: 'rounded',
    },
    VForm: {
      VBtn: {
        class: 'ma-1',
      },
    },
  },
})

const {
  options,
  data,
  t = (text?: string) => text || '',
  loading = false,
} = defineProps<{
  options: BsbFormOptions
  data?: BsbFormData
  t?: (text?: string) => string
  loading?: boolean
}>()

const emits = defineEmits<{
  (event: 'action', actionName: string, formData: BsbFormData): void
  (event: 'cancel'): void
  (event: 'reset'): void
  (event: 'submit', formData: BsbFormData): void
  (event: 'validate', formData: BsbFormData, errors?: unknown): void
}>()

watch(
  () => data,
  (newData) => {
    if (newData && Object.keys(newData).length) {
      values.value = { ...values.value, ...newData }
    }
  },
  { deep: true },
)

const { mobile } = useDisplay()

const form = ref()
const showPwd = ref(false)

const fields = computed(() => {
  const componentMap = {
    select: VSelect,
    combobox: VCombobox,
    autocomplete: VAutocomplete,
    file: VFileInput,
    switch: VSwitch,
    checkbox: VCheckbox,
    rating: VRating,
    textarea: VTextarea,
    text: VTextField,
    number: VTextField,
    email: VTextField,
    date: VTextField,
    time: VTextField,
    datetime: VTextField,
  }

  return (options.fields.filter((field) => !field.hidden) || []).map((field) => {
    const baseProps: Record<string, unknown> = {
      name: field.name,
      type:
        field.type == 'datetime'
          ? 'datetime-local'
          : field.type === 'password'
            ? showPwd.value
              ? 'text'
              : 'password'
            : field.type,
      label: field.label ? t(field.label) : undefined,
      placeholder: field.placeholder ? t(field.placeholder) : undefined,
      autocomplete: field.autocomplete || options.autocomplete,
      hint: field.hint ? t(field.hint) : undefined,
      clearable: field.clearable,
      prependIcon: field.prependIcon,
      appendIcon: field.appendIcon,
      prependInnerIcon: field.prependInnerIcon,
      appendInnerIcon:
        field.type === 'password'
          ? showPwd.value
            ? '$mdiEyeOff'
            : '$mdiEye'
          : field.prependInnerIcon,
      'onClick:appendInner':
        field.type === 'password' ? () => (showPwd.value = !showPwd.value) : undefined,
      required: field.required,
      readonly: field.readonly,
      disabled: field.disabled,
      variant: field.variant,
      density: field.density,
      color: field.color,
    }
    if (field.counter !== undefined) {
      baseProps.counter = ['textarea', 'text', 'email', 'password'].includes(field.type)
        ? field.counter
        : undefined
    }
    if (
      !['switch', 'rating', 'file', 'checkbox', 'select', 'combobox', 'autocomplete'].includes(
        field.type,
      )
    ) {
      baseProps.prefix = field.prefix
      baseProps.suffix = field.suffix
    }
    if (['switch', 'checkbox'].includes(field.type) && !field.color) {
      baseProps.color = 'primary'
    }
    if (field.type === 'rating' && 'form' in options && (options.disabled || options.readonly)) {
      baseProps.disabled = true
      baseProps.readonly = true
      baseProps.color = 'grey'
    }

    let specificProps: Record<string, unknown> = {}
    if (field.type === 'textarea') {
      const textareaField = field as BsbFormTextareaField
      specificProps = {
        rows: textareaField.rows || 5,
        noResize: textareaField.noResize,
        autoGrow: textareaField.autoGrow,
      }
    } else if (field.type === 'rating') {
      const ratingField = field as BsbFormRatingField
      specificProps = {
        length: ratingField.length || 5,
        size: ratingField.size || 24,
        itemLabels: ratingField.itemLabels || ([field.label] as string[]),
      }
    } else if (['select', 'combobox', 'autocomplete'].includes(field.type)) {
      const selectionField = field as BsbFormSelectionField
      specificProps = {
        items: selectionField.items || [],
        chips: selectionField.chips || false,
        multiple: selectionField.multiple || false,
        itemTitle: 'title',
        itemValue: 'value',
      }
    }

    return {
      component: componentMap[field.type as keyof typeof componentMap] || VTextField,
      name: field.name,
      props: { ...baseProps, ...specificProps },
      errors: (): string[] => {
        if (!options.errors) return []
        return options.errors
          .filter((error: BsbFormFieldError) => error.name === field.name)
          .map((error: BsbFormFieldError) => t(error.message || ''))
      },
      rules: () =>
        (field.rules || []).map(
          (rule) => (value: unknown) =>
            bsbRuleValidate(value, rule.type, rule.params, t(rule.message)),
        ),
    }
  })
})

const actions = computed(() =>
  bsbActionsFormat(options.actions, options.actionFormat, undefined, t),
)

const values = ref<BsbFormData>({})

const handleAction = async (actionName: string) => {
  const action = actions.value.find((action) => action.name === actionName)
  if (!action) return

  if (action.name === options.actionCancel) {
    await emits('cancel')
    return
  }

  if (action.name === options.actionReset) {
    resetValues()
    await emits('reset')
    return
  }

  if (action.name === options.actionSubmit) {
    const { valid, errors } = await form.value.validate()
    if (!valid) {
      formFocus(errors[0]?.id)
      return
    }
    await emits('submit', values.value)
    return
  }

  if (action.name === options.actionValidate) {
    const { valid, errors } = await form.value.validate()
    if (!valid) {
      formFocus(errors[0]?.id)
      await emits('validate', values.value, errors)
      return
    }
    await emits('validate', values.value)
    return
  }

  await emits('action', action.name, values.value)
}

async function handleFieldEnter(fieldName: string) {
  if (!options.actions) return
  const isLastField = fields.value[fields.value.length - 1].name === fieldName
  const hasSubmitAction = actions.value.find((action) => action.name === options.actionSubmit)
  if (isLastField && hasSubmitAction) await handleAction(hasSubmitAction.name)
}

function formFocus(elementId?: string) {
  if (!elementId) return
  const inputElement = document.getElementById(elementId) as HTMLInputElement | null
  if (inputElement) inputElement.focus()
}

function resetValues() {
  const fieldDefaults = Object.fromEntries(
    options.fields
      .filter((field) => field.value !== undefined)
      .map((field) => [field.name, field.value]),
  )
  values.value = { ...fieldDefaults, ...data }
}

onMounted(() => {
  resetValues()

  if (options.focusFirst && fields.value.length > 0) {
    formFocus(fields.value[0].name)
  }
})
</script>
