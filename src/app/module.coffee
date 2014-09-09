angular.module 'jtg', [
  'events'
  'socket.io'

  'rest'
  'rest.auth'

  'jtg.minimap'

  # 'ui.map'
  # 'google.maps'
  # 'google'
  'facebook'
  'github'
  'promise'
  'concurrency'
  'toast'
  'log'
  'feeds'

  'popdown'

  'angularMoment'
  'filters'
  'directives'
]

.config (toastProvider) ->
  toastProvider.config.autoExpose = true

.config (facebookProvider) ->
  facebookProvider.config.appId = 299095383509760

.config (githubProvider) ->
  githubProvider.config.clientId = '96acc831e0388a4b4afc'

.config (socketProvider) ->
  # socketProvider.config.host = 'http://jessethegame.net:5000'
  socketProvider.config.host = 'http://localhost:8080'
  socketProvider.config.host = 'http://jessethemacbook.local:8080'

.config (feedsProvider) ->
  # feedsProvider.config.host = 'http://jessethegame.net:5000'
  feedsProvider.config.host = 'http://jessethemacbook.local:8080'

.run (socket) ->
  socket.on 'connect', ->
    socket.emit 'init', 'client'

  socket.on 'location', (x) ->
    console.log "LOC", x

  socket.on 'broadcast', (x) ->
    console.log "BC", x

  socket.on 'ack', ->
    console.log "ACK"

.run (toast, session, $timeout) ->
  session.emitter.on 'connect', (user) ->
    toast.create "Welcome #{user.name}!"

  session.emitter.on 'disconnect', (user) ->
    toast.create "Bye #{user.name}!"


.service 'jtg', (Api) ->
  # new Api 'jtg', 'http://api.jessethegame.net'
  new Api 'jtg', 'http://localhost:3000'
  new Api 'jtg', 'http://jessethemacbook.local:3000'

.factory 'Reward', (jtg) ->
  jtg.model 'rewards'
