<template>
  <v-container>
    <h1 class="mb-8">{{ meta.title }}</h1>
    <v-row
      ><v-col>
        <v-card
          :style="cardBackground(meta.color)"
          :prepend-icon="meta.icon"
          :color="meta.color"
          :title="meta.description"
        >
          <v-card-text class="border-s-lg ma-4">
            <p>{{ joke }}</p>
          </v-card-text>
          <v-card-actions>
            <v-bsb-share variant="tonal" :share-options="shareOptions" />
            <v-spacer />
            <v-btn variant="flat" @click="fetchJoke">{{ t('get.a.joke') }}</v-btn>
          </v-card-actions>
          <v-overlay v-model="loading" persistent contained />
        </v-card> </v-col
    ></v-row>
  </v-container>
</template>

<script setup lang="ts">
definePage({
  meta: {
    role: 'public',
    title: 'Chuck Norris',
    icon: '$mdiAccountCowboyHat',
    color: '#D7CCC8',
    description: 'Chuck Norris - Random Joke of the Day',
  },
})
const http = useHttp({ baseURL: 'https://api.chucknorris.io' })
const { t } = useI18n()
const cardBackground = useCardBackground

const meta = useRoute().meta as { icon: string; color: string; description: string; title: string }
const shareOptions = ref({
  url: 'https://apps.bsbingo.me/chuck-norris',
  text: '...',
  hashtags: ['chucknorris'],
})

const joke = ref('')
const loading = ref(false)

const fetchJoke = async () => {
  loading.value = true
  const { data } = (await http.get('/jokes/random')) as { data: { value: string } }
  if (data.value) {
    joke.value = data.value
    shareOptions.value.text = data.value
  }
  loading.value = false
}

onMounted(() => {
  fetchJoke()
})
</script>
