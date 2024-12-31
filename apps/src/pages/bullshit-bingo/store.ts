import { defineStore } from 'pinia'

interface IBullshitBingoTag {
  tag: string
}

interface IBullshitBingoDeal {
  id_play: number
  code: string
  tag: string
  fullname: string
  title: string
  status: string
  w1: string
  w2: string
  w3: string
  w4: string
  w5: string
  w6: string
  w7: string
  w8: string
  w9: string
  w10: string
  w11: string
  w12: string
  w13: string
  w14: string
  w15: string
  w16: string
  w17: string
  w18: string
  w19: string
  w20: string
  w21: string
  w22: string
  w23: string
  w24: string
  w25: string
}

interface IBullshitBingoPlay {
  error: string
  id: number
  fullname: string
  gamecode: string
  id_game: string
  tag: string
  title: string
  status: string
  players: number
  bingo: string
  bullshitbingo: string
  w1: string
  w2: string
  w3: string
  w4: string
  w5: string
  w6: string
  w7: string
  w8: string
  w9: string
  w10: string
  w11: string
  w12: string
  w13: string
  w14: string
  w15: string
  w16: string
  w17: string
  w18: string
  w19: string
  w20: string
  w21: string
  w22: string
  w23: string
  w24: string
  w25: string
  m1: string
  m2: string
  m3: string
  m4: string
  m5: string
  m6: string
  m7: string
  m8: string
  m9: string
  m10: string
  m11: string
  m12: string
  m13: string
  m14: string
  m15: string
  m16: string
  m17: string
  m18: string
  m19: string
  m20: string
  m21: string
  m22: string
  m23: string
  m24: string
  m25: string
  n1: string
  n2: string
  n3: string
  n4: string
  n5: string
  n6: string
  n7: string
  n8: string
  n9: string
  n10: string
  n11: string
  n12: string
  n13: string
  n14: string
  n15: string
  n16: string
  n17: string
  n18: string
  n19: string
  n20: string
  n21: string
  n22: string
  n23: string
  n24: string
  n25: string
}

interface IBullshitBingoChat {
  id: number
  status: string
  username: string
  message: string
}

type IBullshitBingoChats = Array<IBullshitBingoChat>
type IBullshitBingoDeals = Array<IBullshitBingoDeal>
type IBullshitBingoTags = Array<IBullshitBingoTag>

const http = useHttp({
  baseURL: (import.meta.env.DEV ? '/api/' : import.meta.env.VITE_API_URI) + 'bsb-v1/',
})

const api = {
  async getTags() {
    const response = await http.get('tags/')
    return (response.data as { tags: IBullshitBingoTags }).tags
  },

  async getDeals(tag: string, title: string, offset: number, limit: number) {
    //    const response = await http.get('deals/', { params: { tag, title, offset, limit } })
    const response = await http.get('deals/', { tag, title, offset, limit })
    return (response.data as { deals: IBullshitBingoDeals }).deals
  },

  async putDeal(
    code: string,
    tag: string,
    fullname: string,
    title: string,
    status: string,
    w1: string,
    w2: string,
    w3: string,
    w4: string,
    w5: string,
    w6: string,
    w7: string,
    w8: string,
    w9: string,
    w10: string,
    w11: string,
    w12: string,
    w13: string,
    w14: string,
    w15: string,
    w16: string,
    w17: string,
    w18: string,
    w19: string,
    w20: string,
    w21: string,
    w22: string,
    w23: string,
    w24: string,
    w25: string,
  ) {
    const response = await http.put('deal/', {
      code,
      tag,
      fullname,
      title,
      status,
      w1,
      w2,
      w3,
      w4,
      w5,
      w6,
      w7,
      w8,
      w9,
      w10,
      w11,
      w12,
      w13,
      w14,
      w15,
      w16,
      w17,
      w18,
      w19,
      w20,
      w21,
      w22,
      w23,
      w24,
      w25,
    })
    const data = response.data as { deals: IBullshitBingoDeals }
    return data.deals[0]
  },

  async getPlay(id: number) {
    const response = await http.get('play/' + id.toString())
    const data = response.data as { play: IBullshitBingoPlay[] }
    return data.play[0]
  },

  async postJoin(gamecode: string, username: string) {
    const response = await http.post('join/', { gamecode, username })
    const data = response.data as { play: IBullshitBingoPlay[] }
    return data.play[0]
  },

  async putMark(
    id: number,
    m1: string,
    m2: string,
    m3: string,
    m4: string,
    m5: string,
    m6: string,
    m7: string,
    m8: string,
    m9: string,
    m10: string,
    m11: string,
    m12: string,
    m13: string,
    m14: string,
    m15: string,
    m16: string,
    m17: string,
    m18: string,
    m19: string,
    m20: string,
    m21: string,
    m22: string,
    m23: string,
    m24: string,
    m25: string,
  ) {
    const response = await http.put('mark/', {
      id,
      m1,
      m2,
      m3,
      m4,
      m5,
      m6,
      m7,
      m8,
      m9,
      m10,
      m11,
      m12,
      m13,
      m14,
      m15,
      m16,
      m17,
      m18,
      m19,
      m20,
      m21,
      m22,
      m23,
      m24,
      m25,
    })
    const data = response.data as { play: IBullshitBingoPlay[] }
    return data.play[0]
  },

  async getChats(id: number) {
    const response = await http.get('chats/' + id.toString())
    return (response.data as { chat: IBullshitBingoChats }).chat
  },

  async putChat(id: number, status: string, message: string) {
    const response = await http.put('chat/', { id, status, message })
    return (response.data as { chat: IBullshitBingoChats }).chat
  },
}

