angular.module 'jtg.api', [
  'rest.api'
  'rest.auth'
  'rest.socket'
  'omniauth'
]

.provider 'jtg', ->
  @config =
    host: null

  @$get = (Api) =>
    new Api 'jtg', @config.host

  this

.factory 'auth', (jtg) ->
  jtg.auth

.run (Auth, omniauth, jtg, session, User) ->
  Auth::authenticate = (args...) ->
    omniauth
      .authenticate(args...)
      .then ({token}) ->
        console.log {token}
        # Account auth token
        headers = 'Authorization': "Bearer #{token}"

        # Get user token
        jtg.http('get', '/tokens/user', null, {headers}).error (data, status) ->
          console.log {status}

          # Uh oh, no user for account
          throw status unless status == 409

          console.log "Creating user"

          # Create user for account
          jtg.http('post', '/users', null, {headers}).then ->
            console.log "success"

            # Yay, now try to get the user token again
            jtg.http('get', '/tokens/user', null, {headers})

      .then ({data}) ->
        console.log "END OF CHAIN"
        console.log {data}
        data
      .catch (err) ->
        console.log {err}
  Auth::identify = session.identify
