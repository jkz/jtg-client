angular.module 'jtg'

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
.run ($rootScope, session) ->
  $rootScope.session = session
