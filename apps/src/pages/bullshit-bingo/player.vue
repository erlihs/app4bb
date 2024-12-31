<template>
  <v-row align="center">
    <v-col cols="12" xs="12" sm="6" md="6" lg="6" xl="6">
      <h1>
        {{ play.title
        }}<v-badge v-show="isDealer" inline color="primary" content="dealer"></v-badge>
      </h1>

      <p class="text-right pb-2 pt-4">
        Number of active players in game:
        <v-badge color="info" :content="play.players" inline></v-badge>
      </p>

      <div id="playContainer">
        <div class="d-flex flex-row">
          <v-responsive
            @click="mark(1)"
            :aspect-ratio="4 / 3"
            :class="play.m1"
            class="word align-center"
            >{{ play.w1 }}</v-responsive
          >
          <v-responsive
            @click="mark(2)"
            :aspect-ratio="4 / 3"
            :class="play.m2"
            class="word align-center"
            >{{ play.w2 }}</v-responsive
          >
          <v-responsive
            @click="mark(3)"
            :aspect-ratio="4 / 3"
            :class="play.m3"
            class="word align-center"
            >{{ play.w3 }}</v-responsive
          >
          <v-responsive
            @click="mark(4)"
            :aspect-ratio="4 / 3"
            :class="play.m4"
            class="word align-center"
            >{{ play.w4 }}</v-responsive
          >
          <v-responsive
            @click="mark(5)"
            :aspect-ratio="4 / 3"
            :class="play.m5"
            class="word align-center"
            >{{ play.w5 }}</v-responsive
          >
        </div>
        <div class="d-flex flex-row">
          <v-responsive
            @click="mark(6)"
            :aspect-ratio="4 / 3"
            :class="play.m6"
            class="word align-center"
            >{{ play.w6 }}</v-responsive
          >
          <v-responsive
            @click="mark(7)"
            :aspect-ratio="4 / 3"
            :class="play.m7"
            class="word align-center"
            >{{ play.w7 }}</v-responsive
          >
          <v-responsive
            @click="mark(8)"
            :aspect-ratio="4 / 3"
            :class="play.m8"
            class="word align-center"
            >{{ play.w8 }}</v-responsive
          >
          <v-responsive
            @click="mark(9)"
            :aspect-ratio="4 / 3"
            :class="play.m9"
            class="word align-center"
            >{{ play.w9 }}</v-responsive
          >
          <v-responsive
            @click="mark(10)"
            :aspect-ratio="4 / 3"
            :class="play.m10"
            class="word align-center"
            >{{ play.w10 }}</v-responsive
          >
        </div>
        <div class="d-flex flex-row">
          <v-responsive
            @click="mark(11)"
            :aspect-ratio="4 / 3"
            :class="play.m11"
            class="word align-center"
            >{{ play.w11 }}</v-responsive
          >
          <v-responsive
            @click="mark(12)"
            :aspect-ratio="4 / 3"
            :class="play.m12"
            class="word align-center"
            >{{ play.w12 }}</v-responsive
          >
          <v-responsive
            @click="mark(13)"
            :aspect-ratio="4 / 3"
            :class="play.m13"
            class="word align-center"
            >{{ play.w13 }}</v-responsive
          >
          <v-responsive
            @click="mark(14)"
            :aspect-ratio="4 / 3"
            :class="play.m14"
            class="word align-center"
            >{{ play.w14 }}</v-responsive
          >
          <v-responsive
            @click="mark(15)"
            :aspect-ratio="4 / 3"
            :class="play.m15"
            class="word align-center"
            >{{ play.w15 }}</v-responsive
          >
        </div>
        <div class="d-flex flex-row">
          <v-responsive
            @click="mark(16)"
            :aspect-ratio="4 / 3"
            :class="play.m16"
            class="word align-center"
            >{{ play.w16 }}</v-responsive
          >
          <v-responsive
            @click="mark(17)"
            :aspect-ratio="4 / 3"
            :class="play.m17"
            class="word align-center"
            >{{ play.w17 }}</v-responsive
          >
          <v-responsive
            @click="mark(18)"
            :aspect-ratio="4 / 3"
            :class="play.m18"
            class="word align-center"
            >{{ play.w18 }}</v-responsive
          >
          <v-responsive
            @click="mark(19)"
            :aspect-ratio="4 / 3"
            :class="play.m19"
            class="word align-center"
            >{{ play.w19 }}</v-responsive
          >
          <v-responsive
            @click="mark(20)"
            :aspect-ratio="4 / 3"
            :class="play.m20"
            class="word align-center"
            >{{ play.w20 }}</v-responsive
          >
        </div>
        <div class="d-flex flex-row">
          <v-responsive
            @click="mark(21)"
            :aspect-ratio="4 / 3"
            :class="play.m21"
            class="word align-center"
            >{{ play.w21 }}</v-responsive
          >
          <v-responsive
            @click="mark(22)"
            :aspect-ratio="4 / 3"
            :class="play.m22"
            class="word align-center"
            >{{ play.w22 }}</v-responsive
          >
          <v-responsive
            @click="mark(23)"
            :aspect-ratio="4 / 3"
            :class="play.m23"
            class="word align-center"
            >{{ play.w23 }}</v-responsive
          >
          <v-responsive
            @click="mark(24)"
            :aspect-ratio="4 / 3"
            :class="play.m24"
            class="word align-center"
            >{{ play.w24 }}</v-responsive
          >
          <v-responsive
            @click="mark(25)"
            :aspect-ratio="4 / 3"
            :class="play.m25"
            class="word align-center"
            >{{ play.w25 }}</v-responsive
          >
        </div>
        <v-overlay v-model="loading"></v-overlay>
      </div>

      <v-container fluid>
        <v-row>
          <v-col>
            <p>
              <strong>{{ play.bullshitbingo ? play.bullshitbingo : 'Nobody' }}</strong> has Bullshit
              Bingo!
            </p>
          </v-col>
          <v-col class="text-right">
            <v-dialog v-model="dialog" width="auto">
              <template #activator="{ props }">
                <v-btn color="primary" variant="outlined" v-bind="props"> Need help? </v-btn>
              </template>
              <v-card>
                <v-card-text>
                  <p>
                    Press on <span class="help-N">white</span> field when you hear the word of that
                    field for first time. It will become
                    <span class="help-P">orange</span> (pending) until majority of players will mark
                    it and it will become <span class="help-C">green</span> (confirmed)). You can
                    press on orange to undo.
                  </p>
                  <p>
                    Each player has the same words but different order. Goal is to get full line
                    either horizontally, vertically, or diagonnally with five greens through the
                    center
                    <strong>Bullshit Bingo</strong> field.
                  </p>
                  <p>First player who achieves that gets instant Bullshit Bingo victory.</p>
                </v-card-text>
                <v-card-actions>
                  <v-btn color="primary" block @click="dialog = false">Got it</v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
          </v-col>
        </v-row>
      </v-container>
    </v-col>
    <v-col>
      <v-responsive
        id="messageContainer"
        :aspect-ratio="4 / 3"
        :height="messageContainerHeight()"
        class="overflow-y-auto"
      >
        <v-card
          v-for="chat in chats.slice().reverse()"
          :key="chat.id"
          density="compact"
          class="ma-2"
          :class="[
            chat.username == play.fullname ? 'card-O' : 'card-' + chat.status,
            chat.username == play.fullname ? 'ml-8' : '',
          ]"
        >
          <v-card-title>{{ chat.username }}</v-card-title>
          <v-card-text>{{ chat.message }}</v-card-text>
        </v-card>
      </v-responsive>

      <v-textarea
        id="messageText"
        class="pt-2"
        @keydown="type()"
        @keyup.enter="send()"
        label="your message"
        v-model="messageText"
        rows="2"
        prepend-icon="$mdiComment"
      ></v-textarea>
      <div class="text-right">
        <v-btn prepend-icon="$mdiSend" @click="send"> Send </v-btn>
      </div>
    </v-col>
  </v-row>
