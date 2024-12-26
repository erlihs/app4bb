# Map

## Overview

The `GoogleMapComponent` is a Vue.js component designed for rendering a Google Map using the `vue3-google-map` library. It supports features like customizable markers, zoom controls, auto-centering, and geo-location. The component is highly flexible, allowing developers to set map options dynamically, update markers, and listen to user interactions on the map, such as clicks and zoom changes.

### Key Features:

- Displays a Google Map with customizable center and zoom.
- Supports auto-centering based on user location.
- Allows adding and removing markers, each with custom colors and info windows.
- Emits events for interactions like zoom changes, map clicks, and marker updates.
- Provides utility methods for marker management.

## Usage Examples

### Basic Usage Example

```vue
<template>
  <GoogleMapComponent
    :center="{ lat: 37.7749, lng: -122.4194 }"
    :zoom="12"
    :markers="markers"
    @zoomed="handleZoomChange"
    @clicked="handleMapClick"
    @located="handleLocation"
    @marked="handleMarkerChange"
  />
</template>

<script setup>
import { ref } from 'vue'

const markers = ref([
  { lat: 37.7749, lng: -122.4194, title: 'San Francisco', color: 'red', info: 'Welcome to SF' },
])

function handleZoomChange(zoom) {
  console.log('Zoom level changed to:', zoom)
}

function handleMapClick(location) {
  console.log('Map clicked at:', location)
}

function handleLocation(location) {
  console.log('User located at:', location)
}

function handleMarkerChange(updatedMarkers) {
  console.log('Markers updated:', updatedMarkers)
}
</script>
```

### Adding and Removing Markers

```vue
<template>
  <GoogleMapComponent
    :center="{ lat: 40.7128, lng: -74.006 }"
    :zoom="10"
    :markers="markerList"
    @marked="handleMarkerUpdate"
  />
  <button @click="addMarker">Add Marker</button>
  <button @click="removeMarker">Remove Marker</button>
</template>

<script setup>
import { ref } from 'vue'

const markerList = ref([{ lat: 40.7128, lng: -74.006, title: 'New York', color: 'blue' }])

function addMarker() {
  markerList.value.push({ lat: 40.73061, lng: -73.935242, title: 'New Marker', color: 'green' })
}

function removeMarker() {
  markerList.value.pop()
}

function handleMarkerUpdate(updatedMarkers) {
  console.log('Markers updated:', updatedMarkers)
}
</script>
```

## API Reference

### Props

| Prop           | Type                           | Default              | Description                                                               |
| -------------- | ------------------------------ | -------------------- | ------------------------------------------------------------------------- |
| `center`       | `{ lat: number, lng: number }` | `{ lat: 0, lng: 0 }` | Coordinates of the map center. Required.                                  |
| `zoom`         | `number`                       | `10`                 | Initial zoom level for the map. Required.                                 |
| `markers`      | `Array<TBsbMapMarker>`         | `[]`                 | Array of markers with latitude, longitude, title, color, and info window. |
| `autoCenter`   | `boolean`                      | `true`               | Automatically centers the map based on user's geolocation.                |
| `autoLocation` | `boolean`                      | `true`               | Attempts to get the user’s location upon mounting the component.          |

### Emits

| Event Name | Payload                        | Description                                                                    |
| ---------- | ------------------------------ | ------------------------------------------------------------------------------ |
| `centered` | `{ lat: number, lng: number }` | Emitted when the map center is changed.                                        |
| `zoomed`   | `number`                       | Emitted when the zoom level changes.                                           |
| `located`  | `{ lat: number, lng: number }` | Emitted when the user's location is determined.                                |
| `marked`   | `Array<TBsbMapMarker>`         | Emitted when the markers are updated.                                          |
| `clicked`  | `{ lat: number, lng: number }` | Emitted when the map is clicked, with the location of the click.               |
| `loading`  | `boolean`                      | Emitted when the component is in a loading state (e.g., fetching geolocation). |

### Methods (Exposed via `defineExpose`)

| Method Name  | Description                                                               |
| ------------ | ------------------------------------------------------------------------- |
| `getMarkers` | Returns the current array of markers.                                     |
| `setMarkers` | Updates the marker list by adding new markers.                            |
| `delMarkers` | Removes specific markers from the marker list based on their coordinates. |

### Slots

None.

### Types

```ts
export type TBsbMapMarker = {
  lat: number
  lng: number
  title?: string
  color?: string
  info?: string
}
```

## Source

1. Install Dependencies

```ps
npm install @types/google.maps
npm install vue3-google-map
```

2. Add Google API Key to `/.env.production` and `/.env.development.local`

```ini
VITE_GOOGLE_MAP_API_KEY = 'YOUR_GOOGLE_MAP_API_KEY'
```

3. Create component and unit test.

:::details Component `@/components/VBsbMap.vue`
<<< @../../src/components/VBsbMap.vue
:::

:::details Test `@/components/__tests__/VBsbMap.test.ts`

<!-- prettier-ignore -->
<<< @../../src/components/__tests__/VBsbMap.test.ts
:::
