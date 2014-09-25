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
        jtg.post '/users', {token}
      .then ({data}) ->
        data
  Auth::identify = session.identify
