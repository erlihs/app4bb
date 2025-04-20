import { ref, watch, type Ref } from 'vue'

export function useStorage<T extends object>(key: string, defaultValue: T): Ref<T> {
  const stored = localStorage.getItem(key)
  const state = ref(stored ? JSON.parse(stored) : defaultValue) as Ref<T>
  watch(
    state,
    (val) => {
      localStorage.setItem(key, JSON.stringify(val))
    },
    { deep: true },
  )
  return state
}