</template>

<script setup lang="ts">
definePage({
  meta: {
    title: 'Player',
    role: 'public',
  },
})

import { ref, onMounted, onUnmounted } from 'vue'
import { storeToRefs } from 'pinia'
import { useBullshitBingoStore } from '@/pages/bullshit-bingo/store'

const dialog = ref(false)
const loading = ref(false)
const typing = ref(false)

const store = useBullshitBingoStore()
const { play, chats, isDealer } = storeToRefs(store)

const messageText = ref('')

let interval10: unknown
onMounted(async () => {
  await store.init()
  interval10 = setInterval(async () => {
    console.log('tick 10s')
    if (!loading.value) {
      await store.sync()
      messageContainerScroll()
      typing.value = false
    }
  }, 10000)
})
onUnmounted(() => {
  clearInterval(interval10 as number)
})

function messageContainerHeight() {
  return document.getElementById('playContainer')?.clientHeight || '50%'
}

function messageContainerScroll() {
  const element = document.getElementById('messageContainer')
  if (element) element.scrollTop = element.scrollHeight
}

function messageTextFocus() {
  const element = document.getElementById('messageText')
  if (element) element.focus()
}

async function mark(index: number) {
  loading.value = true
  if (index == 1) play.value.m1 = play.value.m1 == 'C' ? 'C' : play.value.m1 == 'N' ? 'P' : 'N'
  if (index == 2) play.value.m2 = play.value.m2 == 'C' ? 'C' : play.value.m2 == 'N' ? 'P' : 'N'
  if (index == 3) play.value.m3 = play.value.m3 == 'C' ? 'C' : play.value.m3 == 'N' ? 'P' : 'N'
  if (index == 4) play.value.m4 = play.value.m4 == 'C' ? 'C' : play.value.m4 == 'N' ? 'P' : 'N'
  if (index == 5) play.value.m5 = play.value.m5 == 'C' ? 'C' : play.value.m5 == 'N' ? 'P' : 'N'
  if (index == 6) play.value.m6 = play.value.m6 == 'C' ? 'C' : play.value.m6 == 'N' ? 'P' : 'N'
  if (index == 7) play.value.m7 = play.value.m7 == 'C' ? 'C' : play.value.m7 == 'N' ? 'P' : 'N'
  if (index == 8) play.value.m8 = play.value.m8 == 'C' ? 'C' : play.value.m8 == 'N' ? 'P' : 'N'
  if (index == 9) play.value.m9 = play.value.m9 == 'C' ? 'C' : play.value.m9 == 'N' ? 'P' : 'N'
  if (index == 10) play.value.m10 = play.value.m10 == 'C' ? 'C' : play.value.m10 == 'N' ? 'P' : 'N'
  if (index == 11) play.value.m11 = play.value.m11 == 'C' ? 'C' : play.value.m11 == 'N' ? 'P' : 'N'
  if (index == 12) play.value.m12 = play.value.m12 == 'C' ? 'C' : play.value.m12 == 'N' ? 'P' : 'N'
  if (index == 13) play.value.m13 = play.value.m13 == 'C' ? 'C' : play.value.m13 == 'N' ? 'P' : 'N'
  if (index == 14) play.value.m14 = play.value.m14 == 'C' ? 'C' : play.value.m14 == 'N' ? 'P' : 'N'
  if (index == 15) play.value.m15 = play.value.m15 == 'C' ? 'C' : play.value.m15 == 'N' ? 'P' : 'N'
  if (index == 16) play.value.m16 = play.value.m16 == 'C' ? 'C' : play.value.m16 == 'N' ? 'P' : 'N'
  if (index == 17) play.value.m17 = play.value.m17 == 'C' ? 'C' : play.value.m17 == 'N' ? 'P' : 'N'
  if (index == 18) play.value.m18 = play.value.m18 == 'C' ? 'C' : play.value.m18 == 'N' ? 'P' : 'N'
  if (index == 19) play.value.m19 = play.value.m19 == 'C' ? 'C' : play.value.m19 == 'N' ? 'P' : 'N'
  if (index == 20) play.value.m20 = play.value.m20 == 'C' ? 'C' : play.value.m20 == 'N' ? 'P' : 'N'
  if (index == 21) play.value.m21 = play.value.m21 == 'C' ? 'C' : play.value.m21 == 'N' ? 'P' : 'N'
  if (index == 22) play.value.m22 = play.value.m22 == 'C' ? 'C' : play.value.m22 == 'N' ? 'P' : 'N'
  if (index == 23) play.value.m23 = play.value.m23 == 'C' ? 'C' : play.value.m23 == 'N' ? 'P' : 'N'
  if (index == 24) play.value.m24 = play.value.m24 == 'C' ? 'C' : play.value.m24 == 'N' ? 'P' : 'N'
  if (index == 25) play.value.m25 = play.value.m25 == 'C' ? 'C' : play.value.m25 == 'N' ? 'P' : 'N'
  await store.mark()
  loading.value = false
}

async function send() {
  loading.value = true
  await store.chat(messageText.value)
  messageText.value = ''
  messageContainerScroll()
  loading.value = false
  messageTextFocus()
}

function type() {
  if (!typing.value) store.chat('')
  typing.value = true
  messageContainerScroll()
}
</script>

<style scoped>
.word {
  width: 20%;
  flex: flex-wrap;
  border: 1px solid gray;
  padding: 1px;
  text-align: center;
  cursor: pointer;
  overflow-wrap: break-word;
  word-wrap: break-word;
  -ms-word-break: break-all;
  word-break: break-all;
  word-break: break-word;
  -ms-hyphens: auto;
  -moz-hyphens: auto;
  -webkit-hyphens: auto;
  hyphens: auto;
}
.C,
.help-C {
  background-color: greenyellow;
}

.P,
.help-P {
  background-color: goldenrod;
}

.N,
.help-N {
  background-color: whitesmoke;
}

.card-P {
  background-color: lightblue;
}

.card-D {
  background-color: lightcyan;
}

.card-B {
  background-color: lightyellow;
}

.card-T {
  background-color: lightgray;
}

.card-O {
  background-color: lightskyblue;
}
</style>
