<template>
  <v-row align="center">
    <v-col cols="12" xs="12" sm="6" md="6" lg="6" xl="6">
      <div v-show="!isEditing">
        <h1>Your games</h1>
        <v-alert v-show="message.length > 0" type="info" :text="message"></v-alert>
        <v-table density="compact">
          <thead>
            <tr>
              <th>Code</th>
              <th>Title</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in deals" :key="item.code">
              <td>{{ item.code }}</td>
              <td>{{ item.title }}</td>
              <td>{{ item.status }}</td>
              <td>
                <v-menu>
                  <template #activator="{ props }">
                    <v-btn
                      density="compact"
                      color="primary"
                      v-bind="props"
                      append-icon="$mdiMenuDown"
                    >
                      Select
                    </v-btn>
                  </template>
                  <v-list density="compact">
                    <v-list-item @click="copyGameLink(item.code)"
                      ><v-list-item-title>Copy game link</v-list-item-title></v-list-item
                    >
                    <v-list-item v-show="item.status == 'N'" @click="editGame(item.code)"
                      ><v-list-item-title>Edit game</v-list-item-title></v-list-item
                    >
                    <v-list-item v-show="item.status == 'A'" @click="playGame(item.id_play)"
                      ><v-list-item-title>Play</v-list-item-title></v-list-item
                    >
                    <v-list-item @click="cloneGame(item.code)"
                      ><v-list-item-title>Clone as a new game</v-list-item-title></v-list-item
                    >
                    <v-divider></v-divider>
                    <v-list-item v-show="item.status == 'N'" @click="activateGame(item.code, 'A')"
                      ><v-list-item-title>Activate</v-list-item-title></v-list-item
                    >
                    <v-list-item v-show="item.status == 'A'" @click="activateGame(item.code, 'N')"
                      ><v-list-item-title>Deactivate</v-list-item-title></v-list-item
                    >
                  </v-list>
                </v-menu>
              </td>
            </tr>
          </tbody>
        </v-table>
        <div class="text-right pt-4">
          <v-btn variant="outlined" @click="newGame()"> Create new </v-btn>
        </div>
      </div>

      <div v-show="isEditing">
        <h1>Edit game</h1>
        <v-form ref="dealForm" @submit.prevent="saveGame()">
          <v-text-field
            v-model="deal.title"
            label="Game title"
            :rules="rules.required"
          ></v-text-field>
          <v-select
            :rules="rules.required"
            label="Category"
            :items="tags"
            v-model="deal.tag"
          ></v-select>

          <div id="playContainer">
            <div class="d-flex flex-row">
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w1"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w2"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w3"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w4"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w5"
              ></v-textarea>
            </div>
            <div class="d-flex flex-row">
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w6"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w7"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w8"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w9"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w10"
              ></v-textarea>
            </div>
            <div class="d-flex flex-row">
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w11"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w12"
              ></v-textarea>
              <v-textarea
                readonly
                disabled
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w13"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w14"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w15"
              ></v-textarea>
            </div>
            <div class="d-flex flex-row">
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w16"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w17"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w18"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w19"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w20"
              ></v-textarea>
            </div>
            <div class="d-flex flex-row">
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w21"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w22"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w23"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w24"
              ></v-textarea>
              <v-textarea
                :rules="rules.required"
                no-resize
                rows="2"
                variant="outlined"
                v-model="deal.w25"
              ></v-textarea>
            </div>
          </div>
          <div class="text-right">
            <v-btn class="mr-2" type="submit">Save</v-btn>
            <v-btn variant="outlined" @click="isEditing = false">Cancel</v-btn>
          </div>
        </v-form>
        <br />
        <h2>Paste from clipboard</h2>
        <p>Paste text from clipboard and top 25 repeating words will be automatically inserted</p>
        <v-btn variant="outlined" @click="pasteFromClipboard()">Paste</v-btn>
        <br />
        <br />
        <h2>Sample games</h2>
        <p>Choose one of sample games and modify it as you wish</p>
        <v-btn class="mr-2" variant="outlined" @click="pasteFromSample('Eurovision')"
          >Eurovision</v-btn
        >
        <v-btn class="mr-2" variant="outlined" @click="pasteFromSample('Ice hockey')"
          >Ice hockey</v-btn
        >
        <v-btn class="mr-2" variant="outlined" @click="pasteFromSample('Agile')">Agile</v-btn>
      </div>
    </v-col>
  </v-row>
  <v-overlay v-model="loading"></v-overlay>
