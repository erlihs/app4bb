import { defineStore, acceptHMRUpdate } from 'pinia'

export const useUiStore = defineStore('ui', () => {
  const loading = ref(false)
  const info = ref('')
  const warning = ref('')
  const error = ref('')
  const snack = ref('')
  const snackbar = computed(() => !!snack.value)

  function clearMessages() {
    info.value = ''
    warning.value = ''
    error.value = ''
  }

  function setInfo(message: string) {
    clearMessages()
    info.value = message
  }

  function setWarning(message: string) {
    clearMessages()
    warning.value = message
  }

  function setError(message: string) {
    clearMessages()
    error.value = message
  }

  function setSnack(message: string) {
    clearMessages()
    snack.value = message
  }

  function startLoading() {
    clearMessages()
    loading.value = true
  }

  function stopLoading() {
    loading.value = false
  }

  return {
    loading,
    info,
    warning,
    error,
    snack,
    snackbar,
    clearMessages,
    setInfo,
    setWarning,
    setError,
    setSnack,
    startLoading,
    stopLoading,
  }
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useUiStore, import.meta.hot))
}
