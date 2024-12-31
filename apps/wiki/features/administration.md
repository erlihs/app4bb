# Application

## Overview

Provides ability to manage application settings, users and to monitor overall health.

## Stories

Dashboard:

- number of active users
- number of non-confirmed users
- number of active user sessions
- number of sent emails
- number of error emails
- number of stored files
- total size of stored files

Users:

- list, search by username
- lock / unlock
- send and e-mail

Audit records:

- list
- view details, copy to clipboard

Settings:

- list, search by key
- edit

## Data model

No new tables, using `APP_` tables

## Api

::: details Open API Manifest

```json
{
  "openapi": "3.0.0",
  "info": {
    "title": "ORDS generated API for adm-v1",
    "version": "1.0.0",
    "description": "Package for Admin"
  },
  "servers": [
    {
      "url": "https://localhost:8443/ords/bsb_dev/adm-v1/"
    }
  ],
  "paths": {
    "/audit/": {
      "get": {
        "description": "Retrieve a record from adm-v1",
        "responses": {
          "200": {
            "description": "The queried record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "items": {
                      "$ref": "#/components/schemas/RESULTSET"
                    }
                  }
                }
              }
            }
          }
        },
        "parameters": [
          {
            "name": "limit",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "offset",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "search",
            "in": "header",
            "schema": {
              "type": "string"
            }
          }
        ]
      }
    },
    "/setting/": {
      "post": {
        "description": "Create a new record on adm-v1",
        "responses": {
          "201": {
            "description": "The successfully created record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "errors": {
                      "$ref": "#/components/schemas/RESULTSET"
                    }
                  }
                }
              }
            }
          }
        },
        "parameters": [
          {
            "name": "content",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "id",
            "in": "header",
            "schema": {
              "type": "string"
            }
          }
        ]
      }
    },
    "/settings/": {
      "get": {
        "description": "Retrieve a record from adm-v1",
        "responses": {
          "200": {
            "description": "The queried record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "items": {
                      "$ref": "#/components/schemas/RESULTSET"
                    }
                  }
                }
              }
            }
          }
        },
        "parameters": [
          {
            "name": "limit",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "offset",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "search",
            "in": "header",
            "schema": {
              "type": "string"
            }
          }
        ]
      }
    },
    "/status/": {
      "get": {
        "description": "Retrieve a record from adm-v1",
        "responses": {
          "200": {
            "description": "The queried record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "status": {
                      "$ref": "#/components/schemas/RESULTSET"
                    }
                  }
                }
              }
            }
          }
        },
        "parameters": []
      }
    },
    "/user_lock/": {
      "post": {
        "description": "Create a new record on adm-v1",
        "responses": {
          "201": {
            "description": "The successfully created record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {}
                }
              }
            }
          }
        },
        "parameters": [
          {
            "name": "uuid",
            "in": "header",
            "schema": {
              "type": "string"
            }
          }
        ]
      }
    },
    "/user_unlock/": {
      "post": {
        "description": "Create a new record on adm-v1",
        "responses": {
          "201": {
            "description": "The successfully created record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {}
                }
              }
            }
          }
        },
        "parameters": [
          {
            "name": "uuid",
            "in": "header",
            "schema": {
              "type": "string"
            }
          }
        ]
      }
    },
    "/users/": {
      "get": {
        "description": "Retrieve a record from adm-v1",
        "responses": {
          "200": {
            "description": "The queried record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "items": {
                      "$ref": "#/components/schemas/RESULTSET"
                    }
                  }
                }
              }
            }
          }
        },
        "parameters": [
          {
            "name": "limit",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "offset",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "search",
            "in": "header",
            "schema": {
              "type": "string"
            }
          }
        ]
      }
    }
  },
  "components": {
    "schemas": {
      "RESULTSET": {
        "type": "string"
      }
    }
  }
}
```

:::

## Pages

| Route Path | Route Meta                                                                                                                                        |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| /admin     | `{  "title": "Admin",  "description": "Administration of users, settings, etc.",  "icon": "$mdiSecurity",  "color": "#EEEEEE",  "role": "ADMIN"}` |

## Integrations

Sending of emails
