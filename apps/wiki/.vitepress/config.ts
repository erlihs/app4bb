import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: 'Bullshit Bingo',
  description: 'Release the energy to focus on business',
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Introduction', link: '/introduction/' },
      { text: 'Guide', link: '/guide/' },
    ],

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
      ],
    },

    socialLinks: [{ icon: 'github', link: 'https://github.com/vuejs/vitepress' }],
  },
})
