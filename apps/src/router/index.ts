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
  const pageTitle = useNavigationStore().title(to.path)
  const title = pageTitle ? `${appTitle} - ${pageTitle}` : appTitle
  useHead({ title })

  return true
})

if (import.meta.hot) {
  handleHotUpdate(router)
}

export default router
