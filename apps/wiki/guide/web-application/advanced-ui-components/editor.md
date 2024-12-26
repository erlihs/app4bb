# Editor

## Overview

The **v-bsb-editor** component is a flexible and customizable rich text editor toolbar that utilizes the `@tiptap/vue-3` library. It includes various formatting options like bold, italic, underline, strike-through, bullet lists, ordered lists, and headings. The component provides a clean interface for managing editor content and emits changes through a Vue event.

This component is designed to be integrated with the Tiptap editor and supports dynamic toolbar options. It allows developers to control which buttons are available on the toolbar and responds to user interactions with formatting options.

## Usage Examples

### Basic Example

```vue
<template>
  <EditorToolbar :toolbar="['bold', 'italic', 'underline']" @updated="onUpdate" />
</template>

<script setup>
import EditorToolbar from './EditorToolbar.vue'

const onUpdate = (content) => {
  console.log('Updated content:', content)
}
</script>
```

### Full Example with All Options

```vue
<template>
  <EditorToolbar
    :toolbar="[
      'bold',
      'italic',
      'underline',
      'strike',
      'bulletList',
      'orderedList',
      'heading1',
      'heading2',
      'heading3',
    ]"
    @updated="onUpdate"
  />
</template>

<script setup>
import EditorToolbar from './EditorToolbar.vue'

const onUpdate = (content) => {
  console.log('Updated content:', content)
}
</script>
```

### Styling the Toolbar

```vue
<template>
  <EditorToolbar
    :toolbar="['bold', 'italic', 'underline']"
    toolbarClass="custom-toolbar-class"
    @updated="onUpdate"
  />
</template>

<style scoped>
.custom-toolbar-class {
  background-color: #f5f5f5;
  padding: 10px;
  border-radius: 5px;
}
</style>
```

## API

### Props

| Name           | Type            | Default | Description                                                                                                                                                          |
| -------------- | --------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `toolbar`      | `Array<String>` | `[]`    | A list of toolbar buttons to display. Supported values are `bold`, `italic`, `underline`, `strike`, `bulletList`, `orderedList`, `heading1`, `heading2`, `heading3`. |
| `toolbarClass` | `String`        | `''`    | A class name to apply custom styling to the toolbar container.                                                                                                       |

### Emits

| Event Name | Parameters        | Description                                                                     |
| ---------- | ----------------- | ------------------------------------------------------------------------------- |
| `updated`  | `content: String` | Emitted when the editor's content is updated, passing the updated HTML content. |

## Source

1. Install Dependencies

```ps
npm install @tiptap/vue-3
npm install @tiptap/pm
npm install @tiptap/starter-kit
npm install @tiptap/extension-underline
```

2. Create component and unit test.

:::details Component `@/components/VBsbEditor.vue`
<<< @../../src/components/VBsbEditor.vue
:::

:::details Test `@/components/__tests__/VBsbEditor.test.ts`

<!-- prettier-ignore -->
<<< @../../src/components/__tests__/VBsbEditor.test.ts
:::
