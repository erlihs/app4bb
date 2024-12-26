import 'vuetify/styles'
import { createVuetify } from 'vuetify'
import { md3 } from 'vuetify/blueprints'
import light from '../themes/light'
import dark from '../themes/dark'
import defaults from '../themes/defaults'
import { aliases, mdi } from 'vuetify/iconsets/mdi-svg'
import icons from '../themes/icons'

export default createVuetify({
  blueprint: md3,
  theme: {
    defaultTheme: 'light',
    themes: {
      light,
      dark,
    },
  },
  defaults,
  icons: {
    defaultSet: 'mdi',
    aliases: {
      ...aliases,
      ...icons,
    },
    sets: {
      mdi,
    },
  },
})
