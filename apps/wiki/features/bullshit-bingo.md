# Application

## Overview

This is a social game for events like Eurovision and World Ice Hockey Championship. There are 25 Event related words on the board. When you hear the word, click the word. If other players will also mark that word, it will become green. Each player has the same words but different order. Goal is to get full green line either horizontally, vertically, or diagonally with five greens through the center. Whoever does it first, wins **Bullshit Bingo**.

## Stories

Join view

- enter game code and name or nick name. No need to authorize.

Players view:

- board with 25 words, possibility to mark
- chat to talk with other players and for bot to announce the winner

Dealers view:

- for authorized users only
- can create games
- can share invitation links
- can enable and disable games

## Data model

- BSB_GAMES
- BSB_PLAYS
- BSB_CHATS

## Api

::: details Open API Manifest

```json
{
  "openapi": "3.0.0",
  "info": {
    "title": "ORDS generated API for bsb-v1",
    "version": "1.0.0",
    "description": "package for public app"
  },
  "servers": [
    {
      "url": "https://localhost:8443/ords/bsb_dev/bsb-v1/"
    }
  ],
  "paths": {
    "/chat/": {
      "put": {
        "description": "Create or update a record on bsb-v1",
        "responses": {
          "201": {
            "description": "The successfully created record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "chat": {
                      "$ref": "#/components/schemas/RESULTSET"
                    }
                  }
                }
              }
            }
          },
          "200": {
            "description": "The successfully updated record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "chat": {
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
            "name": "id",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "message",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "status",
            "in": "header",
            "schema": {
              "type": "string"
            }
          }
        ]
      }
    },
    "/chats/{id}": {
      "get": {
        "description": "Retrieve a record from bsb-v1",
        "responses": {
          "200": {
            "description": "The queried record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "chat": {
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
            "name": "id",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string",
              "pattern": "^[^/]+$"
            },
            "description": "implicit"
          }
        ]
      }
    },
    "/deal/": {
      "put": {
        "description": "Create or update a record on bsb-v1",
        "responses": {
          "201": {
            "description": "The successfully created record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "deals": {
                      "$ref": "#/components/schemas/RESULTSET"
                    }
                  }
                }
              }
            }
          },
          "200": {
            "description": "The successfully updated record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "deals": {
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
            "name": "code",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "fullname",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "status",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "tag",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "title",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w10",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w11",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w12",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w13",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w14",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w15",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w16",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w17",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w18",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w19",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w1",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w20",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w21",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w22",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w23",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w24",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w25",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w2",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w3",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w4",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w5",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w6",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w7",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w8",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "w9",
            "in": "header",
            "schema": {
              "type": "string"
            }
          }
        ]
      }
    },
    "/deals/": {
      "get": {
        "description": "Retrieve a record from bsb-v1",
        "responses": {
          "200": {
            "description": "The queried record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "deals": {
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
              "type": "integer"
            }
          },
          {
            "name": "offset",
            "in": "header",
            "schema": {
              "type": "integer"
            }
          },
          {
            "name": "tag",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "title",
            "in": "header",
            "schema": {
              "type": "string"
            }
          }
        ]
      }
    },
    "/join/": {
      "post": {
        "description": "Create a new record on bsb-v1",
        "responses": {
          "201": {
            "description": "The successfully created record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "play": {
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
            "name": "gamecode",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "username",
            "in": "header",
            "schema": {
              "type": "string"
            }
          }
        ]
      }
    },
    "/mark/": {
      "put": {
        "description": "Create or update a record on bsb-v1",
        "responses": {
          "201": {
            "description": "The successfully created record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "play": {
                      "$ref": "#/components/schemas/RESULTSET"
                    }
                  }
                }
              }
            }
          },
          "200": {
            "description": "The successfully updated record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "play": {
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
            "name": "id",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m10",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m11",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m12",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m13",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m14",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m15",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m16",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m17",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m18",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m19",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m1",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m20",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m21",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m22",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m23",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m24",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m25",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m2",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m3",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m4",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m5",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m6",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m7",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m8",
            "in": "header",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "m9",
            "in": "header",
            "schema": {
              "type": "string"
            }
          }
        ]
      }
    },
    "/play/{id}": {
      "get": {
        "description": "Retrieve a record from bsb-v1",
        "responses": {
          "200": {
            "description": "The queried record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "play": {
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
            "name": "id",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string",
              "pattern": "^[^/]+$"
            },
            "description": "implicit"
          }
        ]
      }
    },
    "/tags/": {
      "get": {
        "description": "Retrieve a record from bsb-v1",
        "responses": {
          "200": {
            "description": "The queried record.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "tags": {
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

| Route Path             | Route Meta                                                                                                                                 |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| /bullshit-bingo        | `{"title": "Bullshit Bingo", "description": "Join the Bullshit Bingo game", "color": "#E1BEE7", "icon": "$mdiBullhorn", "role": "public"}` |
| /bullshit-bingo/player | `{  "title": "Player",   "role": "public"}`                                                                                                |
| /bullshit-bingo/dealer | `{  "title": "Dealer",   "role": "restricted"}`                                                                                            |

## Integrations

None
