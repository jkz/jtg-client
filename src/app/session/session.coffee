angular.module 'jtg'

.factory 'DummyUser', (User) ->
  new User
    accounts:
      facebook:
        provider: 'facebook'
        id: 1412910151
        name: 'Jesse Kwabena Osei Zwaan'
      dummy:
        provider: 'dummy'
        name: 'Jesse the Game'

# Holds the login information and emits events on changes
.service 'session', (jtg, reject, lock, User) ->
  session =
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

    set: (user) -> session.user = user
    clear: -> session.user = null

  jtg.auth.emitter.on 'connect', session.identify
  jtg.auth.emitter.on 'disconnect', session.clear

  session

.run ($rootScope, session, jtg) ->
  $rootScope.session = session

  session.identify() if jtg.auth.token.key


.controller 'SessionCtrl', ($scope, Account) ->
  $scope.Account = Account
  $scope.providers = Account.providers
