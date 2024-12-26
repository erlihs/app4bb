<template>
  <v-card :style="cardBackground('#00AA00')">
    <v-card-title><v-icon icon="$mdiHome" />{{ t('sandbox.title') }}</v-card-title>
    <v-card-text>{{ t('sandbox.content') }}</v-card-text>
    <v-card-text>{{ t('sandbox.missing') }}</v-card-text>
    <v-card-actions>
      <v-btn color="primary">Primary</v-btn>
      <v-btn color="secondary">Secondary</v-btn>
      <v-spacer></v-spacer>
      <v-btn :prepend-icon="settings.themeIcon" @click="settings.themeToggle()">Toggle theme</v-btn>
      <v-btn @click="heartbeat()">Heartbeat: {{ responseStatus }}</v-btn>
    </v-card-actions>
    <v-card-actions>
      <v-btn color="info" @click="ui.setInfo('This is info')">Info</v-btn>
      <v-btn color="warning" @click="ui.setWarning('This is warning')">Warning</v-btn>
      <v-btn color="error" @click="ui.setError('This is error')">Error</v-btn>
      <v-btn class="ml-4" @click="ui.setSnack('This is a snack message')">Snack</v-btn>
      <v-spacer></v-spacer>
      <v-btn v-if="!ui.loading" @click="ui.startLoading()">Loading</v-btn>
      <v-btn v-else @click="ui.stopLoading()">Loading</v-btn>
    </v-card-actions>
  </v-card>

  <v-container fluid>
    <h1 class="mb-4">Components</h1>
    <v-row>
      <v-col cols="12" md="6" lg="4" v-for="comp in compontents" :key="comp.to">
        <v-card :to="comp.to">
          <v-card-title><v-icon :icon="comp.icon" />{{ comp.text }}</v-card-title>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
const cardBackground = useCardBackground
const { t } = useI18n()
const settings = useSettingsStore()
const ui = useUiStore()
const compontents = ref([
  { icon: '$mdiChartLine', to: '/sandbox/sandbox-chart', text: 'Chart' },
  { icon: '$mdiPen', to: '/sandbox/sandbox-editor', text: 'Editor' },
  { icon: '$mdiMap', to: '/sandbox/sandbox-map', text: 'Map' },
  { icon: '$mdiWebcam', to: '/sandbox/sandbox-media', text: 'Media' },
  { icon: '$mdiFormTextarea', to: '/sandbox/sandbox-form', text: 'Form' },
  { icon: '$mdiDraw', to: '/sandbox/sandbox-pad', text: 'Pad' },
  { icon: '$mdiTable', to: '/sandbox/sandbox-table', text: 'Table' },
  { icon: '$mdiShare', to: '/sandbox/sandbox-share', text: 'Share' },
])

import { appApi } from '@/api'
const responseStatus = ref(200)
async function heartbeat() {
  responseStatus.value = (await appApi.heartbeat()).status ?? 200
}
</script>