export const useBullshitBingoStore = defineStore({
  id: 'bullshitbingo',
  state: () => ({
    tags: <IBullshitBingoTags>[],
    play: {} as IBullshitBingoPlay,
    chats: <IBullshitBingoChats>[],
    active: false,
    dealer: {
      username: '',
      fullname: '',
    },
    deals: <IBullshitBingoDeals>[],
    deal: <IBullshitBingoDeal>{},
    loading: false,
  }),
  getters: {
    hasJoined: (state) => state.play?.id != null,
    isDealer: (state) => state.dealer.fullname == state.play.fullname,
  },
  actions: {
    async init(): Promise<IBullshitBingoPlay> {
      const tags: IBullshitBingoTags = await api.getTags()
      this.tags = tags
      const appStore = useAppStore()
      this.dealer = appStore.auth.user
      //if (localStorage.getItem("bullshitbingo")) this.play = <IBullshitBingoPlay>JSON.parse(localStorage.getItem("bullshitbingo") as string)
      //else this.play = <IBullshitBingoPlay>{}
      return this.play
    },
    async join(gamecode: string, fullname: string) {
      this.init()
      this.loading = true
      if (gamecode != this.play.gamecode || fullname != this.play.fullname)
        this.play = await api.postJoin(gamecode, fullname)
      const result = this.play?.id != null
      if (result) {
        //localStorage.setItem("bullshitbingo", JSON.stringify(this.play))
        this.active = true
      }
      this.loading = false
      return result
    },
    async mark() {
      this.loading = true
      const play = await api.putMark(
        this.play.id,
        this.play.m1,
        this.play.m2,
        this.play.m3,
        this.play.m4,
        this.play.m5,
        this.play.m6,
        this.play.m7,
        this.play.m8,
        this.play.m9,
        this.play.m10,
        this.play.m11,
        this.play.m12,
        this.play.m13,
        this.play.m14,
        this.play.m15,
        this.play.m16,
        this.play.m17,
        this.play.m18,
        this.play.m19,
        this.play.m20,
        this.play.m21,
        this.play.m22,
        this.play.m23,
        this.play.m24,
        this.play.m25,
      )
      this.play = play
      localStorage.setItem('bullshitbingo', JSON.stringify(this.play))
      this.loading = false
    },
    async chat(message: string) {
      this.loading = true
      this.chats =
        message.length == 0
          ? await api.putChat(this.play.id, 'T', '.. typing')
          : await api.putChat(this.play.id, 'P', message)
      this.loading = false
    },
    async sync() {
      if (this.active) {
        this.chats = await api.putChat(this.play.id, 'N', ' ')
        this.play = await api.getPlay(this.play.id)
      }
    },
    async joinAsAdmin(id: number) {
      this.loading = true
      this.play = await api.getPlay(id)
      localStorage.setItem('bullshitbingo', JSON.stringify(this.play))
      this.active = true
      this.loading = false
      return true
    },
    async getDeals() {
      this.loading = true
      this.deals = await api.getDeals('*', '*', 0, 10)
      this.loading = false
    },
    async setDeal(gamecode: string) {
      this.deal = this.deals.filter((item) => item.code == gamecode)[0]
    },
    async newDeal() {
      this.deal = <IBullshitBingoDeal>{}
    },
    async saveDeal() {
      this.loading = true
      this.deal = await api.putDeal(
        this.deal.code,
        this.deal.tag,
        this.dealer.fullname,
        this.deal.title,
        this.deal.status,
        this.deal.w1,
        this.deal.w2,
        this.deal.w3,
        this.deal.w4,
        this.deal.w5,
        this.deal.w6,
        this.deal.w7,
        this.deal.w8,
        this.deal.w9,
        this.deal.w10,
        this.deal.w11,
        this.deal.w12,
        this.deal.w13,
        this.deal.w14,
        this.deal.w15,
        this.deal.w16,
        this.deal.w17,
        this.deal.w18,
        this.deal.w19,
        this.deal.w20,
        this.deal.w21,
        this.deal.w22,
        this.deal.w23,
        this.deal.w24,
        this.deal.w25,
      )
      await this.getDeals()
      this.loading = false
      return this.deal
    },
  },
  persist: {
    include: ['play'],
  },
})
