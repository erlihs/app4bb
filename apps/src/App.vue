<template>
  <v-app>
    <v-navigation-drawer v-model="drawer" app>
      <v-list>
        <v-list-item
          v-for="page in pages"
          :key="page.path"
          :prepend-icon="page.icon"
          :to="page.path"
        >
          <v-list-item-title>{{ page.title }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>Bullshit Bingo</v-toolbar-title>
    </v-app-bar>
    <v-main class="ma-4">
      <router-view />
    </v-main>
    <v-footer app>
      <v-row>
        <v-col> v0.3 </v-col>
      </v-row>
    </v-footer>
  </v-app>
</template>

<script setup lang="ts">
const drawer = ref(false)
const pages = ref([
  { title: 'Home', icon: '$mdiHome', path: '/' },
  { title: 'About', icon: '$mdiInformation', path: '/about' },
  { title: 'Sandbox', icon: '$mdiCog', path: '/sandbox' },
])
</script>
