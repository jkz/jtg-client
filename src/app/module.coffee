# angular.module 'jtg.conf', []

angular.module 'jtg', [
  # 'jtg.conf'

  'events'
  'socket.io'

  'rest.api'
  'rest.auth'

  'jtg.minimap'

  'promise'
  'concurrency'
  'toast'
  'feeds'

  'omniauth'

  'angularMoment'
  'filters'
  'directives'
]

.config (toastProvider) ->
  toastProvider.config.autoExpose = true

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

