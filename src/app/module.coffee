# angular.module 'jtg.conf', []

angular.module 'jtg', [
  # 'jtg.conf'

  'events'
  'socket.io'

  'rest'
  'rest.auth'

  'jtg.minimap'

  'facebook'
  'github'
  'promise'
  'concurrency'
  'toast'
  'feeds'

  'popdown'

  'angularMoment'
  'filters'
  'directives'
]

.config (toastProvider) ->
  toastProvider.config.autoExpose = true

.run (socket) ->
  socket.on 'connect', ->
    socket.emit 'init', 'client'
