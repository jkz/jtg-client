angular.module 'rest.auth', [
  'rest'
  'ngCookies'
  'concurrency'
  'events'
]

# Manages the access token for an api
.factory 'Token', ($cookies) ->
  class Token
    constructor: (@api, @endpoint) ->
      @endpoint ?= '/tokens'
      @cookey = "#{@api.name}.token"

      @set $cookies[@cookey] if $cookies[@cookey]

    fetch: (data) ->
      @api
        .post @endpoint, data
        .catch @clear
        .then (data) =>
          @set data.token.key
          data

    set: (token) =>
      console.log "Token.set", {token}
      @key = $cookies[@cookey] = @api.headers['Authorization'] = token

    clear: =>
      delete @key
      delete @api.headers['Authorization']
      delete $cookies[@cookey]


# Manages authentication and authorization via a token.
# The token is retrieved by connecting with a provider and credentials.
# The token is then attached to the cookies and the api.
# The api sends the token with every request
.service 'Auth', (lock, resolve, EventEmitter) ->
  class Auth
    constructor: (@token) ->
      @emitter = new EventEmitter
      console.log "AUTH", this

    # ### Connection
    connect: lock "Connecting", (creds) ->
      console.log "CONNECT", this
      @token
        .fetch creds
        .then (data) =>
          @emitter.emit 'connect', data

    disconnect: lock "Disconnecting", ->
      @token.clear()
      @emitter.emit 'disconnect'
      resolve()

# TODO allow autoauth disable
.run (rest, Token, Auth, $rootScope) ->
  rest.emitter.on 'Api:new', (api) ->
    api.auth = new Auth new Token api
    $rootScope.$apply()
    console.log "NEW API AUTH", {api}
