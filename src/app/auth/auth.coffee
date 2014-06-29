angular.module 'jtg'

# Manages authentication and authorization via a token.
# The token is retrieved by connecting with a provider and credentials.
# The token is then attached to the cookies and the api.
# The api sends the token with every request
.service 'auth', (jtg, session, reject, User, emitter, $cookies, lock) ->

  auth =
    # ### Token
    set: (token) ->
      $cookies.token = jtg.token = token

    clear: ->
      delete jtg.token
      delete $cookies.token

    # ### Connection
    # TODO pass Provider ({name, slug}) in stead of slug?
    connect: lock "Busy connecting", (provider, creds) ->
      return reject "#{provider} already connected" if session.user?.accounts[provider]

      jtg
        .post '/tokens', data: {provider, creds}
        .then ({token, new_user, new_account}) ->

          auth
            .identify token
            .then ->
              emitter.emit 'auth.identify', user: session.user, account: user.accounts[provider]
              emitter.emit 'auth.new_user', session.user if new_user
              emitter.emit 'auth.new_account', session.user.accounts[provider] if new_account

    disconnect: ->
      auth.clear()
      session.disconnect()

    # ### Identity
    identify: lock "Busy identifying", (token) ->
      return reject "Already connected" if session.user
      return reject "No token specified" if token

      auth.set token

      User
        .show 'me'
        .then session.connect
        .catch auth.clear

# Identify a cookie if it's present
.run ($rootScope, $cookies, auth) ->
  auth.identify $cookies.token if $cookies.token

  $rootScope.auth = auth
