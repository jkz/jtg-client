angular.module 'jtg'

# Holds the login information and emits events on changes
.service 'session', (jtg, reject, lock, User, EventEmitter) ->
  session =
    emitter: new EventEmitter

    # The logged in user.
    # `if session.user` is the idomatic way of checking for login
    # Please do not set or remove it manually, but use (dis)connect.
    user: null

    connect: (provider, creds) ->
      # reject "Already connected" if session.user
      jtg.auth.connect provider, creds

    disconnect: ->
      # reject "Already disconnect" unless session.user
      jtg.auth.disconnect()

    identify: lock "Identifying", ->
      User
        .show 'me'
        .then session.set

    set: (user) ->
      session.user = user
      session.user.current = true
      session.emitter.emit 'connect', user
      user

    clear: ->
      session.emitter.emit 'disconnect', session.user
      session.user.current = false
      session.user = null

  jtg.auth.emitter.on 'connect', session.identify
  jtg.auth.emitter.on 'disconnect', session.clear

  session

.run ($rootScope, session, jtg, socket) ->
  $rootScope.session = session

  session.identify() if jtg.auth.token.key

.run (socket, jtg) ->
  jtg.auth.emitter.on 'connect', (user) ->
    socket.emit 'auth', token: jtg.auth.token.key
  socket.emit 'auth', token: jtg.auth.token.key if jtg.auth.token.key

.controller 'SessionCtrl', ($scope, Account) ->
  $scope.Account = Account
  $scope.providers = Account.providers
