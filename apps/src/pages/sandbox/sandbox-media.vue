<template>
  <v-row>
    <v-col>
      PLAYBACK VIDEO:
      <v-bsb-media
        video
        :autoplay="false"
        snap
        format="blob"
        src="https://lachy.id.au/dev/markup/examples/video/bus.mp4"
      />
    </v-col>
    <v-col>
      RECORD VIDEO:
      <v-bsb-media
        video
        @loading="cameraLoading"
        @device="cameraDevice"
        @started="cameraStarted"
        @paused="cameraPaused"
        @resumed="cameraResumed"
        @stopped="cameraStopped"
        @snapped="cameraSnapped"
        @recorded="cameraRecorded"
        @error="cameraError"
      />
    </v-col>
    <v-col>
      TAKE A SNAP:
      <v-bsb-media
        video
        snap
        format="blob"
        @loading="cameraLoading"
        @device="cameraDevice"
        @started="cameraStarted"
        @paused="cameraPaused"
        @resumed="cameraResumed"
        @stopped="cameraStopped"
        @snapped="cameraSnapped"
        @recorded="cameraRecorded"
        @error="cameraError"
      />
    </v-col>
  </v-row>
  <v-row>
    <v-col>
      PLAYBACK AUDIO FULL:
      <v-bsb-media
        audio
        :autoplay="false"
        src="https://onlinetestcase.com/wp-content/uploads/2023/06/100-KB-MP3.mp3"
        @loading="cameraLoading"
        @device="cameraDevice"
        @started="cameraStarted"
        @paused="cameraPaused"
        @resumed="cameraResumed"
        @stopped="cameraStopped"
        @snapped="cameraSnapped"
        @recorded="cameraRecorded"
        @error="cameraError"
      />
    </v-col>
    <v-col>
      PLAYBACK AUDIO COMPACT:
      <v-bsb-media
        class="mt-4"
        audio
        compact
        :autoplay="false"
        variant="outlined"
        density="compact"
        src="https://onlinetestcase.com/wp-content/uploads/2023/06/100-KB-MP3.mp3"
        @loading="cameraLoading"
        @device="cameraDevice"
        @started="cameraStarted"
        @paused="cameraPaused"
        @resumed="cameraResumed"
        @stopped="cameraStopped"
        @snapped="cameraSnapped"
        @recorded="cameraRecorded"
        @error="cameraError"
      />
    </v-col>
    <v-col>
      RECORD AUDIO FULL:
      <v-bsb-media
        audio
        @loading="cameraLoading"
        @device="cameraDevice"
        @started="cameraStarted"
        @paused="cameraPaused"
        @resumed="cameraResumed"
        @stopped="cameraStopped"
        @snapped="cameraSnapped"
        @recorded="cameraRecorded"
        @error="cameraError"
      />
    </v-col>
    <v-col>
      RECORD AUDIO COMPACT:
      <v-bsb-media
        audio
        compact
        @loading="cameraLoading"
        @device="cameraDevice"
        @started="cameraStarted"
        @paused="cameraPaused"
        @resumed="cameraResumed"
        @stopped="cameraStopped"
        @snapped="cameraSnapped"
        @recorded="cameraRecorded"
        @error="cameraError"
      />
    </v-col>
  </v-row>
</template>

<script setup lang="ts">
definePage({ meta: { role: 'restricted' } })
function cameraLoading(loading: boolean) {
  console.log('camera loading', loading)
}

async function cameraDevice(deviceInfo: unknown) {
  console.log('Camera change of device', deviceInfo)
}

function cameraStarted(deviceInfo: unknown) {
  console.log('camera started', deviceInfo)
}

function cameraPaused() {
  console.log('camera paused')
}

function cameraResumed() {
  console.log('camera resumed')
}

function cameraStopped() {
  console.log('camera stopped')
}

async function cameraSnapped(snap: Blob) {
  console.log('Camera sanp', snap)
  const url = URL.createObjectURL(snap)
  const a = document.createElement('a')
  a.href = url
  a.download = 'image/png'
  a.click()
  URL.revokeObjectURL(url)
}

async function cameraRecorded(video: string | Blob) {
  if (typeof video === 'string') {
    console.log('Camera recorded base64', video)
  } else {
    console.log('Camera recorded blob', video)
    const url = URL.createObjectURL(video)
    const a = document.createElement('a')
    a.href = url
    a.download = 'recording.webm' // You can download the video as a WebM file
    a.click()
    URL.revokeObjectURL(url)
  }
}
/*
async function cameraRecordedBlob(blob: Blob) {
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = 'recording.webm' // You can download the video as a WebM file
  a.click()
  URL.revokeObjectURL(url)
}
*/
function cameraError(error: Error) {
  console.log('camera error', error)
}
</script>
