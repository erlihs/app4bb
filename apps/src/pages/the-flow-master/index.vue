<template>
  <v-container>
    <v-row>
      <v-col cols="12" sm="6">
        <h2>My Flows</h2>
        <v-tabs v-model="tfm.tab" class="mb-4">
          <v-tab value="runs">Runs</v-tab>
          <v-tab value="flows">Flows</v-tab>
        </v-tabs>
        <v-tabs-window v-model="tfm.tab">
          <v-tabs-window-item value="runs">
            <v-bsb-table
              ref="runs"
              :options="runsOptions"
              :loading="loading"
              :t="t"
              @fetch="handleRunsFetch"
              @action="handleRunsAction"
            />
          </v-tabs-window-item>
          <v-tabs-window-item value="flows">
            <v-bsb-table
              :options="flowsOptions"
              :loading
              :t
              @fetch="handleFlowsFetch"
              @action="handleFlowsAction"
            />
          </v-tabs-window-item>
        </v-tabs-window>
      </v-col>
      <v-col cols="12" sm="6">
        <h2>Balance</h2>
        <v-row>
          <v-col cols="auto">
            <v-tabs v-model="tfm.balanceTab" direction="vertical">
              <v-tab
                v-for="period in balancePeriods"
                :key="period.value"
                :text="period.label"
                :value="period.value"
              />
            </v-tabs>
          </v-col>
          <v-col>
            <h3 class="mt-4 mb-2">Tokens:</h3>
            <v-container fluid>
              <v-row>
                <v-col>Used:</v-col>
                <v-col class="text-right">{{ selectedBalance?.used.toFixed(2) }}</v-col>
              </v-row>
              <v-row>
                <v-col>Limit:</v-col>
                <v-col class="text-right">{{ selectedBalance?.limit.toFixed(2) }}</v-col>
              </v-row>
              <v-row class="border-t">
                <v-col>Remaining:</v-col>
                <v-col class="text-right">{{ selectedBalance?.remaining.toFixed(2) }}</v-col>
              </v-row>
            </v-container>
          </v-col>
        </v-row>
        <v-row>
          <v-col class="text-right">
            <v-btn
              class="mt-4"
              icon="$mdiRefresh"
              @click="handleBalanceRefresh"
              variant="tonal"
              size="small"
            />
          </v-col>
        </v-row>
      </v-col>
      <v-col cols="12">
        <h2>About</h2>
        <p>Welcome to The Flow Master!</p>
        <v-btn v-if="isAdmin" :to="'/the-flow-master/admin'" class="mt-4"> Admin </v-btn>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
import type { BsbTableData } from '@/components'

definePage({
  meta: {
    role: 'public',
    icon: '$mdiFaceAgent',
    color: '#F8BBD0',
    description:
      'Too much of everything and need just a simple, trustworthy and consistent digital assistant? ',
    title: 'The Flow Master',
  },
})

const baseURL = (import.meta.env.DEV ? '/api/' : import.meta.env.VITE_API_URI) + 'tfm-v1/'
const http = useHttp({ baseURL, headers: { 'Cache-Control': 'no-cache' } })

const { t } = useI18n()
const loading = ref(false)
const isAdmin = useAuthStore().hasRole('ADMIN')
const tfm = useStorage<{ tab: string; balanceTab: string }>('tfm', {
  tab: 'flows',
  balanceTab: 'D',
})

const runs = ref<{ fetch: (page?: number) => void } | null>(null)
const runsOptions = {
  key: 'urid',
  itemsPerPage: 3,
  columns: [
    {
      name: 'name',
    },
    {
      name: 'created',
    },
    {
      name: 'duration',
    },
    {
      name: 'status',
      format: [
        {
          rules: { type: 'starts-with', params: 'P' },
          text: 'Pending',
          color: 'Orange',
        },
        {
          color: 'green',
        },
      ],
      actions: [
        {
          name: 'results',
          key: 'status',
          format: [
            {
              rules: { type: 'starts-with', params: 'C' },
              text: 'Results',
              color: 'green',
            },
            { hidden: true },
          ],
          form: {
            fields: [
              {
                name: 'results',
              },
            ],
            actions: [{ name: 'cancel' }],
            actionCancel: 'cancel',
          },
        },
      ],
    },
  ],
}

async function handleRunsFetch(
  fetchData: Ref<BsbTableData[]>,
  offset: number,
  limit: number,
  search: string,
  filter: string,
  sort: string,
) {
  loading.value = true
  const { data, error } = await http.get('runs/', { offset, limit, search, filter, sort })
  fetchData.value = error ? [] : (data as { runs: BsbTableData[] }).runs
  loading.value = false
}

async function handleRunsAction(
  actionName: string,
  actionData: Ref<BsbTableData | BsbTableData[]>,
  value?: BsbTableData,
) {
  //const { data, error } = await http.post('run/', { value })
  console.log('action', actionName, value)
}

const flowsOptions = {
  key: 'ufid',
  itemsPerPage: 3,
  columns: [
    {
      name: 'name',
    },
    {
      name: 'actions',
      actions: [
        { name: 'history', format: { icon: '$mdiHistory' } },
        { name: 'run', format: { icon: '$mdiRun', variant: 'flat' } },
      ],
    },
  ],
  actions: isAdmin ? [{ name: 'new', format: { icon: '$mdiPlus', variant: 'flat' } }] : [],
}

async function handleFlowsFetch(
  fetchData: Ref<BsbTableData[]>,
  offset: number,
  limit: number,
  search: string,
  filter: string,
  sort: string,
) {
  loading.value = true
  const { data, error } = await http.get('flows/', { offset, limit, search, filter, sort })
  fetchData.value = error ? [] : (data as { flows: BsbTableData[] }).flows
  loading.value = false
}

async function handleFlowsAction(
  actionName: string,
  actionData: Ref<BsbTableData | BsbTableData[]>,
  value?: BsbTableData,
) {
  loading.value = true
  await http.put(`${actionName}/`, { ...value })
  await handleBalanceRefresh()
  runs.value?.fetch(1)
  if (actionName === 'run') tfm.value.tab = 'runs'
  loading.value = false
}

type Balance = {
  period: string
  used: number
  limit: number
  remaining: number
}

const balancePeriods = [
  { label: 'Hour', value: 'H' },
  { label: 'Day', value: 'D' },
  { label: 'Week', value: 'W' },
  { label: 'Month', value: 'M' },
  { label: 'Quarter', value: 'Q' },
  { label: 'Year', value: 'Y' },
]

const balance = ref<Balance[]>([
  {
    period: 'D',
    used: 0,
    limit: 0,
    remaining: 0,
  },
])

const selectedBalance = computed(
  () =>
    balance.value.find((b) => b.period === tfm.value.balanceTab) || {
      used: 0,
      limit: 0,
      remaining: 0,
    },
)

async function handleBalanceRefresh() {
  loading.value = true
  const { data, error } = await http.get('balance/')
  balance.value = error ? [] : (data as { balance: Balance[] }).balance
  loading.value = false
}
</script>
