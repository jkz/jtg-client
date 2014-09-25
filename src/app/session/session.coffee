angular.module 'jtg.session', [
  'jtg.api'

  'concurrency'
  'promise'
  'events'
  'socket.io'
]

# Holds the login information and emits events on changes
.service 'session', (auth, reject, lock, User, EventEmitter) ->
  session =
    emitter: new EventEmitter

    # The logged in user.
    # `if session.user` is the idomatic way of checking for login
    # Please do not set or remove it manually, but use (dis)connect.
    user: null

    identify: lock "Identifying", ({provider, new_user, new_account}={}) ->
      User
        .me()
        .then session.set
        .then (user) ->
          session.emitter.emit 'new_user', user if new_user
          session.emitter.emit 'new_account', user.accounts?[provider] if new_account


    set: (user) ->
      console.log {user}
      session.user = user
      session.user.current = true
      session.emitter.emit 'connect', user
      user

    clear: ->
      if session.user
        session.emitter.emit 'disconnect', session.user
        session.user.current = false
      session.user = null

    connect: auth.connect
    disconnect: auth.disconnect

  auth.emitter.on 'connect', session.identify
  auth.emitter.on 'misconnect', session.clear
  auth.emitter.on 'disconnect', session.clear

  session

.run ($rootScope, session, jtg) ->
  $rootScope.session = session

  # This used to be called here, but moved it to the top level so
  # so everything is loaded before the connect event fires.
  #session.identify() if jtg.auth.token.key

.controller 'SessionCtrl', ($scope, Account) ->
  $scope.Account = Account
  $scope.providers = Account.providers
