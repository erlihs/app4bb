import { defineStore, acceptHMRUpdate } from 'pinia'
import { appApi, type AuditData } from '@/api'

export const useAuditStore = defineStore('audit', () => {
  let autoSaveTimer: number | null = null

  let initialData: AuditData[] = []
  try {
    const stored = localStorage.getItem('audit')
    if (stored) initialData = JSON.parse(stored)
  } catch {
    initialData = []
  }

  const data = ref<AuditData[]>(initialData)

  const count = computed(() => data.value.length)

  const log = async (
    severity: string,
    action: string,
    details: string,
    saveImmediately = false,
  ) => {
    data.value.push({ severity, action, details, created: new Date().toISOString() })
    if (saveImmediately) await save()
  }

  async function inf(action: string, details: string, saveImmediately = false) {
    log('I', action, details, saveImmediately)
  }

  async function wrn(action: string, details: string, saveImmediately = false) {
    log('W', action, details, saveImmediately)
  }

  async function err(action: string, details: string, saveImmediately = false) {
    log('E', action, details, saveImmediately)
  }

  async function save() {
    if (data.value.length) {
      try {
        await appApi.audit(data.value)
      } catch (error) {
        err('Failed to save audit log', (error as Error).message)
        if (import.meta.env.DEV) console.error('Failed to save audit log', data.value)
      } finally {
        data.value = []
      }
    }
  }

  function startAutoSave() {
    if (!autoSaveTimer) {
      autoSaveTimer = window.setInterval(save, 60000)
    }
  }

  function stopAutoSave() {
    if (autoSaveTimer) {
      clearInterval(autoSaveTimer)
      autoSaveTimer = null
    }
  }

  onMounted(async () => {
    startAutoSave()
  })

  onUnmounted(async () => {
    await save()
    stopAutoSave()
  })

  watch(
    () => data.value,
    (newData) => {
      try {
        localStorage.setItem('audit', JSON.stringify(newData))
      } finally {
        // do nothing
      }
    },
    { deep: true },
  )

  return {
    inf,
    wrn,
    err,
    count,
    save,
    startAutoSave,
    stopAutoSave,
  }
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useAuditStore, import.meta.hot))
}
