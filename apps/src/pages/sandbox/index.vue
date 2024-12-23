<template>
  <v-card :style="useCardBackground('#00AA00')">
    <v-card-title><v-icon icon="$mdiHome" />{{ t('sandbox.title') }}</v-card-title>
    <v-card-text>{{ t('sandbox.content') }}</v-card-text>
    <v-card-text>{{ t('sandbox.missing') }}</v-card-text>
    <v-card-actions>
      <v-btn color="primary">Primary</v-btn>
      <v-btn color="secondary">Secondary</v-btn>
      <v-spacer></v-spacer>
      <v-btn @click="toggleTheme()">Toggle theme</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script setup lang="ts">
import { useTheme } from 'vuetify'
import { useCardBackground } from '@/composables/ui'
import { useI18n } from 'vue-i18n'
const { t } = useI18n()

const theme = useTheme()

function toggleTheme() {
  theme.global.name.value = theme.global.current.value.dark ? 'light' : 'dark'
}
</script>
