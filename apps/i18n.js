#!/usr/bin/env node

import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url'
import axios from 'axios'

async function openAiTranslate(text, locale, API_KEY) {
  try {
    const response = await axios.post(
      'https://api.openai.com/v1/chat/completions',
      {
        model: 'gpt-4',
        messages: [
          { role: 'system', content: 'You are a translator.' },
          {
            role: 'user',
            content: `Translate the following text: "${text}" to: "${locale}". Output only translation itself, nothing else.`,
          },
        ],
      },
      {
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${API_KEY}`,
        },
      }
    )

    return response.data.choices[0].message.content.trim()
  } catch (error) {
    console.warn('[i18n] Error translating text:', error)
    throw error
  }
}

async function translateI18nFile(filePath, key, openAiApiKey) {
  try {
    const locale = path.basename(filePath, '.json')
    const content = fs.readFileSync(filePath, 'utf-8')
    const translations = JSON.parse(content)
    
    if (key && translations[key]) {
      const originalText = translations[key]
      console.log(`Translating key "${key}" to ${locale}...`)
      translations[key] = await openAiTranslate(originalText, locale, openAiApiKey)
    } else {
      for (const [k, value] of Object.entries(translations)) {
        if (typeof value === 'string') {
          console.log(`Translating key "${k}" to ${locale}...`)
          translations[k] = await openAiTranslate(value, locale, openAiApiKey)
        }
      }
    }
    
    fs.writeFileSync(filePath, JSON.stringify(translations, null, 2))
    console.log(`✓ Updated translations in ${filePath}`)
  } catch (error) {
    console.warn(`[i18n] Failed processing file ${filePath}:`, error)
  }
}

function findJsonFiles(dirPath) {
  let jsonFiles = []
  
  const items = fs.readdirSync(dirPath)
  
  for (const item of items) {
    const fullPath = path.join(dirPath, item)
    const stat = fs.statSync(fullPath)
    
    if (stat.isDirectory()) {
      jsonFiles = jsonFiles.concat(findJsonFiles(fullPath))
    } else if (stat.isFile() && item.endsWith('.json')) {
      jsonFiles.push(fullPath)
    }
  }
  
  return jsonFiles
}

async function main() {
  const args = process.argv.slice(2)
  let dirPath = '.'
  let key = null
  let locale = 'en'
  
  for (let i = 0; i < args.length; i++) {
    if (args[i] === '--path' && i + 1 < args.length) {
      dirPath = args[i + 1]
      i++
    } else if (args[i] === '--key' && i + 1 < args.length) {
      key = args[i + 1]
      i++
    }
  }
  
  console.log(`Scanning for JSON files in: ${dirPath}`)
  const jsonFiles = findJsonFiles(dirPath)
  
  const localeFiles = jsonFiles.filter(file => {
    const basename = path.basename(file)
    return /^[a-z]{2}\.json$/i.test(basename)
  })
  
  if (localeFiles.length === 0) {
    console.log('No locale JSON files found')
    process.exit(0)
  }
  
  console.log(`Found ${localeFiles.length} locale files`)
  
  for (const file of localeFiles) {
    locale = path.basename(file, '.json')
    if (locale !== 'en') 
      await translateI18nFile(file, locale, key)
  }
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  main().catch(console.error)
}
