import { defineConfig } from 'vitepress'
import videoPlugin from './markdown-it-video'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: 'Bullshit Bingo',
  description: 'Release the energy to focus on business',
  head: [
    ['link', { rel: 'icon', href: '/favicon.ico' }],
    [
      'script',
      {
        async: '',
        src: 'https://www.googletagmanager.com/gtag/js?id=G-N0KY026CJS',
      },
    ],
    [
      'script',
      {},
      "window.dataLayer = window.dataLayer || [];\nfunction gtag(){dataLayer.push(arguments);}\ngtag('js', new Date());\ngtag('config', 'G-N0KY026CJS');",
    ],
  ],
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
      { text: 'Features', link: '/features/' },
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
            {
              text: 'Advanced UI Components',
              collapsed: true,
              items: [
                {
                  text: 'Overview',
                  link: '/guide/web-application/advanced-ui-components/',
                },
                {
                  text: 'Chart',
                  link: '/guide/web-application/advanced-ui-components/chart',
                },
                {
                  text: 'Editor',
                  link: '/guide/web-application/advanced-ui-components/editor',
                },
                { text: 'Map', link: '/guide/web-application/advanced-ui-components/map' },
                {
                  text: 'Media',
                  link: '/guide/web-application/advanced-ui-components/media',
                },
                { text: 'Form', link: '/guide/web-application/advanced-ui-components/form' },
                { text: 'Pad', link: '/guide/web-application/advanced-ui-components/pad' },
                {
                  text: 'Table',
                  link: '/guide/web-application/advanced-ui-components/table',
                },
                {
                  text: 'Share',
                  link: '/guide/web-application/advanced-ui-components/share',
                },
              ],
            },
            { text: 'Testing', link: '/guide/web-application/testing' },
            {
              text: 'Authentication',
              collapsed: true,
              items: [
                {
                  text: 'Concepts',
                  link: '/guide/web-application/authentication/authentication-concepts',
                },
                {
                  text: 'Services',
                  link: '/guide/web-application/authentication/authentication-services',
                },
                {
                  text: 'Application',
                  link: '/guide/web-application/authentication/authentication-in-app',
                },
              ],
            },
            { text: 'Authorization', link: '/guide/web-application/authorization' },
            { text: 'Auditing', link: '/guide/web-application/auditing' },
            {
              text: 'Sign up',
              collapsed: true,
              items: [
                {
                  text: 'Sign up',
                  link: '/guide/web-application/signup/signup',
                },
                {
                  text: 'Confirm email',
                  link: '/guide/web-application/signup/confirm-email',
                },
                {
                  text: 'Recover password',
                  link: '/guide/web-application/signup/recover-password',
                },
                {
                  text: 'Social signup',
                  link: '/guide/web-application/signup/social-signup',
                },
              ],
            },
            { text: 'Progressive Web Application', link: '/guide/web-application/pwa' },
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
        {
          text: 'Host and deploy',
          items: [
            { text: 'Domain name', link: '/guide/hosting/domain-name' },
            { text: 'Hosting', link: '/guide/hosting/hosting' },
            { text: 'Web Server Configuration', link: '/guide/hosting/web-server-configuration' },
            { text: 'Analytics', link: '/guide/hosting/analytics' },
            { text: 'Deployment', link: '/guide/hosting/deployment' },
            { text: 'Local DB Environment', link: '/guide/hosting/local-db-environment' },
          ],
        },
      ],
      '/features/': [
        {
          text: 'Application',
          items: [
            { text: 'Application', link: '/features/' },
            { text: 'Administration', link: '/features/administration' },
          ],
        },
        {
          text: 'Fun & Leisure',
          items: [
            { text: 'Chuck Norris', link: '/features/chuck-norris' },
            { text: 'Bullshit Bingo', link: '/features/bullshit-bingo' },
          ],
        },
        {
          text: 'Productivity',
          items: [{ text: 'Street Agent', link: '/features/street-agent' }],
        },
        { text: 'Building New Features', link: '/features/building-new-features' },
      ],
    },

    socialLinks: [{ icon: 'github', link: 'https://github.com/erlihs' }],
  },
})
