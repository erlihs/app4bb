<template>
  <v-container>
    <h1 class="mb-4">{{ meta.title }}</h1>

    <v-tabs v-model="admin.tab" class="mb-4">
      <v-tab value="dashboard">Dashboard</v-tab>
      <v-tab value="users">Users</v-tab>
      <v-tab value="audit">Audit</v-tab>
      <v-tab value="settings">Settings</v-tab>
      <v-tab value="jobs">Jobs</v-tab>
    </v-tabs>
    <v-tabs-window v-model="admin.tab">
      <v-tabs-window-item value="dashboard">
        <v-row>
          <v-col cols="12" md="6" lg="4" v-for="item in status" :key="item.status">
            <v-card
              :to="item.to"
              :color="item.severity === 'E' ? 'red' : item.severity === 'W' ? 'orange' : ''"
            >
              <v-card-title>{{ item.status }}</v-card-title>
              <v-card-text>{{ item.value }}</v-card-text>
            </v-card>
          </v-col>
        </v-row>
        <v-row
          ><v-col class="text-right"
            ><v-btn variant="outlined" @click="refreshStatus()" icon="$mdiRefresh"></v-btn></v-col
        ></v-row>
      </v-tabs-window-item>

      <v-tabs-window-item value="users">
        <v-bsb-table
          :shorten="30"
          searchable
          :options="options_users"
          :api="api_users"
          @action="userAction"
        />
      </v-tabs-window-item>

      <v-tabs-window-item value="audit">
        <v-bsb-table
          :shorten="30"
          searchable
          :options="options_audit"
          :api="api_audit"
          @action="auditAction"
        />
      </v-tabs-window-item>

      <v-tabs-window-item value="settings">
        <v-bsb-table :shorten="30" searchable :options="options_settings" :api="api_settings" />
      </v-tabs-window-item>

      <v-tabs-window-item value="jobs">
        <v-bsb-table
          v-if="!jobs_details"
          :shorten="30"
          searchable
          :options="options_jobs"
          :api="api_jobs"
          @action="action"
        />
        <v-bsb-table
          v-if="jobs_details"
          :shorten="30"
          searchable
          :searchValue="jobName"
          :options="options_jobs_details"
          :api="api_jobs_details"
        />
        <v-btn v-if="jobs_details" @click="jobs_details = false" icon="$mdiArrowLeft" />
      </v-tabs-window-item>
    </v-tabs-window>
  </v-container>
</template>

<script setup lang="ts">
definePage({
  meta: {
    title: 'Admin',
    description: 'Administration of users, settings, etc.',
    icon: '$mdiSecurity',
    color: '#EEEEEE',
    role: 'ADMIN',
  },
})
const meta = useRoute().meta

import { defineStore } from 'pinia'
const useAdminStore = defineStore(
  'admin',
  () => {
    const tab = ref<string | null>(null)

    return {
      tab,
    }
  },
  {
    persist: {
      include: ['tab'],
    },
  },
)
const admin = useAdminStore()

const baseURL = (import.meta.env.DEV ? '/api/' : import.meta.env.VITE_API_URI) + 'adm-v1/'
const http = useHttp({ baseURL, headers: { 'Cache-Control': 'no-cache' } })

type StatusResponse = {
  status: string
  value: string
  to: string
  severity: string
}

const status = ref([] as StatusResponse[])

const api_users = ref(baseURL + 'users/')
const options_users = ref({
  title: 'Users',
  columns: [
    {
      primary: true,
      column: 'uuid',
      title: 'ID',
      shorten: 0,
    },
    { column: 'username', title: 'Username', format: { to: 'mailto:$value', target: '_blank' } },
    { column: 'fullname', title: 'Fullname' },
    { column: 'status', title: 'Status' },
    {
      actions: [
        {
          action: 'lock',
          format: { icon: '$mdiLock', color: 'red' },
          condition: [
            { type: 'equals', name: 'status', value: 'N' },
            { type: 'equals', name: 'status', value: 'A' },
          ],
        },
        {
          action: 'unlock',
          format: { icon: '$mdiLockOff' },
          condition: { type: 'equals', name: 'status', value: 'D' },
        },
      ],
    },
  ],
})

