angular.module 'jtg'

# Manages authentication and authorization via a token.
# The token is retrieved by connecting with a provider and credentials.
# The token is then attached to the cookies and the api.
# The api sends the token with every request
.service 'auth', (jtg, reject, User, emitter, $cookies, lock) ->
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

      jtg
        .post '/tokens', data: {provider, creds}
        .then ({token, new_user, new_account}) ->

          auth
            .identify token
            .then (user) ->
              account = user.accounts[provider]

              emitter.emit 'auth.identify', {user, account}
              emitter.emit 'auth.new_user', user if new_user
              emitter.emit 'auth.new_account', account if new_account

    disconnect: ->
      auth.clear()

    # ### Identity
    identify: lock "Busy identifying", (token) ->
      return reject "No token specified" unless token

      auth.set token

      User
        .show 'me'
        .catch auth.clear

# Identify a cookie if it's present
.run ($cookies, auth) ->
  auth.identify $cookies.token if $cookies.token
