<template>
  <h1>Home</h1>
  <v-row>
    <v-col
      cols="12"
      md="4"
      v-for="page in navigation.pages.filter((page) => page.path !== '/')"
      :key="page.path"
    >
      <v-card
        min-height="8em"
        :style="cardBackground(page.color)"
        :prepend-icon="page.icon"
        :title="page.title"
        :to="page.path"
        :text="page.description"
      >
      </v-card>
    </v-col>
  </v-row>
</template>

<script setup lang="ts">
definePage({
  meta: {
    title: 'Welcome Home',
    description: 'Welcome to the home page',
    icon: '$mdiHome',
    color: '#ABCDEF',
  },
})
const navigation = useNavigationStore()
const cardBackground = useCardBackground
</script>