async function userAction(action: { action: string; item: { uuid: string; status: string } }) {
  if (action.action === 'lock') {
    const { error } = await http.post('user_lock/', { uuid: action.item.uuid })
    if (!error) action.item.status = 'D'
    return
  }
  if (action.action === 'unlock') {
    const { error } = await http.post('user_unlock/', { uuid: action.item.uuid })
    if (!error) action.item.status = 'N'
    return
  }
}

const api_audit = ref(baseURL + 'audit/')
const options_audit = ref({
  title: 'Audit Records',
  columns: [
    {
      column: 'severity',
      format: [
        { condition: 'equals', params: 'I', icon: '$mdiInformation', color: 'blue', text: '' },
        { condition: 'equals', params: 'W', icon: '$mdiAlert', color: 'orange', text: '' },
        { condition: 'equals', params: 'E', icon: '$mdiAlertOctagon', color: 'red', text: '' },
      ],
    },
    {
      column: 'created',
      title: 'created',
    },
    {
      column: 'username',
      title: 'user',
      format: { to: 'mailto:$value', target: '_blank' },
    },
    { column: 'action', title: 'action' },
    {
      column: 'details',
      title: 'details',
    },
    { actions: [{ action: 'copy', format: { icon: '$mdiContentCopy' } }] },
  ],
})

async function auditAction(action: { action: string; item: unknown }) {
  if (action.action === 'copy') {
    const data = JSON.stringify(action.item, null, 2)
    copyToClipboard(data)
  }
}

const api_settings = ref(baseURL + 'settings/')
const api_settings_edit = ref(baseURL + 'setting/')
const options_settings = ref({
  title: 'Settings',
  columns: [
    {
      primary: true,
      column: 'id',
      title: 'Key',
    },
    { column: 'description', title: 'Description' },
    {
      column: 'content',
      title: 'Value',
      shorten: 30,
    },
    {
      actions: [
        {
          action: 'edit',
          format: { icon: '$mdiPencil' },
          form: {
            title: 'Edit',
            api: api_settings_edit,
            fields: [
              { name: 'id', label: 'Key', type: 'text', readonly: true },
              { name: 'content', label: 'Value', type: 'text' },
            ],
            actions: ['cancel', 'submit'],
          },
        },
      ],
    },
  ],
})

const jobs_details = ref(false)
const api_jobs = ref(baseURL + 'jobs/')
const options_jobs = ref({
  title: 'Jobs',
  columns: [
    {
      primary: true,
      column: 'name',
      title: 'Job name',
    },
    { column: 'schedule', title: 'Schedule' },
    { column: 'start', title: 'Last run date' },
    { column: 'duration', title: 'Last run duration' },
    { column: 'comments', title: 'Comments' },
    {
      actions: [
        { action: 'details', format: { icon: '$mdiHistory' } },
        { action: 'run', format: { icon: '$mdiRun' } },
      ],
    },
  ],
})

const jobName = ref('')
const api_jobs_details = ref(baseURL + 'jobs_history/')
const options_jobs_details = ref({
  title: 'Job History',
  columns: [
    {
      column: 'name',
      title: 'Job name',
    },
    { column: 'start', title: 'Start' },
    { column: 'duration', title: 'Duration' },
    { column: 'status', title: 'Status' },
    { column: 'output', title: 'Output' },
  ],
})

function action(action: { action: string; item: { name: string } }) {
  if (action.action === 'details') {
    jobName.value = action.item.name
    jobs_details.value = true
  }
  if (action.action === 'run') {
    http.post('job_run/', { name: action.item.name }).then(() => {
      refreshStatus()
    })
  }
}

async function refreshStatus() {
  await http.get('status/').then((response) => {
    status.value = (response.data as { status: StatusResponse[] }).status
  })
}

onMounted(() => {
  refreshStatus()
})

const route = useRoute()

watch(
  () => route?.hash,
  (newHash) => {
    if (newHash) {
      const tab = newHash.replace('#', '')
      if (['dashboard', 'users', 'audit', 'settings', 'jobs'].includes(tab)) {
        admin.tab = tab as unknown as string
      }
    }
  },
  { immediate: true },
)

const { setSnack } = useUiStore()
function copyToClipboard(text: string) {
  navigator.clipboard.writeText(text).then(
    () => {
      setSnack('copied.to.clipboard', 2000)
    },
    (err) => {
      console.error('Could not copy text: ', err)
    },
  )
}
</script>
