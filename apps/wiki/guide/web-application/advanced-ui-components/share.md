# Share

## Overview

The `VBsbShare` component is a versatile social sharing button group that integrates various social media platforms such as Twitter, Facebook, LinkedIn, WhatsApp, and a copy-to-clipboard functionality. This component allows users to share content across different social networks with ease, offering customizable options for appearance, behavior, and supported platforms.

## Usage Examples

### Basic Example

```vue
<template>
  <VBsbShare
    :share="['twitter', 'facebook', 'linkedin', 'whatsapp', 'copy']"
    :share-options="{ text: 'Check out this amazing content!', url: 'http://example.com' }"
    :window-features="{ width: 600, height: 400, top: 100, left: 100 }"
  />
</template>

<script setup>
import VBsbShare from '@/components/VBsbShare.vue'
</script>
```

### Customized Button Styles Example

You can customize the appearance of the buttons by providing different values for `variant`, `density`, and `color` props.

```vue
<template>
  <VBsbShare
    :share="['twitter', 'facebook']"
    :share-options="{ text: 'Learn more about our services', url: 'http://example.com' }"
    :variant="'outlined'"
    :density="'compact'"
    :color="'primary'"
  />
</template>

<script setup>
import VBsbShare from '@/components/VBsbShare.vue'
</script>
```

### Copy-to-Clipboard Only Example

You can enable only the copy-to-clipboard functionality without social sharing buttons by adjusting the `share` prop.

```vue
<template>
  <VBsbShare :share="['copy']" :share-options="{ text: 'Copy this important information!' }" />
</template>

<script setup>
import VBsbShare from '@/components/VBsbShare.vue'
</script>
```

---

## API

### Props

| Prop                | Type                                                                 | Default                                                   | Description                                                                                                        |
| ------------------- | -------------------------------------------------------------------- | --------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| `share`             | `Array<'twitter', 'facebook', 'linkedin', 'whatsapp', 'copy'>`       | `['twitter', 'facebook', 'linkedin', 'whatsapp', 'copy']` | Specifies the social media platforms to display as sharing options.                                                |
| `windowFeatures`    | `Object` (of type `WindowFeatures`)                                  | `{ width: 600, height: 400, top: 100, left: 100 }`        | Specifies the features of the popup window when sharing (width, height, top, left position).                       |
| `shareOptions`      | `Object` (of type `ShareOptions`)                                    | `{ text: '', url: '', number: '' }`                       | Defines options related to the shared content, such as the text, URL, and (for WhatsApp) a phone number.           |
| `useNativeBehavior` | `Boolean`                                                            | `false`                                                   | Determines whether to use the native behavior of the social share platform (when applicable).                      |
| `variant`           | `'flat' \| 'text' \| 'elevated' \| 'tonal' \| 'outlined' \| 'plain'` | `undefined`                                               | Defines the style of the Vuetify buttons (e.g., flat, outlined, elevated).                                         |
| `density`           | `'default' \| 'comfortable' \| 'compact'`                            | `undefined`                                               | Controls the density (size and spacing) of the buttons (default, comfortable, compact).                            |
| `color`             | `String`                                                             | `undefined`                                               | Specifies the color of the buttons, which corresponds to Vuetify’s color schemes (e.g., primary, secondary, etc.). |

### Emits

The component does not emit any custom events.

### Exposes

The component does not expose any methods or variables to parent components.

## Types

### `Share`

```ts
export type Share = 'twitter' | 'facebook' | 'linkedin' | 'whatsapp' | 'copy'
```

This type defines the available social sharing platforms.

### `WindowFeatures`

```ts
export type WindowFeatures = {
  width: number
  height: number
  top: number
  left: number
}
```

This type defines the attributes for controlling the pop-up window features when sharing on social media.

### `ShareOptions`

```ts
export type ShareOptions = {
  text?: string // Text to share
  url: string // URL to share
  via?: string // Optional: account to credit (for Twitter)
  hashtags?: string[] // Optional: hashtags to include (for Twitter)
  number: string // Optional: phone number (for WhatsApp)
  quote?: string // Optional: quote to include (for Facebook)
}
```

This type defines the options related to the shared content, including text, URL, and platform-specific details (e.g., `via` for Twitter, `number` for WhatsApp).

## Source

1. Install Dependencies

```ps
npm install vue-socials
```

2. Create component and unit test.

:::details Component
<<< @../../src/components/VBsbShare.vue
:::

:::details Test

<!-- prettier-ignore -->
<<< @../../src/components/__tests__/VBsbShare.test.ts
:::
