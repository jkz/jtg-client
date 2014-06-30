angular.module 'jtg'

# Holds the login information and emits events on changes
.service 'session', (emitter, auth) ->
  session =
    # The logged in user.
    # `if session.user` is the idomatic way of checking for login
    user: null

    connect: ->
      auth
        .connect()
        .then (user) ->
          session.user = user

    disconnect: ->
      auth
        .disconnect()
        .then ->
          session.user = null

# Expose the session to the DOM
.run ($rootScope, session) ->
  $rootScope.session = session
