<template>
  <div class="editor-toolbar" :class="props.toolbarClass">
    <v-btn
      v-if="props.toolbar.includes('bold')"
      :variant="editor?.isActive('bold') ? 'outlined' : 'text'"
      density="comfortable"
      @click="editor?.chain().focus().toggleBold().run()"
      icon="$mdiFormatBold"
    />
    <v-btn
      v-if="props.toolbar.includes('italic')"
      :variant="editor?.isActive('italic') ? 'outlined' : 'text'"
      density="comfortable"
      @click="editor?.chain().focus().toggleItalic().run()"
      icon="$mdiFormatItalic"
    />
    <v-btn
      v-if="props.toolbar.includes('underline')"
      :variant="editor?.isActive('underline') ? 'outlined' : 'text'"
      density="comfortable"
      @click="editor?.chain().focus().toggleUnderline().run()"
      icon="$mdiFormatUnderline"
    />
    <v-btn
      v-if="props.toolbar.includes('strike')"
      :variant="editor?.isActive('strike') ? 'outlined' : 'text'"
      density="comfortable"
      @click="editor?.chain().focus().toggleStrike().run()"
      icon="$mdiFormatStrikethrough"
    />
    <v-btn
      v-if="props.toolbar.includes('bulletList')"
      :variant="editor?.isActive('bulletList') ? 'outlined' : 'text'"
      density="comfortable"
      @click="editor?.chain().focus().toggleBulletList().run()"
      icon="$mdiFormatListBulleted"
    />
    <v-btn
      v-if="props.toolbar.includes('orderedList')"
      :variant="editor?.isActive('orderedList') ? 'outlined' : 'text'"
      density="comfortable"
      @click="editor?.chain().focus().toggleOrderedList().run()"
      icon="$mdiFormatListNumbered"
    />
    <v-btn
      v-if="props.toolbar.includes('heading1')"
      :variant="editor?.isActive('heading', { level: 1 }) ? 'outlined' : 'text'"
      density="comfortable"
      @click="editor?.chain().focus().toggleHeading({ level: 1 }).run()"
      icon="$mdiFormatHeader1"
    />
    <v-btn
      v-if="props.toolbar.includes('heading2')"
      :variant="editor?.isActive('heading', { level: 2 }) ? 'outlined' : 'text'"
      density="comfortable"
      @click="editor?.chain().focus().toggleHeading({ level: 2 }).run()"
      icon="$mdiFormatHeader2"
    />
    <v-btn
      v-if="props.toolbar.includes('heading3')"
      :variant="editor?.isActive('heading', { level: 3 }) ? 'outlined' : 'text'"
      density="comfortable"
      @click="editor?.chain().focus().toggleHeading({ level: 3 }).run()"
      icon="$mdiFormatHeader3"
    />
  </div>
  <editor-content :editor="editor" />
</template>

<script setup lang="ts">
import { useEditor, EditorContent } from '@tiptap/vue-3'
import StarterKit from '@tiptap/starter-kit'
import Underline from '@tiptap/extension-underline'

const model = defineModel({ type: String, default: '' })

const props = defineProps({
  toolbar: {
    type: Array<string>,
    default: () => [],
  },
  toolbarClass: {
    type: String,
    default: '',
  },
})

const emits = defineEmits(['updated'])

const editor = useEditor({
  content: model.value,
  extensions: [StarterKit, Underline],
  onUpdate: ({ editor }) => {
    model.value = editor.getHTML()
    emits('updated', model.value)
  },
  onSelectionUpdate: ({ editor }) => {
    if (model.value !== editor.getHTML()) {
      model.value = editor.getHTML()
      emits('updated', model.value)
    }
  },
})

onBeforeUnmount(() => {
  if (editor) {
    editor.value?.destroy()
  }
})

defineExpose({
  editor,
})
</script>

<style>
.tiptap ol,
.tiptap ul {
  padding-left: 2em;
}
</style>
