<template>
  <v-app>
    <v-navigation-drawer v-model="drawer" app>
      <v-list>
        <v-list-item
          v-for="page in app.navigation.pages"
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
      <v-menu v-if="mobile">
        <template #activator="{ props }">
          <v-btn icon v-bind="props">
            <v-icon :icon="'$mdiDotsVertical'"></v-icon>
          </v-btn>
        </template>
        <v-list>
          <v-list-item>
            <v-menu>
              <template #activator="{ props }">
                <v-btn variant="text" v-bind="props" prepend-icon="$mdiEyePlusOutline"></v-btn>
              </template>
              <v-list>
                <v-list-item v-for="(item, i) in app.settings.fontSizes" :key="i" :value="i">
                  <v-list-item-title @click="app.settings.setFontSize(item)"
                    >{{ item }}%</v-list-item-title
                  >
                </v-list-item>
              </v-list>
            </v-menu>
          </v-list-item>
          <v-list-item>
            <v-menu>
              <template #activator="{ props }">
                <v-btn variant="text" v-bind="props">{{ app.settings.locale }}</v-btn>
              </template>
              <v-list>
                <v-list-item v-for="(item, i) in app.settings.locales" :key="i" :value="i">
                  <v-list-item-title @click="app.settings.setLocale(item)">{{
                    item
                  }}</v-list-item-title>
                </v-list-item>
              </v-list>
            </v-menu>
          </v-list-item>
          <v-list-item>
            <v-btn
              variant="text"
              :prepend-icon="app.settings.themeIcon"
              @click="app.settings.themeToggle()"
            ></v-btn>
          </v-list-item>
        </v-list>
      </v-menu>
      <v-menu v-if="!mobile">
        <template #activator="{ props }">
          <v-btn variant="text" v-bind="props" prepend-icon="$mdiEyePlusOutline"></v-btn>
        </template>
        <v-list>
          <v-list-item v-for="(item, i) in app.settings.fontSizes" :key="i" :value="i">
            <v-list-item-title @click="app.settings.setFontSize(item)"
              >{{ item }}%</v-list-item-title
            >
          </v-list-item>
        </v-list>
      </v-menu>
      <v-menu v-if="!mobile">
        <template #activator="{ props }">
          <v-btn variant="text" v-bind="props">{{ app.settings.locale }}</v-btn>
        </template>
        <v-list>
          <v-list-item v-for="(item, i) in app.settings.locales" :key="i" :value="i">
            <v-list-item-title @click="app.settings.setLocale(item)">{{ item }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
      <v-btn
        v-if="!mobile"
        variant="text"
        :prepend-icon="app.settings.themeIcon"
        @click="app.settings.themeToggle()"
      ></v-btn>
    </v-app-bar>
    <v-main class="ma-4">
      <v-breadcrumbs :items="app.navigation.breadcrumbs">
        <template v-slot:title="{ item, index }">
          <v-breadcrumbs-item
            v-if="index !== app.navigation.breadcrumbs.length - 1"
            :to="item.href"
          >
            {{ item.title }}
          </v-breadcrumbs-item>
          <v-breadcrumbs-item v-else>{{ item.title }}</v-breadcrumbs-item>
        </template>
      </v-breadcrumbs>
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
const { mobile } = useDisplay()
const app = useAppStore()
onMounted(() => {
  app.init()
})
</script>
