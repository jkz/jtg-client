# TODO decouple this from jtg and make it rest.auth
angular.module 'jtg'

# TODO WORK ON THIS
# add .set, .clear
.service 'Token', (jtg, User) ->
  Token =
    fetch: (data) ->
      jtg
        .post '/tokens', data
        .error token.clear
        .then (data) ->
          Token.set data.token
          data

    set: (token) ->
      $cookies.token = jtg.token = token

    clear: ->
      delete jtg.token
      delete $cookies.token

    identify: ->
      User.show 'me'


# Manages authentication and authorization via a token.
# The token is retrieved by connecting with a provider and credentials.
# The token is then attached to the cookies and the api.
# The api sends the token with every request
.service 'auth', (promise, lock, Token, User, EventEmitter) ->
  auth =
    emitter: new EventEmitter

    # ### Connection
    # TODO pass Provider ({name, slug}) in stead of slug?
    connect: lock "Connecting", (provider, creds) ->
      return promise.reject "No provider specified" unless provider

      Token
        .fetch {provider, creds}
        .then ({new_user, new_account}) ->

          Token
            .identify()
            .then (user) ->
              account = user.accounts[provider]

              auth.emitter.emit 'connect', {user, account}
              auth.emitter.emit 'new_user', user if new_user
              auth.emitter.emit 'new_account', account if new_account

    disconnect: lock "Disconnecting", ->
      Token.clear()
      promise.resolve()

# Identify a cookie if it's present
.run ($cookies, Token) ->
  Token.set $cookies.token if $cookies.token
