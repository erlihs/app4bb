<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" :md="4">
        <h1 class="mb-4">{{ t('app.login.title') }}</h1>
        <v-bsb-form :options :data @submit="submit" @action="dev" />
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

const devAction = import.meta.env.DEV
  ? [
      {
        type: 'dev',
        title: 'app.login.dev',
        variant: 'outlined',
      },
    ]
  : []

const options = {
  fields: [
    {
      type: 'text',
      name: 'username',
      label: 'app.login.username.label',
      placeholder: 'app.login.username.placeholder',
      rules: [
        { type: 'required', value: true, message: 'app.login.username.required' },
        { type: 'email', value: true, message: 'app.login.username.invalid_email' },
      ],
    },
    {
      type: 'password',
      name: 'password',
      label: 'app.login.password.label',
      placeholder: 'app.login.password.placeholder',
      rules: [{ type: 'required', value: true, message: 'app.login.password.required' }],
    },
  ],
  actions: [
    {
      type: 'submit',
      title: 'app.login.submit',
      color: 'primary',
    },
    ...devAction,
  ],
  actionsAlign: 'right',
  actionsClass: 'ml-2',
}

const data = ref({
  username: '',
  password: '',
})

const submit = async (newData: typeof data.value) => {
  if (await appStore.auth.login(newData.username, newData.password))
    router.push((route.query.redirect as string) || '/')
}

const dev = async () => {
  data.value = {
    username: import.meta.env.VITE_USERNAME,
    password: import.meta.env.VITE_PASSWORD,
  }
}
</script>
