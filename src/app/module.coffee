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
  'jtg.session'

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

.service 'jesse', (hub) ->
  hub.hosts.for('jessethegame')
