angular.module 'rest.auth', [
  'rest'
  'concurrency'
  'events'
  'LocalStorageModule'
]

# Manages the access token for an api
# TODO
# - emit Token:new event (and use that to do initial auth)
# - Maybe specify a method that is called on every api request
.service 'Token', (localStorageService) ->
  class Token
    constructor: (@api, @endpoint) ->
      @endpoint ?= '/tokens'
      @storageKey = "#{@api.name}.token"

      @set key if key = localStorageService.get @storageKey

    fetch: (data) =>
      @api
        .post @endpoint, data
        .catch @clear
        .then ({token}) =>
          @set token.key
          token

    set: (key) =>
      @key = @api.headers['Authorization'] = key
      localStorageService.set @storageKey, key

    clear: =>
      delete @key
      delete @api.headers['Authorization']
      localStorageService.remove @storageKey


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
