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
          :options="userOptions"
          :loading
          @fetch="handleUserFetch"
          @action="handleUserAction"
        />
      </v-tabs-window-item>

      <v-tabs-window-item value="audit">
        <v-bsb-table
          :options="auditOptions"
          :loading
          @fetch="handleAuditFetch"
          @action="handleAuditAction"
        />
      </v-tabs-window-item>

      <v-tabs-window-item value="settings">
        <v-bsb-table
          :options="settingsOptions"
          :loading
          @fetch="handleSettingsFetch"
          @action="handleSettingsAction"
        />
      </v-tabs-window-item>

      <v-tabs-window-item value="jobs">
        <v-bsb-table
          v-if="!jobsDetails"
          :options="jobsOptions"
          @fetch="handleJobsFetch"
          @action="handleJobsAction"
        />
        <v-bsb-table
          v-if="jobsDetails"
          :options="jobsDetailsOptions"
          @fetch="handleJobsDetailsFetch"
        />
        <v-btn v-if="jobsDetails" @click="jobsDetails = false" icon="$mdiArrowLeft" />
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

import type { BsbFormFieldError, BsbTableOptions } from '@/components'
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

const loading = ref(false)

type StatusResponse = {
  status: string
  value: string
  to: string
  severity: string
}

const status = ref([] as StatusResponse[])

async function refreshStatus() {
  await http.get('status/').then((response) => {
    status.value = (response.data as { status: StatusResponse[] }).status
  })
}

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

const userOptions = ref<BsbTableOptions>({
  key: 'uuid',
  columns: [
    {
      name: 'uuid',
      title: 'Id',
      maxLength: 0,
    },
    { name: 'username', title: 'User name', format: { to: 'mailto:${value}', target: '_blank' } },
    { name: 'fullname', title: 'Full name' },
    { name: 'status' },
    {
      name: 'actions',
      actions: [
        {
          name: 'lock',
          key: 'status',
          format: [
            {
              rules: [
                { type: 'equals', params: 'N' },
                { type: 'equals', params: 'A' },
              ],
              icon: '$mdiLock',
              color: 'red',
            },
            { hidden: true },
          ],
        },
        {
          name: 'unlock',
          key: 'status',
          format: [
            {
              rules: [{ type: 'equals', params: 'D' }],
              icon: '$mdiLockOff',
            },
            { hidden: true },
          ],
        },
      ],
    },
  ],
})

async function handleUserFetch(
  fetchData: Ref<BsbTableData[]>,
  offset: number,
  limit: number,
  search: string,
  filter: string,
  sort: string,
) {
  loading.value = true
  const { data, error } = await http.get('users/', { offset, limit, search, filter, sort })
  fetchData.value = error ? [] : (data as { items: BsbTableData[] }).items
  loading.value = false
}

async function handleAuditFetch(
  fetchData: Ref<BsbTableData[]>,
  offset: number,
  limit: number,
  search: string,
  filter: string,
  sort: string,
) {
  loading.value = true
  const { data, error } = await http.get('audit/', { offset, limit, search, filter, sort })
  fetchData.value = error ? [] : (data as { items: BsbTableData[] }).items
  loading.value = false
}

async function handleUserAction(
  actionName: string,
  actionData: Ref<BsbTableData>,
  value: BsbTableData,
) {
  loading.value = true
  if (actionName === 'lock') {
    const { error } = await http.post('user_lock/', { uuid: value.uuid })
    if (!error) value.status = 'D'
  }
  if (actionName === 'unlock') {
    const { error } = await http.post('user_unlock/', { uuid: value.uuid })
    if (!error) value.status = 'N'
  }
  loading.value = false
}

const auditOptions = ref<BsbTableOptions>({
  key: 'id',

  columns: [
    {
      name: 'severity',
      format: [
        {
          rules: { type: 'equals', params: 'I' },
          icon: '$mdiInformation',
          color: 'blue',
          text: '',
        },
        { rules: { type: 'equals', params: 'W' }, icon: '$mdiAlert', color: 'orange', text: '' },
        {
          rules: { type: 'equals', params: 'E' },
          icon: '$mdiAlertOctagon',
          color: 'red',
          text: '',
        },
      ],
    },
    {
      name: 'created',
    },
    {
      name: 'username',
      format: { to: 'mailto:${value}' },
    },
    { name: 'action' },
    {
      name: 'details',
      maxLength: 0,
    },
    { name: 'actions', actions: [{ name: 'copy', format: { icon: '$mdiContentCopy' } }] },
  ],
})

