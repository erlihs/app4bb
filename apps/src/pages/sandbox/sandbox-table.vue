<template>
  <v-bsb-table
    searchable
    :options
    :items
    @action="action"
    @beforeFetch="beforeFetch"
    @afterFetch="afterFetch"
    @submit="submit"
  ></v-bsb-table>
</template>

<script setup lang="ts">
definePage({ meta: { title: 'Sandbox Table', role: 'ADMIN' } })
function action(action: unknown) {
  console.log('action', action)
}

function beforeFetch(data: unknown) {
  console.log('beforeFetch', data)
}

function afterFetch(data: unknown) {
  console.log('afterFetch', data)
}

function submit(data: unknown) {
  console.log('submit', data)
}

function customValidation(value: unknown) {
  return (value as string).startsWith('ervin')
}

const options = ref({
  title: 'Table Title',
  columns: [
    {
      column: 'name',
      title: 'Name',
      format: [
        { condition: 'starts-with', params: 'L', color: 'red' },
        { condition: 'starts-with', params: 'E', icon: '$mdiAccount', color: 'blue' },
        {
          condition: 'starts-with',
          params: 'C',
          icon: '$mdiAccount',
          color: 'green',
          variant: 'outlined',
        },
        {
          condition: 'starts-with',
          params: 'P',
          icon: '$mdiAccount',
          color: 'yellow',
          variant: 'flat',
          text: '',
        },
      ],
    },
    {
      column: 'email',
      title: 'Email',
      format: [{ condition: 'custom', params: customValidation, color: 'blue' }],
    },
    { column: 'phone', title: 'Phone', format: { color: 'green' } },
    {
      column: 'website',
      title: 'Website',
      shorten: 30,
      format: { to: 'https://$value', target: '_blank' },
    },
    {
      actions: [
        { action: 'view', format: { text: 'View' } },
        {
          action: 'edit',
          format: { icon: '$mdiPencil' },
          form: {
            title: 'Edit',
            fields: [
              { name: 'name', label: 'Name', type: 'text' },
              { name: 'email', label: 'Email', type: 'email' },
              { name: 'phone', label: 'Phone', type: 'text' },
              { name: 'website', label: 'Website', type: 'text' },
            ],
            actions: ['cancel', 'submit'],
          },
        },
        {
          action: 'delete',
          format: { text: 'Delete', icon: '$mdiDelete', color: 'red', variant: 'flat' },
        },
      ],
    },
  ],
  actions: [{ action: 'new', format: { icon: '$mdiPlus' } }],
})

