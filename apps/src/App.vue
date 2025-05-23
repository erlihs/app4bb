<template>
  <v-app>
    <v-navigation-drawer v-model="drawer" app>
      <v-container>
        <v-row>
          <v-col cols="4">
            <v-img
              eager
              class="rounded-lg border-thin"
              alt="Bullshit Bingo"
              src="/logo.svg"
              aspect-ratio="1/1"
            >
              <div
                class="fill-height"
                :class="app.settings.theme == 'dark' ? 'dark-image' : ''"
              ></div>
            </v-img>
          </v-col>
        </v-row>
      </v-container>
      <v-divider />
      <v-list>
        <v-list-item
          v-for="page in app.navigation.pages"
          :key="page.path"
          :prepend-icon="page.icon || '$mdiMinus'"
          :to="page.path"
        >
          <v-list-item-title>{{ page.title }}</v-list-item-title>
        </v-list-item>
      </v-list>
      <v-divider />
      <v-list>
        <v-list-item href="https://wiki.bsbingo.me" target="_blank">
          <v-list-item-title>Wiki</v-list-item-title>
          <template #prepend>
            <v-icon icon="$mdiOpenInNew"></v-icon>
          </template>
        </v-list-item>
      </v-list>
      <v-divider v-if="app.auth.isAuthenticated" />
      <v-list v-if="app.auth.isAuthenticated">
        <v-list-item>
          {{ t('welcome') }}, <br />
          <strong>{{ app.auth.user?.fullname }}</strong>
        </v-list-item>
        <v-list-item @click="app.auth.logout()">
          <template #prepend>
            <v-icon icon="$mdiLogout"></v-icon>
          </template>
          <v-list-item-title>{{ t('logout') }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>Bullshit Bingo</v-toolbar-title>
      <v-btn v-show="!app.auth.isAuthenticated" to="/login" class="mr-2">
        <v-icon icon="$mdiAccount"></v-icon>
        {{ t('login') }}
      </v-btn>
      <v-btn v-show="app.auth.isAuthenticated" @click="app.auth.logout()" class="mr-2">
        <v-icon icon="$mdiLogout"></v-icon>
        {{ t('logout') }}
      </v-btn>
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
      <v-progress-linear
        :active="app.ui.loading"
        indeterminate
        absolute
        location="bottom"
        height="6"
      ></v-progress-linear>
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
      <v-alert
        type="info"
        :text="app.ui.info ? t(app.ui.info) : ''"
        v-show="app.ui.info.length > 0"
        class="mb-2"
      ></v-alert>
      <v-alert
        type="warning"
        :text="app.ui.warning ? t(app.ui.warning) : ''"
        v-show="app.ui.warning.length > 0"
        class="mb-2"
      ></v-alert>
      <v-alert
        type="error"
        :text="app.ui.error ? t(app.ui.error) : ''"
        v-show="app.ui.error.length > 0"
        class="mb-2"
      ></v-alert>
      <router-view />
      <v-snackbar v-model="app.ui.snackbar">
        {{ t(app.ui.snack) }}
        <template v-slot:actions>
          <v-btn color="pink" variant="text" @click="app.ui.snack = ''">
            {{ t('close') }}
          </v-btn>
        </template>
      </v-snackbar>
      <v-snackbar v-model="refresh" multi-line vertical>
        New version is available, click OK to upgrade now.
        <template v-slot:actions>
          <v-btn color="primary" variant="text" @click="updateServiceWorker()"> Ok </v-btn>
          <v-btn color="secondary" variant="text" @click="refresh = false"> Cancel </v-btn>
        </template>
      </v-snackbar>
      <v-overlay v-model="app.ui.loading" contained></v-overlay>
    </v-main>
    <v-footer app>
      <v-row>
        <v-col>
          {{ app.version }}
          <v-btn
            v-if="needRefresh"
            variant="outlined"
            density="compact"
            class="ml-2"
            @click="refresh = true"
          >
            Upgrade
          </v-btn>
        </v-col>
        <v-col class="text-right">
          <v-btn
            icon
            href="https://github.com/erlihs"
            target="_blank"
            rel="noopener"
            title="GitHub"
            size="xx-small"
            color="secondary"
            variant="flat"
          >
            <v-icon icon="$mdiGithub"></v-icon>
          </v-btn>
        </v-col>
      </v-row>
    </v-footer>
  </v-app>
</template>

<script setup lang="ts">
const drawer = ref(false)
const { mobile } = useDisplay()
const app = useAppStore()
const { t } = useI18n()
onMounted(() => {
  app.init()
})

import { useRegisterSW } from 'virtual:pwa-register/vue'
const { needRefresh, updateServiceWorker } = useRegisterSW()
const refresh = ref(false)
</script>

<style>
.dark-image {
  background-color: black;
  opacity: 0.6;
}
</style>
