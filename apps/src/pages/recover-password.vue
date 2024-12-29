<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" :md="4">
        <h1 class="mb-4">{{ t('recover.password') }}</h1>
        <v-bsb-form v-if="!sent" :options :data @submit="submit" />
        <v-btn v-if="sent" @click="router.push('/')" class="mt-4">{{ t('ok') }}</v-btn>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
definePage({ meta: { role: 'guest' } })

const appStore = useAppStore()
const router = useRouter()
const { t } = useI18n()

const sent = ref(false)

const options = {
  fields: [
    {
      type: 'text',
      name: 'username',
      label: 'Username',
      placeholder: 'Username',
      rules: [
        { type: 'required', value: true, message: 'username.is.required' },
        { type: 'email', value: true, message: 'username.must.be.a.valid.e-mail.address' },
      ],
    },
  ],
  actions: [
    {
      type: 'submit',
      title: 'send',
      color: 'primary',
    },
  ],
  actionsAlign: 'right',
  actionsClass: 'ml-2',
}

const data = ref({
  username: '',
})

const submit = async (newData: typeof data.value) => {
  sent.value = await appStore.auth.recoverPassword(newData.username)
}
</script>

<i18n scope="global">
{
  "en": {
    "Recover password": "Recover password",
    "Username": "Username",
    "Username is required": "Username is required",
    "Username must be a valid e-mail address": "Username must be a valid e-mail address",
    "Submit": "Send",
    "Ok": "Ok"
  },
  "fr": {
    "Recover password": "Récupérer le mot de passe",
    "Username": "Nom d'utilisateur",
    "Username is required": "Le nom d'utilisateur est requis",
    "Username must be a valid e-mail address": "Le nom d'utilisateur doit être une adresse e-mail valide",
    "Submit": "Envoyer",
    "Ok": "Ok"
  }
}
</i18n>
