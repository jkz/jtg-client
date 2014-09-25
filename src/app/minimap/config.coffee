angular.module 'jtg.minimap'

.provider 'minimap', ->
  @config =
    host: null
    namespace: '/locations'
    interval: 3000

  @$get = (Minimap, jtg) =>
    minimap = new Minimap @config

    minimap.login = ->
      {key} = jtg.auth.token
      minimap.socket.emit 'login', key if key?

    minimap.logout = ->
      minimap.socket.emit 'logout'

    minimap

  this

.run ($rootScope, minimap, session) ->
  $rootScope.minimap = minimap

  session.emitter.on 'connect', minimap.login
  session.emitter.on 'disconnect', minimap.logout
  minimap.socket.on 'connect', minimap.login