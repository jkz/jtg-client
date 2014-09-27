angular.module 'jtg'

.run (Account, Provider) ->
  Account.providers.push [
    Provider.create 'Facebook'
    Provider.create 'Github'
    Provider.create 'Soundcloud'
    Provider.create 'Twitter'
  ]...

.run (socket) ->
  socket.on 'connect', ->
    socket.emit 'init', 'client'

.run ($rootScope, session, $state) ->
  $rootScope.session = session

  # This is called here to ensure all parts of the app
  # that depend on the event have been loaded
  session.init()

  $rootScope.$on '$stateChangeStart', (event, toState, toStateParams) ->
    if toState.requireAuth and not session.user
      event.preventDefault()
      $rootScope.toState = toState
      $rootScope.toStateParams = toStateParams
      $state.go 'home'

  $rootScope.$watch 'session.user', (user) ->
    if user
      if $rootScope.toState
        $state.go $rootScope.toState, $rootScope.toStateParams
    else
      if $state.current.requireAuth
        $state.go 'home'
