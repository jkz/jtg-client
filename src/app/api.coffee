angular.module 'jtg.api', [
  'rest.api'
  'rest.auth'
  'omniauth'
]

.provider 'jtg', ->
  @config =
    host: null

  @$get = (Api) =>
    new Api 'jtg', @config.host

  this

.run (Auth, omniauth) ->
  Auth::authenticate = omniauth.authenticate

