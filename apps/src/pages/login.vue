<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" :md="4">
        <h1 class="mb-4">{{ t('login') }}</h1>
        <v-bsb-form :options :data @submit="submit" @action="dev" />
        <br />
        <br />
        {{ t('not.registered.yet') }} <a href="/signup">{{ t('sign.up') }}</a> |
        <a href="/recover-password">{{ t('forgot.password') }}</a>
        <br />
        <br />
        <GoogleLogin :clientId="googleClientId" :callback="callback" />
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
definePage({ meta: { role: 'guest' } })

const appStore = useAppStore()
const router = useRouter()
const route = useRoute()
const { t } = useI18n()

const devAction = import.meta.env.DEV ? ['dev'] : []

const options = <BsbFormOptions>{
  fields: [
    {
      type: 'text',
      name: 'username',
      label: 'username',
      placeholder: 'username',
      rules: [
        { type: 'required', params: true, message: 'username.is.required' },
        { type: 'email', params: true, message: 'username.must.be.a.valid.email.address' },
      ],
    },
    {
      type: 'password',
      name: 'password',
      label: 'password',
      placeholder: 'password',
      rules: [{ type: 'required', params: true, message: 'password.is.required' }],
    },
  ],
  actions: ['submit', ...devAction],
  actionAlign: 'right',
  actionSubmit: 'submit',
}

const data = ref({
  username: '',
  password: '',
})

const submit = async (newData: typeof data.value) => {
  if (await appStore.auth.login(newData.username, newData.password))
    router.push((route.query.redirect as string) || '/')
}

import { GoogleLogin } from 'vue3-google-login'
const googleClientId = import.meta.env.VITE_GOOGLE_CLIENT_ID
import { decodeCredential, type CallbackTypes } from 'vue3-google-login'

const callback = async (response: CallbackTypes.CredentialPopupResponse) => {
  const userData = decodeCredential(response.credential) as {
    email: string
    sub: string
    name: string
  }
  if (await appStore.auth.signupSocial(userData.email, userData.sub, userData.name))
    router.push((route.query.redirect as string) || '/')
}

const dev = async () => {
  data.value = {
    username: import.meta.env.VITE_USERNAME,
    password: import.meta.env.VITE_PASSWORD,
  }
}
</script>
