# Pad

## Overview

The `VBsbPad` component is a versatile drawing pad that allows users to create resizable sketches and drawings on a canvas. This component supports a variety of customizable options, such as different stroke types, eraser functionality, line styles, background colors, and more. It is built with Vue 3, using the Composition API, and integrates with Vuetify for a polished UI.

The `VBsbPad` component can be used in applications that require user input drawing capabilities, such as graphic design tools, signature pads, or collaborative whiteboard features.

## Usage Examples

### Basic Usage

```vue
<template>
  <VBsbPad />
</template>

<script setup>
import VBsbPad from '@/components/VBsbPad.vue'
</script>
```

### Advanced Usage with Custom Props

```vue
<template>
  <VBsbPad
    :strokeType="'circle'"
    :color="'#ff6347'"
    :lineWidth="8"
    :fillShape="true"
    :backgroundColor="'#fafafa'"
    :eraser="false"
    :lock="false"
    :outputWidth="600"
    :outputHeight="400"
  />
</template>

<script setup>
import VBsbPad from '@/components/VBsbPad.vue'
</script>
```

### Handling Events

```vue
<template>
  <VBsbPad @update:image="handleImageUpdate" />
</template>

<script setup>
import VBsbPad from '@/components/VBsbPad.vue'

const handleImageUpdate = (imageDataUrl) => {
  console.log('Updated Image Data:', imageDataUrl)
}
</script>
```

## API

### Props

| Prop               | Type                      | Default                | Description                                                                                     |
| ------------------ | ------------------------- | ---------------------- | ----------------------------------------------------------------------------------------------- |
| `strokeType`       | `String`                  | `'dash'`               | Type of stroke to draw (e.g., 'dash', 'line', 'square', 'circle', 'triangle', 'half_triangle'). |
| `fillShape`        | `Boolean`                 | `false`                | Whether to fill the drawn shape with the selected color.                                        |
| `image`            | `String`                  | `''`                   | URL of the image to load onto the canvas.                                                       |
| `eraser`           | `Boolean`                 | `false`                | Toggles eraser functionality to remove parts of the drawing.                                    |
| `color`            | `String`                  | `'#000000'`            | The color of the stroke.                                                                        |
| `lineWidth`        | `Number`                  | `5`                    | The width of the drawn line.                                                                    |
| `lineCap`          | `String`                  | `'round'`              | The style of line ending (e.g., 'round', 'square', 'butt').                                     |
| `lineJoin`         | `String`                  | `'miter'`              | The type of corner created when two lines meet ('miter', 'round', 'bevel').                     |
| `lock`             | `Boolean`                 | `false`                | Locks the canvas to prevent drawing or erasing.                                                 |
| `styles`           | `Object`                  | `{}`                   | Additional styles to apply to the canvas.                                                       |
| `classes`          | `[Array, String, Object]` | `null`                 | CSS classes to apply to the canvas element.                                                     |
| `backgroundColor`  | `String`                  | `'#FFFFFF'`            | The background color of the canvas.                                                             |
| `backgroundImage`  | `String`                  | `null`                 | URL of a background image for the canvas.                                                       |
| `saveAs`           | `String`                  | `'png'`                | The format for saving the drawing (`'jpeg'` or `'png'`).                                        |
| `canvasId`         | `String`                  | `'canvas-' + uniqueId` | Unique ID for the canvas element.                                                               |
| `initialImage`     | `Array`                   | `[]`                   | Initial set of strokes to load into the canvas.                                                 |
| `additionalImages` | `Array`                   | `[]`                   | Additional images to be added on top of the canvas.                                             |
| `outputWidth`      | `Number`                  | `null`                 | The width of the output image.                                                                  |
| `outputHeight`     | `Number`                  | `null`                 | The height of the output image.                                                                 |

### Emits

| Event          | Payload             | Description                                                                          |
| -------------- | ------------------- | ------------------------------------------------------------------------------------ |
| `update:image` | `String` (Data URL) | Emitted when the canvas is saved, containing the image data in the specified format. |

### Exposes

| Method           | Description                                                                     |
| ---------------- | ------------------------------------------------------------------------------- |
| `clear()`        | Clears the canvas.                                                              |
| `reset()`        | Resets the canvas, removing all drawings and returning it to its initial state. |
| `undo()`         | Undoes the last drawing action.                                                 |
| `redo()`         | Redoes the last undone drawing action.                                          |
| `save()`         | Saves the current canvas drawing and emits the `update:image` event.            |
| `startDraw()`    | Starts a drawing action (triggered on interaction).                             |
| `draw()`         | Draws on the canvas (called continuously while dragging).                       |
| `stopDraw()`     | Stops the current drawing action.                                               |
| `handleResize()` | Handles resizing of the canvas to fit its container.                            |

### Types

#### Stroke Types

- **Dash**: Dashed lines for decorative drawings.
- **Line**: Simple straight lines.
- **Square**: Creates rectangular shapes.
- **Circle**: Draws circles with the given parameters.
- **Triangle**: Draws triangular shapes.
- **Half Triangle**: Creates a right-angle triangle.

#### Line Cap and Line Join Types

- **Line Cap**: `'round'`, `'square'`, `'butt'`.
- **Line Join**: `'miter'`, `'round'`, `'bevel'`.

## Source

:::details Component
<<< @../../src/components/VBsbPad.vue
:::

:::details Test

<!-- prettier-ignore -->
<<< @../../src/components/__tests__/VBsbPad.test.ts
:::
