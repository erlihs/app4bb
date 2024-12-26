import { createRouter, createWebHistory } from 'vue-router'
import { routes, handleHotUpdate } from 'vue-router/auto-routes'
import { loadPageTranslations } from '@/plugins/i18n'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
})

router.beforeEach(async (to) => {
  await loadPageTranslations(to.path)

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
    uiStore.setError('You are not allowed to access this page')
  }
  return result === '/login' ? { path: result, query: { redirect: to.path } } : result
})

if (import.meta.hot) {
  handleHotUpdate(router)
}

export default router
