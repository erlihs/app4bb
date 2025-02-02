import { defineStore, acceptHMRUpdate } from 'pinia'
import { useRouter, useRoute } from 'vue-router'

export const useNavigationStore = defineStore('navigation', () => {
  const routes = useRouter().getRoutes()
  const route = useRoute()
  const auth = useAuthStore()

  const allPages = routes.map((route) => {
    return {
      path: route.path,
      level: route.path == '/' ? 0 : route.path.split('/').length - 1,
      children:
        routes.find((r) => r.path.includes(route.path) && r.path !== route.path) !== undefined,
      title:
        route.meta?.title?.toString() ||
        route.path
          .split('/')
          .at(-1)
          ?.split('-')
          .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
          .join(' ') ||
        '',
      description: route.meta?.description?.toString() || '',
      icon: (route.meta?.icon as string) || '',
      color: (route.meta?.color as string) || '',
      role: (route.meta?.role as string) || '',
    }
  })

  const title = computed(() => (path: string) => {
    const page = allPages.find((page) => page.path === path)
    return page ? page.title : ''
  })

  const breadcrumbs = computed(() => {
    const paths = ['', ...route.path.split('/').filter(Boolean)]
    const crumbs = allPages
      .filter((page) => page.path !== '/:path(.*)')
      .filter((page) => paths.includes(page.path.split('/').at(-1) ?? ''))
      .sort((a, b) => a.level - b.level)
      .map((page) => {
        return {
          title: page.title,
          disabled: route.path === page.path,
          href: page.path,
          icon: page.icon,
        }
      })
    return crumbs
  })

  const pages = computed(() => {
    return allPages
      .filter((page) => page.level < 2)
      .filter((page) => page.path !== '/:path(.*)')
      .filter((page) => page.role !== 'guest')
      .filter(
        (page) =>
          (!auth.isAuthenticated && ['restricted', 'public'].includes(page.role)) ||
          auth.isAuthenticated,
      )
  })

  const guard = computed(() => (path: string): boolean | string => {
    const page = allPages.find((page) => {
      const regexPath = new RegExp('^' + page.path.replace(/:[^/]+/g, '[^/]+') + '$')
      return regexPath.test(path)
    })
    if (!page) return false
    if (page.role === 'public') return true
    if (!auth.isAuthenticated && page.role == 'guest') return true
    if (auth.isAuthenticated && page.role == 'restricted') return true
    if (
      auth.isAuthenticated &&
      auth.user.privileges.some((privilege) => privilege.role == page.role)
    )
      return true
    if (!auth.isAuthenticated && page.role == 'restricted') return '/login'
    return false
  })

  return {
    pages,
    title,
    breadcrumbs,
    guard,
  }
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useNavigationStore, import.meta.hot))
}
