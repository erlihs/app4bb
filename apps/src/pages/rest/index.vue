<template>
  <v-container>
    <h1>{{ manifest.info.title }}<v-badge :content="manifest.info.version" /></h1>
    <p v-html="marked(manifest.info.description)"></p>
    <div v-for="tag in tags" :key="tag.name" class="mt-4">
      <h2>{{ tag.name }}</h2>
      <p>{{ tag.description }}</p>
      <v-expansion-panels>
        <v-expansion-panel
          v-for="path in paths.filter((item) => item.tag === tag.name)"
          :key="path.path"
        >
          <v-expansion-panel-title>
            <v-chip class="mr-4" :text="path.method" :color="path.color" />
            <strong>{{ path.path }}</strong>
            <v-spacer />
            <v-icon v-if="path.security" icon="$mdiLock" />
          </v-expansion-panel-title>
          <v-expansion-panel-text>
            <v-row>
              <v-col>
                <p>{{ path.description }}</p>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12" md="6">
                <p><strong>Parameters</strong></p>
                //todo
              </v-col>
              <v-col cols="12" md="6">
                <p><strong>Response</strong></p>
                //todo
              </v-col>
            </v-row>
            <v-row>
              <v-col>
                <v-btn @click="handleExecute(path.path, path.method)">Execute</v-btn>
              </v-col>
            </v-row>
            <v-row>
              <v-col>
                <v-textarea label="Result" rows="5" v-model="resultPretty"> </v-textarea>
              </v-col>
            </v-row>
          </v-expansion-panel-text>
        </v-expansion-panel>
      </v-expansion-panels>
    </div>
  </v-container>
</template>

<script setup lang="ts">
definePage({
  meta: {
    title: 'Rest API',
    description: 'Rest Api documentation',
    icon: '$mdiApi',
    color: '#D7CCC8',
    role: 'public',
  },
})

import { marked } from 'marked'

const { startLoading, stopLoading } = useUiStore()

import manifestJson from './manifest.json'
const manifest = ref(manifestJson)

// Type definitions for API Path
interface ApiParameter {
  name: string
  in: string
  required: boolean
  description: string
  schema: {
    type: string
    [key: string]: unknown
  }
}

interface ApiResponse {
  code: number
  description: string
  content?: unknown
}

interface ApiPathItem {
  tag: string
  method: string
  path: string
  description: string
  parameters: ApiParameter[]
  requestBody?: unknown
  responses: ApiResponse[]
  security: boolean
  color: string
}

const tags = computed(() =>
  manifest.value.tags.map((tag) => {
    return {
      name: tag.name,
      description: tag.description,
    }
  }),
)

const http = useHttp({
  baseURL: import.meta.env.DEV ? '/api/' : import.meta.env.VITE_API_URI,
  convertKeys: 'snake_to_camel',
})

const result = ref<Record<string, unknown>>({})

const resultPretty = computed(() => {
  const json = JSON.stringify(result.value, null, 2)
  return json
})

const handleExecute = async (path: string, method: string) => {
  startLoading()
  result.value = {}
  if (method.toUpperCase() === 'GET') {
    const { data } = await http.get(path)
    result.value = data as Record<string, unknown>
  }
  stopLoading()
}

const paths = computed<ApiPathItem[]>(() => {
  const result: ApiPathItem[] = []
  const pathsObj = manifest.value.paths

  Object.entries(pathsObj).forEach(([path, methodsObj]) => {
    Object.entries(methodsObj).forEach(([method, details]) => {
      const tag = details.tags && details.tags.length > 0 ? details.tags[0] : ''
      const parameters =
        'parameters' in details ? (details.parameters as ApiParameter[]) : ([] as ApiParameter[])

      const responses = details.responses
        ? Object.entries(details.responses).map(([code, response]: [string, unknown]) => {
            let content
            const typedResponse = response as {
              content?: { 'application/json'?: { schema?: { properties?: unknown } } }
              description?: string
            }
            if (
              typedResponse.content &&
              typedResponse.content['application/json'] &&
              typedResponse.content['application/json'].schema
            ) {
              const schema = typedResponse.content['application/json'].schema

              if (schema.properties) {
                content = schema.properties
              } else {
                content = schema
              }
            } else {
              content = undefined
            }

            return {
              code: parseInt(code),
              description: typedResponse.description || '',
              content,
            }
          })
        : []

      result.push({
        tag,
        method: method.toUpperCase(),
        color:
          method.toUpperCase() === 'GET'
            ? 'green'
            : method.toUpperCase() === 'POST'
              ? 'blue'
              : method.toUpperCase() === 'PUT'
                ? 'orange'
                : 'red',
        path,
        description: details.description || '',
        parameters,
        requestBody:
          'requestBody' in details &&
          details.requestBody &&
          typeof details.requestBody === 'object' &&
          details.requestBody !== null &&
          'content' in details.requestBody &&
          details.requestBody.content &&
          typeof details.requestBody.content === 'object' &&
          details.requestBody.content !== null &&
          'application/json' in details.requestBody.content
            ? details.requestBody.content['application/json']
            : '',
        responses,
        security:
          'security' in details && Array.isArray(details.security) && details.security.length > 0
            ? true
            : false,
      })
    })
  })

  return result
})
</script>