async function handleAuditAction(
  actionName: string,
  actionData: Ref<BsbTableData>,
  value: BsbTableData,
) {
  if (actionName === 'copy') {
    const data = JSON.stringify(value, null, 2)
    copyToClipboard(data)
  }
}

const settingsOptions = ref<BsbTableOptions>({
  key: 'id',
  columns: [
    {
      name: 'id',
      title: 'Key',
    },
    { name: 'description', title: 'Description' },
    {
      name: 'content',
      title: 'Value',
      maxLength: 30,
    },
    {
      name: 'actions',
      actions: [
        {
          name: 'edit',
          format: { icon: '$mdiPencil' },
          form: {
            fields: [
              { name: 'id', label: 'Key', type: 'text', readonly: true },
              { name: 'content', label: 'Value', type: 'text' },
            ],
            actions: ['cancel', 'submit'],
            actionSubmit: 'submit',
            actionCancel: 'cancel',
          },
        },
      ],
    },
  ],
})

async function handleSettingsFetch(
  fetchData: Ref<BsbTableData[]>,
  offset: number,
  limit: number,
  search: string,
  filter: string,
  sort: string,
) {
  loading.value = true
  const { data, error } = await http.get('settings/', { offset, limit, search, filter, sort })
  fetchData.value = error ? [] : (data as { items: BsbTableData[] }).items
  loading.value = false
}

async function handleSettingsAction(
  actionName: string,
  actionData: Ref<BsbTableData>,
  value: BsbTableData,
) {
  loading.value = true
  const oldValue = value.content
  if (actionName === 'edit') {
    const { error, data } = await http.post('setting/', { id: value.id, content: value.content })
    if (error) {
      value.content = oldValue
      console.log(
        'todo: process server side errors',
        (data as { errors: BsbFormFieldError[] }).errors,
      )
    }
  }
  loading.value = false
}

const jobsDetails = ref(false)

const jobsOptions = ref<BsbTableOptions>({
  key: 'name',
  columns: [
    {
      name: 'name',
      title: 'Job name',
    },
    { name: 'schedule', title: 'Schedule' },
    { name: 'start', title: 'Last run date' },
    { name: 'duration', title: 'Last run duration' },
    { name: 'comments', title: 'Comments' },
    {
      name: 'actions',
      actions: [
        { name: 'details', format: { icon: '$mdiHistory' } },
        { name: 'run', format: { icon: '$mdiRun' } },
      ],
    },
  ],
})

const jobsDetailsOptions = ref<BsbTableOptions>({
  key: 'name',
  columns: [
    {
      name: 'name',
      title: 'Job name',
    },
    { name: 'start', title: 'Start' },
    { name: 'duration', title: 'Duration' },
    { name: 'status', title: 'Status' },
    { name: 'output', title: 'Output', maxLength: 20 },
  ],
})

async function handleJobsFetch(
  fetchData: Ref<BsbTableData[]>,
  offset: number,
  limit: number,
  search: string,
  filter: string,
  sort: string,
) {
  loading.value = true
  const { data, error } = await http.get('jobs/', { offset, limit, search, filter, sort })
  fetchData.value = error ? [] : (data as { items: BsbTableData[] }).items
  loading.value = false
}

async function handleJobsDetailsFetch(
  fetchData: Ref<BsbTableData[]>,
  offset: number,
  limit: number,
  search: string,
  filter: string,
  sort: string,
) {
  loading.value = true
  const { data, error } = await http.get('jobs_history/', {
    offset,
    limit,
    search: jobName.value,
    filter,
    sort,
  })
  fetchData.value = error ? [] : (data as { items: BsbTableData[] }).items
  loading.value = false
}

const jobName = ref('')

async function handleJobsAction(
  actionName: string,
  actionData: Ref<BsbTableData>,
  value: BsbTableData,
) {
  if (actionName === 'details') {
    jobName.value = value.name as string
    jobsDetailsOptions.value.filter = {
      fields: [{ type: 'text', name: 'name', value: value.name }],
      actions: ['apply', 'cancel'],
      actionCancel: 'cancel',
    }
    jobsDetails.value = true
  }
  if (actionName === 'run') {
    const { error } = await http.post('job_run/', { name: value.name })
    if (!error) {
      refreshStatus()
    }
  }
}

onMounted(() => {
  refreshStatus()
})
</script>