</template>

<script setup lang="ts">
definePage({
  meta: {
    title: 'Dealer',
    role: 'restricted',
  },
})
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { storeToRefs } from 'pinia'
import { useBullshitBingoStore } from '@/pages/bullshit-bingo/store'

const router = useRouter()
const store = useBullshitBingoStore()
const { deals, deal, dealer, tags } = storeToRefs(store)

const dealForm = ref(null)

const loading = computed(() => store.loading)
const isEditing = ref(false)
const message = ref('')

const rules = {
  required: [(v: unknown) => !!v || 'Required'],
}

onMounted(async () => {
  await store.init()
  await store.getDeals()
})

function copyGameLink(gamecode: string) {
  message.value = ''
  const link = (
    window.location.href.split('bullshitbingo')[0] +
    'bullshitbingo/join/' +
    gamecode
  ).replace(',', '')
  copyToClipboard(link)
  message.value = link + ' is coppied to your clipboard..'
}

async function playGame(id: number) {
  const hasJoined = await store.joinAsAdmin(id)
  if (hasJoined) router.push('/bullshit-bingo/play')
}

async function editGame(gamecode: string) {
  await store.setDeal(gamecode)
  isEditing.value = true
}

async function cloneGame(gamecode: string) {
  await store.setDeal(gamecode)
  deal.value.code = ''
  deal.value.id_play = -1
  isEditing.value = true
}

async function newGame() {
  await store.newDeal()
  isEditing.value = true
  deal.value.w13 = 'Bullshit Bingo'
}

async function saveGame() {
  if (dealForm.value) {
    const result = await (
      dealForm.value as unknown & { validate: () => { valid: boolean } }
    ).validate()
    if (result.valid) {
      deal.value.fullname = dealer.value.username
      deal.value.status = 'A'
      await store.saveDeal()
      isEditing.value = false
    }
  }
}

async function activateGame(gamecode: string, value: string) {
  await store.setDeal(gamecode)
  deal.value.status = value
  await store.saveDeal()
}

function pasteFromClipboard() {
  //const r = RegExp(/[^a-zĀ-ŽA-Z0-9 ]/g) //todo - unicode regexp;
  message.value = ''
  try {
    navigator.clipboard.readText().then((text) => {
      //text = text.replaceAll(r, "")
      const words = extractTopWords(text)
      deal.value.w1 = words[0]
      deal.value.w2 = words[1]
      deal.value.w3 = words[2]
      deal.value.w4 = words[3]
      deal.value.w5 = words[4]
      deal.value.w6 = words[5]
      deal.value.w7 = words[6]
      deal.value.w8 = words[7]
      deal.value.w9 = words[8]
      deal.value.w10 = words[9]
      deal.value.w11 = words[10]
      deal.value.w12 = words[11]
      deal.value.w13 = 'Bullshit Bingo'
      deal.value.w14 = words[12]
      deal.value.w15 = words[13]
      deal.value.w16 = words[14]
      deal.value.w17 = words[15]
      deal.value.w18 = words[16]
      deal.value.w19 = words[17]
      deal.value.w20 = words[18]
      deal.value.w21 = words[19]
      deal.value.w22 = words[20]
      deal.value.w23 = words[21]
      deal.value.w24 = words[22]
      deal.value.w25 = words[23]
    })
  } catch {
    message.value = "Didn't work out.. "
  }
}

