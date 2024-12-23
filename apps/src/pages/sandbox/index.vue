<template>
  <v-card :style="useCardBackground('#00AA00')">
    <v-card-title><v-icon icon="$mdiHome" />Title</v-card-title>
    <v-card-text>Content</v-card-text>
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

const theme = useTheme()

function toggleTheme() {
  theme.global.name.value = theme.global.current.value.dark ? 'light' : 'dark'
}
</script>
