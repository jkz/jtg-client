angular.module 'jtg'

# TODO

.service 'session', (emitter) ->
  session =
    user: null
    # token: null

    connect: (user) ->
      session.user = user
      emitter.emit 'session.connect'

    disconnect: ->
      emitter.emit 'session.disconnect'
      session.user = null
      # session.token = null


.service 'auth', (jtg, session) ->
  auth =
    connect: (provider, creds) ->
      request.post '/session',
        data: {provider, creds}
      .then ({token}) ->
        $cookies.token = jtg.token = token

    disconnect: ->
      events.emit 'session.disconnect'
      delete $cookies.token
      session.user = null

    identify: (token) ->
      jtg.token = token
      jtg.get '/me'
      .then ({user}) ->
        session.connect user
      .fail ->
        delete jtg.token
        delete $cookies.token

.run ($rootScope, $cookies, auth) ->
  $rootScope.session = auth

  auth.identify $cookies.token if $cookies.token

.controller 'SessionCtrl', ($scope, session) ->
  $scope.session = session
