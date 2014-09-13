angular.module 'jtg'

.provider 'jtg', ->
  @config =
    host: null

  @$get = (Api) =>
    new Api 'jtg', @config.host

  this

.run (Auth, omniauth) ->
  Auth::authenticate = omniauth.authenticate

