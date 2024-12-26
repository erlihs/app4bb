<template><v-bsb-share :share-options color="red" /></template>

<script setup lang="ts">
definePage({ meta: { role: 'restricted' } })
import { type ShareOptions } from '@/components/VBsbShare.vue'

const shareOptions = ref<ShareOptions>({
  url: 'https://www.google.com',
  text: 'Google',
  quote: 'Google',
  hashtags: ['google'],
  via: 'google',
  number: '+37129409327',
})
</script>
