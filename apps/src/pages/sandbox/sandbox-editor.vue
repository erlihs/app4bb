<template>
  <v-bsb-editor
    v-model="text"
    @updated="updated"
    :toolbar="[
      'bold',
      'italic',
      'underline',
      'strike',
      'bulletList',
      'orderedList',
      'heading1',
      'heading2',
      'heading3',
    ]"
    toolbar-class="mb-4"
  />
  <br />
  <v-btn @click="Save">Save as HTML</v-btn>
  <br />
  <br />
  <hr />
  {{ text }}
</template>

<script setup lang="ts">
const text = ref(
  '<h1>What is Lorem Ipsum?</h1><p><strong>Lorem Ipsum</strong>is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s.</p>',
)

function updated(value: string) {
  console.log('updated', value)
}

function Save() {
  console.log('Saved:', text.value)
}
</script>
