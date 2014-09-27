angular.module 'rest.auth', [
  'rest.api'
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
    constructor: (@api, @storageKey) ->
      @storageKey ?= "#{@api.name}.token"

      # Initialise the token from storage on load
      @set(@get())

    header: =>
      "Bearer #{@key}"

    get: =>
      @key ? localStorageService.get @storageKey

    set: (key) =>
      console.log "Token.set", {key}
      return @clear() unless key
      @key = key
      @api.headers['Authorization'] = @header()
      localStorageService.set @storageKey, key
      return

    clear: =>
      delete @key
      delete @api.headers['Authorization']
      localStorageService.remove @storageKey
      return


# Manages authentication and authorization via a token.
# The token is retrieved with the `authenticate` method.
# The token is then attached to the cookies and the api.
# The api sends the token with every request
.service 'Auth', (EventEmitter, $q) ->
  class Auth
    constructor: (@token) ->
      @emitter = new EventEmitter

    # Override this with your favourite auth method
    # It should return an object with a `token` property.
    # The entire object is emitted in a `connect` event.
    # Any rejected reason is emitted in a `misconnect` event.
    authenticate: (args...) ->
      $q.reject "No authenticate method defined"

    identify: ->
      $q.reject "No identify method defined"

    init: =>
      @identify() if @token.key

    # ### Connection
    connect: (args...) =>
      console.log "Auth.connect", {args}
      @authenticate args...
        .then (data) =>
          console.log '@authenticate.then', {data}
          @token.set data.token
          @emitter.emit 'connect', data
        .catch (reason) =>
          @token.clear()
          @emitter.emit 'misconnect', reason
        .finally()

    disconnect: =>
      $q.when()
        .then @token.clear
        .then (data) =>
          @emitter.emit 'disconnect', data

# TODO allow autoauth disable
.run (rest, Token, Auth, $rootScope) ->
  rest.emitter.on 'Api:new', (api) ->
    api.auth = new Auth new Token api
    $rootScope.$apply()


