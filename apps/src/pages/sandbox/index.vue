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
</template>

<script setup lang="ts">
const cardBackground = useCardBackground
const { t } = useI18n()
const settings = useSettingsStore()
const ui = useUiStore()
</script>
