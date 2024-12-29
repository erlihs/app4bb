<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" :md="4">
        <h1 class="mb-4">{{ t('reset.password') }}</h1>
        <v-bsb-form v-if="!done" :options :data @submit="submit" @action="dev" />
        <v-btn v-if="done" @click="router.push('/')" class="mt-4">{{ t('continue') }}</v-btn>
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

const done = ref(false)

const devAction = import.meta.env.DEV
  ? [
      {
        type: 'dev',
        title: 'Dev',
        variant: 'outlined',
      },
    ]
  : []
const options = {
  fields: [
    {
      type: 'text',
      name: 'username',
      label: 'username',
      placeholder: 'username',
      rules: [
        { type: 'required', value: true, message: 'username.is.required' },
        { type: 'email', value: true, message: 'username.must.be.a.valid.e-mail.address' },
      ],
    },
    {
      type: 'password',
      name: 'password',
      label: 'password',
      placeholder: 'password',
      rules: [{ type: 'required', value: true, message: 'password.is.required' }],
    },
    {
      type: 'password',
      name: 'password2',
      label: 'password.repeat',
      placeholder: 'password.repeat',
      rules: [
        { type: 'required', value: true, message: 'password.is.required' },
        { type: 'same-as', value: 'password', message: 'passwords.must.match' },
      ],
    },
  ],
  actions: [
    {
      type: 'submit',
      title: 'reset.password',
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
  password2: '',
})

const submit = async (newData: typeof data.value) => {
  const recoverToken = (route.params as { token: string }).token
  done.value = await appStore.auth.resetPassword(newData.username, newData.password, recoverToken)
}

const dev = async () => {
  data.value = {
    username: import.meta.env.VITE_USERNAME,
    password: import.meta.env.VITE_PASSWORD,
    password2: import.meta.env.VITE_PASSWORD,
  }
}
</script>

<i18n>
{
  "en": {
    "Reset password": "Reset password",
    "Username": "Username",
    "Username is required": "Username is required",
    "Username must be a valid e-mail address": "Username must be a valid e-mail address",
    "Password": "Password",
    "Password (repeat)": "Password (repeat)",
    "Password is required": "Password is required",
    "Passwords must match": "Passwords must match",
    "Continue": "Continue"
  },
  "fr": {
    "Reset password": "Réinitialiser le mot de passe",
    "Username": "Nom d'utilisateur",
    "Username is required": "Le nom d'utilisateur est requis",
    "Username must be a valid e-mail address": "Le nom d'utilisateur doit être une adresse e-mail valide",
    "Password": "Mot de passe",
    "Password (repeat)": "Mot de passe (répéter)",
    "Password is required": "Le mot de passe est requis",
    "Passwords must match": "Les mots de passe doivent correspondre",
    "Continue": "Continuer"
  }
}
</i18n>
