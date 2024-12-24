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
  </v-card>
</template>

<script setup lang="ts">
const cardBackground = useCardBackground
const { t } = useI18n()
const settings = useSettingsStore()
onMounted(() => {
  settings.init()
})
</script>
