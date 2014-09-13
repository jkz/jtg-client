angular.module 'jtg'

# Holds the login information and emits events on changes
.service 'session', (jtg, reject, lock, User, EventEmitter, omniauth) ->
  session =
    emitter: new EventEmitter

    # The logged in user.
    # `if session.user` is the idomatic way of checking for login
    # Please do not set or remove it manually, but use (dis)connect.
    user: null

    identify: lock "Identifying", ({provider, new_user, new_account}={}) ->
      User
        .show 'me'
        .then session.set
        .then (user) ->
          session.emitter.emit 'new_user', user if new_user
          session.emitter.emit 'new_account', user.accounts?[provider] if new_account


    set: (user) ->
      session.user = user
      session.user.current = true
      session.emitter.emit 'connect', user
      user

    clear: ->
      if session.user
        session.emitter.emit 'disconnect', session.user
        session.user.current = false
      session.user = null

    connect: jtg.auth.connect
    disconnect: jtg.auth.disconnect

  jtg.auth.emitter.on 'connect', session.identify
  jtg.auth.emitter.on 'misconnect', session.clear
  jtg.auth.emitter.on 'disconnect', session.clear

  session

.run ($rootScope, session, jtg, socket) ->
  $rootScope.session = session

  session.identify() if jtg.auth.token.key

.run (socket, jtg) ->
  jtg.auth.emitter.on 'connect', ({user}) ->
    socket.emit 'auth', token: jtg.auth.token.key
  socket.emit 'auth', token: jtg.auth.token.key if jtg.auth.token.key

.controller 'SessionCtrl', ($scope, Account) ->
  $scope.Account = Account
  $scope.providers = Account.providers
