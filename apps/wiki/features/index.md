# Application

## Overview

The collection of core modules and services to host other features.

## Stories

::: tip
Use Wiki search to find implementation details
:::

Provide a Progressive Web application - Single page application

Look and feel:

- Theming, dark and light modes
- Material Design Blueprints
- Defaults configuration
- Accessibility

Navigation:

- Main menu
- Home page with shortcuts
- Breadcrumbs

Authentication:

- authentication & sign-up with email and password
- authentication & sign-up with Google
- email confirmation
- recovery of forgotten password

Proper authorization

Multi language support

Auditing

Common UI components

- Vuetify Component Library
- Table & Form
- Google Maps
- Camera and Microphone
- Drawing Pad
- Charts

Progressive Web Application:

- manifest, installation
- automated upgrade

## Data model

Tables with prefix `APP_`

## Api

[Open API Catalog](https://ocdojsus0urgcyf-bbdb.adb.eu-frankfurt-1.oraclecloudapps.com/ords/bsb/open-api-catalog/app-v1/)

## Pages

| Route Path            | Route Meta                                                                                                                                                     |
| --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| /                     | `{"title":"Welcome Home","description":"Welcome to the home page","icon":"$mdiHome","color":"#ABCDEF","role":"public"}`                                        |
| /path(.\*)            | `{"role":"public"}`                                                                                                                                            |
| /about                | `{"title":"About Our Platform","description":"Learn more about our platform and its capabilities","icon":"$mdiInformation","role":"public","color":"#FA8531"}` |
| /confirm-email/id     | `{"role":"restricted"}`                                                                                                                                        |
| /login                | `{"role":"guest"}`                                                                                                                                             |
| /recover-password     | `{"role":"guest"}`                                                                                                                                             |
| /reset-password/token | `{"role":"guest"}`                                                                                                                                             |
| /signup               | `{"role":"guest"}`                                                                                                                                             |

## Integrations

Sending of emails via Oracle Cloud Infrastructure
