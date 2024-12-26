<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" :md="4">
        <h1 class="mb-4">{{ t('Signup') }}</h1>
        <v-bsb-form :options :data @submit="submit" />
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

const options = {
  fields: [
    {
      type: 'text',
      name: 'username',
      label: 'Username',
      placeholder: 'Username',
      rules: [
        { type: 'required', value: true, message: 'Username is required' },
        { type: 'email', value: true, message: 'Username must be a valid e-mail address' },
      ],
    },
    {
      type: 'text',
      name: 'fullname',
      label: 'Fullname',
      placeholder: 'Fullname',
      rules: [{ type: 'required', value: true, message: 'Fullname is required' }],
    },
    {
      type: 'password',
      name: 'password',
      label: 'Password',
      placeholder: 'Password',
      rules: [{ type: 'required', value: true, message: 'Password is required' }],
    },
    {
      type: 'password',
      name: 'password2',
      label: 'Password (repeat)',
      placeholder: 'Password (repeat)',
      rules: [
        { type: 'required', value: true, message: 'Password is required' },
        { type: 'same-as', value: 'password', message: 'Passwords must match' },
      ],
    },
  ],
  actions: [
    {
      type: 'submit',
      title: 'Signup',
      color: 'primary',
    },
  ],
  actionsAlign: 'right',
  actionsClass: 'ml-2',
}

const data = ref({
  username: '',
  fullname: '',
  password: '',
  password2: '',
})

const submit = async (newData: typeof data.value) => {
  if (await appStore.auth.signup(newData.username, newData.password, newData.fullname))
    router.push((route.query.redirect as string) || '/')
}
</script>

<i18n scope="global">
{
  "en": {
    "Signup": "Signup",
    "Username": "User name",
    "Username is required": "Username is required",
    "Username must be a valid e-mail address": "Username must be a valid e-mail address",
    "Fullname": "Full name",
    "Fullname is required": "Full name is required",
    "Password": "Password",
    "Password (repeat)": "Password (repeat)",
    "Password is required": "Password is required",
    "Passwords must match": "Passwords must match",
    "Submit": "Sign up",
    "Such username already exists": "Such username already exists"
  },
  "fr": {
    "Signup": "Inscription",
    "Username": "Nom d'utilisateur",
    "Username is required": "Le nom d'utilisateur est requis",
    "Username must be a valid e-mail address": "Le nom d'utilisateur doit être une adresse e-mail valide",
    "Fullname": "Nom complet",
    "Fullname is required": "Le nom complet est requis",
    "Password": "Mot de passe",
    "Password (repeat)": "Mot de passe (répéter)",
    "Password is required": "Le mot de passe est requis",
    "Passwords must match": "Les mots de passe doivent correspondre",
    "Submit": "S'inscrire",
    "Such username already exists": "Un tel nom d'utilisateur existe déjà"
  }
}
</i18n>
