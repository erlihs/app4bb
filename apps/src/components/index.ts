export type BsbRule = {
  type:
    | 'required'
    | 'min-length'
    | 'max-length'
    | 'equals'
    | 'equals-not'
    | 'starts-with'
    | 'ends-with'
    | 'contains'
    | 'greater-than'
    | 'less-than'
    | 'in-range'
    | 'includes'
    | 'set'
    | 'password'
    | 'email'
    | 'url'
    | 'ip'
    | 'regexp'
    | 'same-as'
    | 'is-json'
    | 'custom'
  params: unknown
  message?: string
}

export type BsbFormat = {
  rules?: BsbRule | BsbRule[]
  text?: string
  icon?: string
  color?: string
  variant?: 'flat' | 'outlined' | 'plain' | 'text' | 'elevated' | 'tonal'
  density?: 'compact' | 'default' | 'comfortable'
  size?: 'x-small' | 'small' | 'default' | 'large' | 'x-large'
  rounded?: boolean
  class?: string
  to?: string
  href?: string
  target?: string
}
export type BsbAction =
  | {
      key?: string
      name: string
      format?: BsbFormat | BsbFormat[]
      //form
    }
  | string

type BsbFormFieldBase = {
  type:
    | 'text'
    | 'email'
    | 'password'
    | 'textarea'
    | 'number'
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
  placeholder?: string
  autocomplete?: 'off' | 'on'
  hint?: string
  prefix?: string
  suffix?: string
  prependIcon?: string
  appendIcon?: string
  prependInnerIcon?: string
  appendInnerIcon?: string
  required?: boolean
  readonly?: boolean
  hidden?: boolean
  disabled?: boolean
  clearable?: boolean
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
  rules?: BsbRule[]
  errors?: string[]
  counter?: number
}

export type BsbFormTextareaField = BsbFormFieldBase & {
  type: 'textarea'
  rows?: number
  noResize?: boolean
  autoGrow?: boolean
}

export type BsbFormRatingField = BsbFormFieldBase & {
  type: 'rating'
  length?: number
  size?: number
  itemLabels?: string[]
}

export type BsbFormSelectionField = BsbFormFieldBase & {
  type: 'select' | 'combobox' | 'autocomplete'
  items?: string[]
  chips?: boolean
  multiple?: boolean
}

type BsbFormFileField = BsbFormFieldBase & {
  type: 'file'
}

type BsbFormField =
  | BsbFormFieldBase
  | BsbFormTextareaField
  | BsbFormRatingField
  | BsbFormSelectionField
  | BsbFormFileField

export type BsbFormFieldError = {
  name: string
  message: string
}

export type BsbFormOptions = {
  fields: BsbFormField[]
  actions?: BsbAction[]
  actionFormat?: BsbFormat | BsbFormat[]
  actionAlign?: 'left' | 'right' | 'center'
  actionSubmit?: string
  actionReset?: string
  actionValidate?: string
  actionCancel?: string
  autocomplete?: 'on' | 'off'
  disabled?: boolean
  readonly?: boolean
  fastFail?: boolean
  errors?: BsbFormFieldError[]
  cols?: number
  focusFirst?: boolean
}

export type BsbFormData = Record<string, unknown>

export const bsbRuleValidate = (
  value?: unknown,
  rule?: string,
  params?: unknown,
  message?: string,
): boolean | string => {
  if (!rule) return message || false
  const validationRules: Record<string, () => boolean | string> = {
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
    contains: () =>
      (typeof value === 'string' && value.includes(params as string)) || message || false,
    'greater-than': () => Number(value) > Number(params) || message || false,
    'less-than': () => Number(value) < Number(params) || message || false,
    'in-range': () => {
      const [min, max] = params as [number, number]
      return (Number(value) >= min && Number(value) <= max) || message || false
    },
    includes: () => (Array.isArray(params) && params.includes(value)) || message || false,
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
  return validationRules[rule] ? validationRules[rule]() : message || false
}

function formatValidate(value: unknown, format?: BsbFormat | BsbFormat[]): BsbFormat {
  if (!format) return {}
  const formats = Array.isArray(format) ? format : [format]
  for (const fmt of formats) {
    if (!fmt?.rules) return fmt
    const rules = Array.isArray(fmt.rules) ? fmt.rules : [fmt.rules]
    if (rules.length === 0) return fmt
    const isValid = rules.some(
      (rule) => !!bsbRuleValidate(value, rule?.type, rule?.params, rule?.message),
    )
    if (isValid) return fmt
  }
  return {}
}

export const bsbTextAlign = (align: 'left' | 'center' | 'right' | undefined) =>
  align ?? `text-${align}`

export const bsbActionsFormat = (
  actions?: BsbAction[],
  actionFormat?: BsbFormat | BsbFormat[],
  actionValues?: Record<string, unknown>,
  t?: (text?: string) => string,
) => {
  if (!actions) return []

  return (actions || []).map((action) => {
    const act = typeof action === 'string' ? { name: action } : action
    const val = actionValues?.[act.name]
    const fmt = formatValidate(val, { ...actionFormat, ...act.format })

    return {
      key: act.key,
      name: act.name,
      props: Object.fromEntries(
        Object.entries({
          icon: fmt.icon,
          text: fmt.icon ? undefined : t ? t(fmt.text || act.name) : fmt.text || act.name,
          color: fmt.color,
          class: fmt.class,
          size: fmt.size,
          density: fmt.density,
          variant: fmt.variant,
          rounded: fmt.rounded,
          to: fmt.to,
          href: fmt.href,
          target: fmt.target,
        }).filter(([, v]) => v !== undefined),
      ),
    }
  })
}
