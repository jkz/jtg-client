angular.module 'rest.auth', [
  'rest'
  'ngCookies'
  'concurrency'
  'events'
]

# Manages the access token for an api
.factory 'Token', ($cookieStore) ->
  class Token
    constructor: (@api, @endpoint) ->
      @endpoint ?= '/tokens'
      @cookey = "#{@api.name}.token"

      cookie = $cookieStore.get @cookey
      @set cookie if cookie
      # @set $cookies[@cookey] if $cookies[@cookey]

    fetch: (data) =>
      @api
        .post @endpoint, data
        .catch @clear
        .then ({token}) =>
          @set token.key
          token

    set: (key) =>
      # $cookies[@cookey] = @key = @api.headers['Authorization'] = key
      @key = @api.headers['Authorization'] = key
      $cookieStore.put @cookey, key

    clear: =>
      console.log "Token.clear", this

      delete @key
      delete @api.headers['Authorization']
      # delete $cookies[@cookey]
      $cookieStore.remove @cookey


# Manages authentication and authorization via a token.
# The token is retrieved by connecting with a provider and credentials.
# The token is then attached to the cookies and the api.
# The api sends the token with every request
.service 'Auth', (lock, resolve, EventEmitter) ->
  class Auth
    constructor: (@token) ->
      @emitter = new EventEmitter

    # ### Connection
    connect: lock "Connecting", (creds) ->
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
