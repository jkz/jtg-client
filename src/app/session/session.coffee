angular.module 'jtg'

# Holds the login information and emits events on changes
.service 'session', (emitter, auth, reject) ->
  session =
    # The logged in user.
    # `if session.user` is the idomatic way of checking for login
    # Please do not set or remove it manually, but use (dis)connect.
    user: null

    connect: ->
      reject "Already connected" if session.user

      auth
        .connect()
        .then (user) ->
          session.user = user

    disconnect: ->
      reject "Already disconnect" unless session.user

      auth
        .disconnect()
        .then ->
          session.user = null

# Expose the session to the DOM
.run ($rootScope, session) ->
  $rootScope.session = session
