import { createRouter, createWebHistory } from 'vue-router'
import { routes, handleHotUpdate } from 'vue-router/auto-routes'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
})

router.beforeEach(async (to) => {
  to.meta.performance = performance.now()

  const i18nStore = useI18nStore()
  await i18nStore.loadTranslations(to.path)

  const appTitle = 'Bullshit Bingo'
  const navigationStore = useNavigationStore()
  const pageTitle = navigationStore.title(to.path)
  const title = pageTitle ? `${appTitle} - ${pageTitle}` : appTitle
  useHead({ title })

  const uiStore = useUiStore()
  const result: string | boolean = navigationStore.guard(to.path)
  if (result) {
    uiStore.clearMessages()
  } else {
    uiStore.setError('you.are.not.allowed.to.access.this.page')
  }
  return result === '/login' ? { path: result, query: { redirect: to.path } } : result
})

router.afterEach((to) => {
  const duration: number = performance.now() - (to.meta.performance as number)
  if (duration >= import.meta.env.VITE_PERFORMANCE_PAGE_LOAD_THRESHOLD_IN_MS) {
    const appAudit = useAuditStore()
    appAudit.wrn('Page load time threshold exceeded', `Route ${to.path} took ${duration}ms`)
  }
})

if (import.meta.hot) {
  handleHotUpdate(router)
}

export default router
