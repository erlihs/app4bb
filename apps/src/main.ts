import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'
import vuetify from './plugins/vuetify'
import i18n from './plugins/i18n'
import { createPiniaLocalStoragePlugin } from './plugins/pinia'
import { createHead } from '@unhead/vue'
import { errorHandler } from './plugins/errors'

const app = createApp(App)
app.config.errorHandler = errorHandler

app.use(createPinia().use(createPiniaLocalStoragePlugin()))
app.use(router)
app.use(vuetify)
app.use(i18n)

app.mount('#app')
app.use(createHead())
