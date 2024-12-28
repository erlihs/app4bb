import type { PiniaPlugin, PiniaPluginContext } from 'pinia'

export interface PiniaPersistOptions {
  include?: string[]
  exclude?: string[]
  debug?: boolean
}

declare module 'pinia' {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  export interface DefineStoreOptionsBase<S, Store> {
    persist?: PiniaPersistOptions
  }
}

export function createPiniaLocalStoragePlugin(): PiniaPlugin {
  return (context: PiniaPluginContext) => {
    const store = context.store
    const key = store.$id
    const PiniaPersistOptions = context.options.persist as PiniaPersistOptions
    const debug = PiniaPersistOptions?.debug || false

    if (debug)
      console.log(`Creating PiniaLocalStoragePlugin for ${key} with options:`, PiniaPersistOptions)

    function filterState(state: Record<string, unknown>): Record<string, unknown> {
      const include = PiniaPersistOptions?.include || []
      const exclude = PiniaPersistOptions?.exclude || []
      if (include.length > 0) {
        return Object.fromEntries(Object.entries(state).filter(([key]) => include.includes(key)))
      }
      if (exclude.length > 0) {
        return Object.fromEntries(Object.entries(state).filter(([key]) => !exclude.includes(key)))
      }
      return state
    }

    const savedState = localStorage.getItem(key)
    if (savedState) {
      try {
        const parsedState = JSON.parse(savedState)
        store.$patch(parsedState)
        if (debug) console.log(`Restored ${key} from localStorage:`, parsedState)
      } catch (error) {
        console.error(`Error parsing localStorage for ${key}:`, error)
      }
    }

    store.$subscribe((mutation, state) => {
      if (!PiniaPersistOptions) return
      try {
        const filteredState = filterState(state)
        localStorage.setItem(key, JSON.stringify(filteredState))
        if (debug) console.log(`Saved ${store.$id} to localStorage:`, filteredState)
      } catch (error) {
        console.error(`Error saving ${key} to localStorage:`, error)
      }
    })
  }
}