function pasteFromSample(title: string) {
  const samples = [
    {
      title: 'Eurovision',
      tag: 'entertainment',
      w1: 'Happy tears',
      w2: 'Love song',
      w3: 'Fake rain',
      w4: 'Feathers',
      w5: 'Modulation',
      w6: 'Clearly political voting',
      w7: 'The UK gets 12 points',
      w8: 'Outfit change',
      w9: 'Streaker',
      w10: 'Rap',
      w11: 'Country not in Europe',
      w12: 'Mention of ABBA',
      w13: 'Bullshit Bingo',
      w14: 'Someone takes selfie',
      w15: 'Fireworks',
      w16: 'Wind machine',
      w17: 'Traditional costume',
      w18: 'Technical mallfunction',
      w19: 'Peace song',
      w20: 'Stairs',
      w21: 'Piano on stage',
      w22: 'Out of tune',
      w23: 'Good evening, Europe',
      w24: 'Smoke',
      w25: 'Wink at camera',
    },
    {
      title: 'Ice hockey',
      tag: 'entertainment',
      w1: 'Missed shot',
      w2: 'Empty net goal',
      w3: 'Penalty kill',
      w4: 'Fight',
      w5: 'Highsticking',
      w6: 'Short handed goal',
      w7: 'Two to nothing',
      w8: 'First scored',
      w9: 'Wave',
      w10: 'Coach yelling',
      w11: 'Referee gets injured',
      w12: 'Broken stick',
      w13: 'Bullshit Bingo',
      w14: 'One on one',
      w15: 'Overtime',
      w16: 'Powerplay goal',
      w17: 'Everybody lost puck',
      w18: 'Empty net',
      w19: 'Two many players on ice',
      w20: 'Three on five',
      w21: 'Hat trick',
      w22: 'Change of goalkeeper',
      w23: 'Video on goal',
      w24: 'Net out of position',
      w25: 'Spectator gets puck',
    },
    {
      title: 'Agile',
      tag: 'technology',
      w1: 'agile',
      w2: 'vision',
      w3: 'sprint',
      w4: 'increment',
      w5: 'standup',
      w6: 'release',
      w7: 'product owner',
      w8: 'scrummaster',
      w9: 'high performance',
      w10: 'burndown',
      w11: 'story points',
      w12: 'team',
      w13: 'Bullshit Bingo',
      w14: 'backlog',
      w15: 'user story',
      w16: 'epic',
      w17: 'task',
      w18: 'planning',
      w19: 'demo',
      w20: 'retrospection',
      w21: 'impedimemt',
      w22: 'transparency',
      w23: 'inspection',
      w24: 'adaptation',
      w25: 'scrum',
    },
  ]
  const sample = samples.filter((item) => item.title == title)[0]
  deal.value.title = sample.title
  deal.value.tag = sample.tag
  deal.value.w1 = sample.w1
  deal.value.w2 = sample.w2
  deal.value.w3 = sample.w3
  deal.value.w4 = sample.w4
  deal.value.w5 = sample.w5
  deal.value.w6 = sample.w6
  deal.value.w7 = sample.w7
  deal.value.w8 = sample.w8
  deal.value.w9 = sample.w9
  deal.value.w10 = sample.w10
  deal.value.w11 = sample.w11
  deal.value.w12 = sample.w12
  deal.value.w13 = sample.w13
  deal.value.w14 = sample.w14
  deal.value.w15 = sample.w15
  deal.value.w16 = sample.w16
  deal.value.w17 = sample.w17
  deal.value.w18 = sample.w18
  deal.value.w19 = sample.w19
  deal.value.w20 = sample.w20
  deal.value.w21 = sample.w21
  deal.value.w22 = sample.w22
  deal.value.w23 = sample.w23
  deal.value.w24 = sample.w24
  deal.value.w25 = sample.w25
}

function extractTopWords(text: string) {
  const words = text
    .split('.')
    .join(' ')
    .split(',')
    .join(' ')
    .split('!')
    .join(' ')
    .split('?')
    .join(' ')
    .split(' ')
    .filter((item) => item.length > 3)
    .filter((item) => item.length < 33)
  const wordCount: { [key: string]: number } = {}
  if (words) {
    words.forEach((word) => {
      if (Object.prototype.hasOwnProperty.call(wordCount, word)) {
        wordCount[word]++
      } else {
        wordCount[word] = 1
      }
    })
  }
  const sortedWords = Object.keys(wordCount).sort((a, b) => wordCount[b] - wordCount[a])
  return sortedWords
}

function copyToClipboard(str: string) {
  const el = document.createElement('textarea')
  el.value = str
  el.setAttribute('readonly', '')
  el.style.position = 'absolute'
  el.style.left = '-9999px'
  document.body.appendChild(el)
  const selection = document.getSelection()
  if (selection) {
    const selected = selection.rangeCount > 0 ? selection.getRangeAt(0) : false
    el.select()
    document.execCommand('copy')
    document.body.removeChild(el)
    if (selected) {
      selection.removeAllRanges()
      selection.addRange(selected)
    }
  }
}
</script>