const items = ref([
  {
    name: 'Leanne Graham',
    email: 'leanne.graham@example.com',
    phone: '118-332-6675 x95515',
    website:
      'lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-simone.org',
  },
  {
    name: 'Ervin Howell',
    email: 'ervin.howell@myemail.com',
    phone: '928-310-8872 x91857',
    website:
      'lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-simone.org',
  },
  {
    name: 'Clementine Bauch',
    email: 'clementine.bauch@myemail.com',
    phone: '907-559-7101 x11102',
    website: 'hildegard.org',
  },
  {
    name: 'Patricia Lebsack',
    email: 'patricia.lebsack@myemail.com',
    phone: '753-521-2764 x79502',
    website: 'demarco.info',
  },
  {
    name: 'Chelsey Dietrich',
    email: 'chelsey.dietrich@myemail.com',
    phone: '409-510-3798 x43067',
    website: 'jessie.org',
  },
  {
    name: 'Mrs. Dennis Schulist',
    email: 'mrsdennis.schulist@gmail.com',
    phone: '512-632-6129 x47618',
    website: 'tamarajo.tv',
  },
  {
    name: 'Kurtis Weissnat',
    email: 'kurtis.weissnat@yahoo.com',
    phone: '167-267-3941 x31234',
    website: 'kale.biz',
  },
  {
    name: 'Nicholas Runolfsdottir',
    email: 'nicholas.runolfsdottir@example.com',
    phone: '717-330-1892 x70391',
    website:
      'lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-simone.org',
  },
  {
    name: 'Glenna Reichert',
    email: 'glenna.reichert@outlook.com',
    phone: '231-758-5103 x85049',
    website: 'hildegard.org',
  },
  {
    name: 'Clementina DuBuque',
    email: 'clementina.dubuque@myemail.com',
    phone: '554-659-3286 x86631',
    website: 'jessie.org',
  },
  {
    name: 'Leopoldo Corkery',
    email: 'leopoldo.corkery@gmail.com',
    phone: '601-844-2530 x18641',
    website:
      'lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-simone.org',
  },
  {
    name: 'Elwyn Skiles',
    email: 'elwyn.skiles@example.com',
    phone: '909-650-6221 x70690',
    website: 'demarco.info',
  },
  {
    name: 'Maxime Nitzsche',
    email: 'maxime.nitzsche@example.com',
    phone: '289-571-2394 x19130',
    website: 'jessie.org',
  },
  {
    name: 'Ebony Collier',
    email: 'ebony.collier@example.com',
    phone: '924-456-8668 x71845',
    website:
      'lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-simone.org',
  },
  {
    name: 'Julian Krajcik',
    email: 'julian.krajcik@outlook.com',
    phone: '679-626-7934 x81432',
    website: 'kale.biz',
  },
  {
    name: 'Elena Jakubowski',
    email: 'elena.jakubowski@yahoo.com',
    phone: '167-536-8927 x21719',
    website: 'hildegard.org',
  },
  {
    name: 'Tanya Reilly',
    email: 'tanya.reilly@example.com',
    phone: '746-481-3961 x94832',
    website: 'demarco.info',
  },
  {
    name: 'Rhea Nitzsche',
    email: 'rhea.nitzsche@outlook.com',
    phone: '316-984-8753 x35617',
    website:
      'lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-simone.org',
  },
  {
    name: 'Thalia Prohaska',
    email: 'thalia.prohaska@example.com',
    phone: '870-945-5307 x69058',
    website: 'hildegard.org',
  },
  {
    name: 'Natasha Kessler',
    email: 'natasha.kessler@example.com',
    phone: '660-429-7991 x37929',
    website:
      'lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-simone.org',
  },
  {
    name: 'Jeanne Lemke',
    email: 'jeanne.lemke@example.com',
    phone: '479-756-7391 x24815',
    website: 'kale.biz',
  },
  {
    name: 'Melyssa Schumm',
    email: 'melyssa.schumm@example.com',
    phone: '732-571-1125 x87393',
    website: 'demarco.info',
  },
  {
    name: 'Marcellus Ratke',
    email: 'marcellus.ratke@gmail.com',
    phone: '945-437-3759 x73841',
    website: 'jessie.org',
  },
  {
    name: 'Janelle Denesik',
    email: 'janelle.denesik@gmail.com',
    phone: '608-354-4444 x43725',
    website:
      'lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-simone.org',
  },
  {
    name: 'Esteban Wisozk',
    email: 'esteban.wisozk@myemail.com',
    phone: '342-204-1839 x68411',
    website: 'kale.biz',
  },
  {
    name: 'Deven Herzog',
    email: 'deven.herzog@outlook.com',
    phone: '469-956-1821 x50145',
    website: 'hildegard.org',
  },
  {
    name: 'Jodie Kulas',
    email: 'jodie.kulas@outlook.com',
    phone: '986-246-6467 x53273',
    website:
      'lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-simone.org',
  },
  {
    name: 'Kaley Halvorson',
    email: 'kaley.halvorson@example.com',
    phone: '698-854-7007 x97315',
    website: 'demarco.info',
  },
  {
    name: 'Gretchen Nienow',
    email: 'gretchen.nienow@example.com',
    phone: '740-304-1392 x70660',
    website: 'jessie.org',
  },
  {
    name: 'Sherman Bergstrom',
    email: 'sherman.bergstrom@myemail.com',
    phone: '156-592-2250 x51788',
    website: 'kale.biz',
  },
  {
    name: 'Shane Eichmann',
    email: 'shane.eichmann@example.com',
    phone: '292-957-3411 x30224',
    website:
      'lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-lorem-ipsum-simone.org',
  },
  {
    name: 'Mathew Runolfsdottir',
    email: 'mathew.runolfsdottir@example.com',
    phone: '489-674-3277 x51249',
    website: 'jessie.org',
  },
])
</script>
