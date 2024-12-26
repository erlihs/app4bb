import { defineConfig } from 'vitepress'
import videoPlugin from './markdown-it-video'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: 'Bullshit Bingo',
  description: 'Release the energy to focus on business',
  head: [['link', { rel: 'icon', href: '/favicon.ico' }]],
  markdown: {
    config: (md) => {
      // use more markdown-it plugins!
      md.use(videoPlugin)
    },
  },
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    logo: '/logo.png',
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Bullshit Bingo', link: 'https://bsbingo.me' },
      { text: 'Apps', link: 'https://apps.bsbingo.me' },
      { text: 'Introduction', link: '/introduction/' },
      { text: 'Guide', link: '/guide/' },
    ],
    search: {
      provider: 'local',
    },
    sidebar: {
      '/introduction/': [
        {
          text: 'Why?',
          items: [
            { text: 'Vision', link: '/introduction/vision' },
            { text: 'Lean canvas', link: '/introduction/lean-canvas' },
            { text: 'Roadmap', link: '/introduction/roadmap' },
          ],
        },
        {
          text: 'Who?',
          items: [
            { text: 'Skills', link: '/introduction/skills' },
            { text: 'Habits', link: '/introduction/habits' },
            { text: 'AI', link: '/introduction/ai' },
          ],
        },
        {
          text: 'How?',
          items: [
            { text: 'Design', link: '/introduction/design' },
            { text: 'Architecture', link: '/introduction/architecture' },
            { text: 'Quality', link: '/introduction/quality' },
          ],
        },
      ],
      '/guide/': [
        {
          text: 'Getting started',
          items: [
            { text: 'Prerequisites', link: '/guide/getting-started/prerequisites' },
            { text: 'Create project', link: '/guide/getting-started/create-project' },
          ],
        },
        {
          text: 'Landing page',
          items: [
            { text: 'Branding and style', link: '/guide/landing-page/branding-and-style' },
            { text: 'Landing page', link: '/guide/landing-page/landing-page' },
            { text: 'Search engines', link: '/guide/landing-page/seo' },
          ],
        },
        {
          text: 'Web application',
          items: [
            { text: 'Install Vite + Vue + TS', link: '/guide/web-application/install-vite-vue-ts' },
            { text: 'File Based Routing', link: '/guide/web-application/file-based-routing' },
            {
              text: 'UI Component Framework',
              link: '/guide/web-application/ui-component-framework',
            },
            { text: 'Multi Language Support', link: '/guide/web-application/i18n' },
            { text: 'State Management', link: '/guide/web-application/state-management' },
            { text: 'Auto Imports', link: '/guide/web-application/auto-imports' },
            { text: 'Application Layout', link: '/guide/web-application/application-layout' },
            {
              text: 'Backend',
              collapsed: true,
              items: [
                { text: 'Oracle Database', link: '/guide/web-application/back-end/oci' },
                {
                  text: 'Best practices',
                  link: '/guide/web-application/back-end/oci-best-practices',
                },
                {
                  text: 'Naming conventions',
                  link: '/guide/web-application/back-end/oci-naming-conventions',
                },
                { text: 'Hands on', link: '/guide/web-application/back-end/oci-hands-on' },
                { text: 'Advanced tips', link: '/guide/web-application/back-end/oci-advanced' },
              ],
            },
            {
              text: 'Consuming Web Services',
              link: '/guide/web-application/consuming-web-services',
            },
          ],
        },
        {
          text: 'Wiki',
          items: [
            { text: 'Setting up VitePress', link: '/guide/wiki/setting-up-vitepress' },
            { text: 'VitePress configuration', link: '/guide/wiki/vitepress-configuration' },
            { text: 'Custom markdown', link: '/guide/wiki/custom-markdown' },
          ],
        },
      ],
    },

    socialLinks: [{ icon: 'github', link: 'https://github.com/vuejs/vitepress' }],
  },
})
