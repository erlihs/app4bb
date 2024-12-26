# Media

## Overview

**VBsbMedia** component provides a robust interface for playback and recording of video and audio. It allows recording video and audio streams, taking snapshots from the video feed, and playing back recorded media. The component is highly customizable and supports various configurations such as auto-play, looping, compact mode, and control positioning. The component is compatible with Vuetify and leverages Vuetify's UI components.

## Source

:::details Component
<<< @../../src/components/VBsbMedia.vue
:::

:::details Test

<!-- prettier-ignore -->
<<< @../../src/components/__tests__/VBsbMedia.test.ts
:::

## Usage

### Basic Example: Video Recorder

```vue
<template>
  <MediaCapture
    :video="true"
    :autoplay="true"
    :loop="false"
    :snap="true"
    snapIcon="$mdiCamera"
    @snapped="handleSnapshot"
    @recorded="handleRecording"
    :videoConstraints="{ width: 1280, height: 720 }"
  />
</template>

<script setup>
import MediaCapture from '@/components/MediaCapture.vue'

function handleSnapshot(image) {
  console.log('Snapshot captured:', image)
}

function handleRecording(recordedData) {
  console.log('Recording completed:', recordedData)
}
</script>
```

### Audio Player Example

```vue
<template>
  <MediaCapture
    :audio="true"
    :src="'/path/to/audio-file.mp3'"
    :compact="true"
    @error="handleError"
  />
</template>

<script setup>
import MediaCapture from '@/components/MediaCapture.vue'

function handleError(err) {
  console.error('Error:', err.message)
}
</script>
```

### Snapshot and Record Example with Custom Constraints

```vue
<template>
  <MediaCapture
    :video="true"
    :audio="true"
    :snap="true"
    :snapPosition="'top-left'"
    :recorderPosition="'bottom-right'"
    @snapped="handleSnapshot"
    @recorded="handleRecording"
    :videoConstraints="{ width: 1920, height: 1080 }"
    :audioConstraints="{ sampleRate: 44100 }"
  />
</template>

<script setup>
import MediaCapture from '@/components/MediaCapture.vue'

function handleSnapshot(image) {
  console.log('Snapshot captured:', image)
}

function handleRecording(recordedData) {
  console.log('Recording saved:', recordedData)
}
</script>
```

---

## API

### Props

| Prop               | Type                                                                                    | Default         | Description                                                                                                  |
| ------------------ | --------------------------------------------------------------------------------------- | --------------- | ------------------------------------------------------------------------------------------------------------ |
| `src`              | `String`                                                                                | `null`          | The source URL of the media (either video or audio). If provided, the media will be loaded from this source. |
| `autoplay`         | `Boolean`                                                                               | `true`          | Automatically start the video or audio upon component load.                                                  |
| `loop`             | `Boolean`                                                                               | `false`         | Loop the media playback when it ends.                                                                        |
| `video`            | `Boolean`                                                                               | `false`         | Enable video recording or playback.                                                                          |
| `audio`            | `Boolean`                                                                               | `false`         | Enable audio recording or playback.                                                                          |
| `recorderPosition` | `String` (one of: `'top-left'`, `'top-right'`, `'bottom-left'`, `'bottom-right'`)       | `'bottom-left'` | Position of the recording control button.                                                                    |
| `snap`             | `Boolean`                                                                               | `false`         | Show a snapshot button to capture an image from the video stream.                                            |
| `snapPosition`     | `String` (one of: `'top-left'`, `'top-right'`, `'bottom-left'`, `'bottom-right'`)       | `'top-right'`   | Position of the snapshot button.                                                                             |
| `snapIcon`         | `String`                                                                                | `'$mdiCamera'`  | Icon for the snapshot button.                                                                                |
| `format`           | `String` (one of: `'base64'`, `'blob'`)                                                 | `'base64'`      | Format of the snapshot or recording output. Either Base64-encoded string or a Blob object.                   |
| `videoConstraints` | `Object`                                                                                | `{}`            | Custom video constraints for the camera (e.g., resolution, aspect ratio).                                    |
| `audioConstraints` | `Object`                                                                                | `{}`            | Custom audio constraints for the microphone (e.g., sample rate, channel count).                              |
| `compact`          | `Boolean`                                                                               | `false`         | Whether to show a compact version of the controls (e.g., for audio playback).                                |
| `variant`          | `String` (one of: `'outlined'`, `'flat'`, `'text'`, `'elevated'`, `'tonal'`, `'plain'`) | `'flat'`        | Visual style for the buttons.                                                                                |
| `density`          | `String` (one of: `'default'`, `'comfortable'`, `'compact'`)                            | `'default'`     | Density of the buttons (spacing and size).                                                                   |

### Events

| Event      | Payload                                          | Description                                                             |
| ---------- | ------------------------------------------------ | ----------------------------------------------------------------------- |
| `loading`  | `Boolean`                                        | Emitted when the component is starting or stopping media devices.       |
| `device`   | `{ devices: MediaDeviceInfo[], device: string }` | Emitted when media devices are selected.                                |
| `started`  | `{ video: string, audio: string }`               | Emitted when media capture (video/audio) starts.                        |
| `paused`   | `None`                                           | Emitted when the media recording or playback is paused.                 |
| `resumed`  | `None`                                           | Emitted when media playback or recording is resumed after being paused. |
| `stopped`  | `None`                                           | Emitted when media capture (video/audio) stops.                         |
| `snapped`  | `String` (Base64) / `Blob`                       | Emitted when a snapshot is captured from the video.                     |
| `recorded` | `String` (Base64) / `Blob`                       | Emitted when video recording finishes.                                  |
| `error`    | `Error`                                          | Emitted if an error occurs (e.g., camera or microphone access failure). |

### Methods

- **`listDevices()`**  
  Returns a list of available media devices (video and audio input devices).

- **`setDevice(newDeviceId: string)`**  
  Manually set the video or audio device by device ID.

### Slots

- **`default`**  
  Custom content to be displayed inside the component (can be used to add additional controls or display).
