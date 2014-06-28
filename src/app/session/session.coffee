angular.module 'jtg'

# ## Session
# ---
# Holds the login information and emits events on changes
.service 'session', (emitter) ->
  session =
    # The logged in user.
    # `if session.user` is the idomatic way of checking for login
    user: null

    # `session.connect` event, add the user to the session
    connect: (user) ->
      session.user = user
      emitter.emit 'session.connect', user

    # `session.disconnect` event, remove the user from the session
    disconnect: ->
      emitter.emit 'session.disconnect', user
      session.user = null

# Expose the session to the DOM
.run ($rootScope) ->
  $rootScope.session = session

# ## Auth
# ---
# Manages authentication and authorization via a token.
# The token is retrieved by connecting with a provider and credentials.
# The token is then attached to the cookies and the api.
# The api sends the token with every request
.service 'auth', (jtg, session, reject, User, emitter, $cookies, lock) ->

  auth =
    set: (token) ->
      $cookies.token = jtg.token = token

    clear: ->
      delete jtg.token
      delete $cookies.token

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
      tokens.clear()
      session.disconnect()

    identify: lock "Busy identifying", (token) ->
      return reject "Already connected" if session.user
      return reject "No token specified" if token

      auth.set token

      User
        .show 'me'
        .then (user) -> session.connect user
        .catch -> auth.clear()

.run ($rootScope, $cookies, auth) ->
  auth.identify $cookies.token if $cookies.token

.controller 'SessionCtrl', ($scope, session, auth) ->
  $scope.auth = auth
