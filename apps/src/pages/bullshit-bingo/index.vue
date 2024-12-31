<template>
  <v-row align="center">
    <v-col></v-col>
    <v-col cols="12" xs="12" sm="6" md="4" lg="4" xl="4">
      <h1 class="mb-6">Join Bullshit Bingo</h1>

      <v-alert closable type="error" :text="error" v-show="error.length > 0" class="mb-2"></v-alert>

      <v-form ref="joinForm" @submit.prevent="join">
        <v-text-field
          v-model="data.gamecode"
          label="Game code"
          required
          :rules="rules.gamecode"
        ></v-text-field>
        <v-text-field
          v-model="data.fullname"
          label="Your name"
          required
          :rules="rules.fullname"
        ></v-text-field>

        <v-btn block type="submit">Join</v-btn>
      </v-form>

      <br />
      <v-btn variant="outlined" block @click="deal">Dealer</v-btn>

      <v-overlay v-model="loading"></v-overlay>
    </v-col>
    <v-col></v-col>
  </v-row>
</template>

<script setup lang="ts">
definePage({
  meta: {
    title: 'Bullshit Bingo',
    description: 'Join the Bullshit Bingo game',
    color: '#E1BEE7',
    icon: '$mdiBullhorn',
    role: 'public',
  },
})

import { ref, onMounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useBullshitBingoStore } from '@/pages/bullshit-bingo/store'

const router = useRouter()
const route = useRoute()

const store = useBullshitBingoStore()

const loading = ref(false)

const joinForm = ref(null)

const rules = {
  gamecode: [(v: unknown) => !!v || 'Game code is required'],
  fullname: [(v: unknown) => !!v || 'Your name is required'],
}

const data = ref({
  gamecode: '',
  fullname: '',
})

const error = computed(() => store.play.error || '')

onMounted(async () => {
  const play = await store.init()
  data.value.gamecode = (route.query.gamecode as string) || '' //route.params?.gamecode as string
  if (!data.value.gamecode) data.value.gamecode = play.gamecode
  data.value.fullname = play.fullname || store.dealer.fullname
})

async function join() {
  if (joinForm.value) {
    const result = await (
      joinForm.value as unknown & { validate: () => { valid: boolean } }
    ).validate()
    if (result.valid) {
      loading.value = true
      const hasJoined = await store.join(data.value.gamecode, data.value.fullname)
      if (hasJoined) router.push('/bullshit-bingo/player')
      loading.value = false
    }
  }
}

function deal() {
  loading.value = true
  router.push('/bullshit-bingo/dealer')
}
</script>
