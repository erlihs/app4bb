<template>
  <v-container>
    <h1>The Flow Master - Admin</h1>
    <v-row>
      <v-col>
        <v-tabs v-model="tfmAdmin.tab" class="mb-4">
          <v-tab value="keys">Keys</v-tab>
          <v-tab value="agents">Agents</v-tab>
        </v-tabs>
        <v-tabs-window v-model="tfmAdmin.tab">
          <v-tabs-window-item value="keys">
            <v-bsb-table
              :options="keysOptions"
              :loading="loading"
              :t="t"
              @fetch="handleKeysFetch"
              @action="handleKeysAction"
            />
          </v-tabs-window-item>
          <v-tabs-window-item value="agents">
            <v-bsb-table
              :options="agentsOptions"
              :loading="loading"
              :t="t"
              @fetch="handleAgentsFetch"
            />
          </v-tabs-window-item>
        </v-tabs-window>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
definePage({
  meta: {
    role: 'ADMIN',
    title: 'The Flow Master - Admin',
  },
})

const baseURL = (import.meta.env.DEV ? '/api/' : import.meta.env.VITE_API_URI) + 'tfm-v1/'
const http = useHttp({ baseURL, headers: { 'Cache-Control': 'no-cache' } })

const { t } = useI18n()
const loading = ref(false)
const tfmAdmin = useStorage('tfm-admin', { tab: 'key' })

onMounted(() => {
  console.log('tfmAdmin', tfmAdmin.value)
})

const keysOptions = <BsbTableOptions>{
  key: 'ukid',
  columns: [
    {
      name: 'name',
    },
    {
      name: 'description',
    },
    {
      name: 'actions',
      actions: [
        {
          name: 'edit',
          format: { icon: '$mdiPencil' },
          form: {
            fields: [
              {
                name: 'name',
                label: t('Name'),
                type: 'text',
                rules: [{ type: 'required', params: true, message: 'Required' }],
              },
              {
                name: 'key',
                label: t('Key'),
                type: 'text',
                rules: [{ type: 'required', params: true, message: 'Required' }],
              },
              {
                name: 'description',
                label: t('Description'),
                type: 'textarea',
              },
            ],
            actions: [
              {
                name: 'submit',
                format: { variant: 'flat' },
              },
              {
                name: 'cancel',
                format: { color: 'secondary' },
              },
            ],
            actionSubmit: 'submit',
            actionCancel: 'cancel',
          },
        },
      ],
    },
  ],
  actions: [
    {
      name: 'add',
      format: { icon: '$mdiPlus', variant: 'flat' },
      form: {
        fields: [
          {
            name: 'name',
            label: t('Name'),
            type: 'text',
            rules: [{ type: 'required', params: true, message: 'Required' }],
          },
          {
            name: 'key',
            label: t('Key'),
            type: 'text',
            rules: [{ type: 'required', params: true, message: 'Required' }],
          },
          {
            name: 'description',
            label: t('Description'),
            type: 'textarea',
          },
        ],
        actions: [
          {
            name: 'submit',
            format: { variant: 'flat' },
          },
          {
            name: 'cancel',
            format: { color: 'secondary' },
          },
        ],
        actionAlign: 'right',
        actionSubmit: 'submit',
        actionCancel: 'cancel',
      },
    },
  ],
}

async function handleKeysFetch(
  fetchData: Ref<BsbTableData[]>,
  offset: number,
  limit: number,
  search: string,
  filter: string,
  sort: string,
) {
  loading.value = true
  const { data, error } = await http.get('keys/', { offset, limit, search, filter, sort })
  fetchData.value = error ? [] : (data as { keys: BsbTableData[] }).keys
  loading.value = false
}

async function handleKeysAction(
  actionName: string,
  actionData: Ref<BsbTableData | BsbTableData[]>,
  value?: BsbTableData,
) {
  const { data, error } = await http.post('key/', { ...value })
  console.log('action', data, error)
}

const agentsOptions = <BsbTableOptions>{
  key: 'uaid',
  columns: [
    {
      name: 'name',
    },
    {
      name: 'description',
    },
    {
      name: 'coins',
      align: 'right',
    },
    {
      name: 'options',
      maxLength: 0,
    },
  ],
}

async function handleAgentsFetch(
  fetchData: Ref<BsbTableData[]>,
  offset: number,
  limit: number,
  search: string,
  filter: string,
  sort: string,
) {
  loading.value = true
  const { data, error } = await http.get('agents/', { offset, limit, search, filter, sort })
  fetchData.value = error ? [] : (data as { agents: BsbTableData[] }).agents
  loading.value = false
}
</script>
