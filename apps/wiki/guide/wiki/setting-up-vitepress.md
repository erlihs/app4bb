# Setting up VitePress

## What is VitePress?

[VitePress](https://vitepress.dev/) is a modern, Vue.js-based static site generator designed specifically for writing and serving documentation. It's built on top of Vite, a fast and lean development server and build tool.

## Creating Wiki

1. Install VitePress in your web application directory so it can use same node packages and common resources.

```ps
cd apps
npm add -D vitepress
npx vitepress init
```

2. Follow the setup wizard.

```
Welcome to VitePress!
│
◇  Where should VitePress initialize the config?
│  ./wiki
│
◇  Site title:
│  Your site title
│
◇  Site description:
│  Your site description
│
◇  Theme:
│  Default Theme + Customization
│
◇  Use TypeScript for config and theme files?
│  Yes
│
◇  Add VitePress npm scripts to package.json?
│  Yes
│
└  Done! Now run npm run docs:dev and start writing.
```

3. To avoid conflict with Vue application, specify port for Vite and VitePress in `package.json`

```json
{
  "name": "apps",
  "version": "0.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite --port 5173",
    "preview": "vite preview --port 5173",
    "test:e2e": "start-server-and-test preview http://localhost:4173 'cypress run --e2e'",
    "test:e2e:dev": "start-server-and-test 'vite dev --port 4173' http://localhost:4173 'cypress open --e2e'",
    "docs:dev": "vitepress dev wiki --port 5174",
    "docs:preview": "vitepress preview wiki --port 5174"
    //other scripts
  }
  //dependencies, etc.
}
```

4. Also add `wiki` folder to prettier in `package.json`

```json
{
  "name": "apps",
  "version": "0.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "docs:format": "prettier --write wiki/"
    //other scripts
  }
  //dependencies, etc.
}
```

5. Add `cache` to `.gitignore` to prevent VitePress temporary files to be stores in repo.

6. Run VitePress

```ps
npm run docs:dev
```
