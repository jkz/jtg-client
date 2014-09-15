angular.module 'jtg.conf', [
  'jtg.hub'
  'jtg.api'
  'jtg.minimap'

  'socket.io'
  'omniauth'
  'feeds'
  'toast'
]

angular.module 'jtg', [
  'jtg.api'
  'jtg.hub'
  'jtg.conf'

  'events'
  'socket.io'

  'jtg.minimap'

  'ui.router'

  'promise'
  'concurrency'
  'toast'
  'feeds'

  'angularMoment'
  'filters'
  'directives'
]

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

.service 'jesse', (hub) ->
  hub.hosts.for('jessethegame')
