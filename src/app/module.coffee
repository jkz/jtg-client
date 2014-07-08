angular.module 'jtg', [
  'ngCookies'

  'events'
  'socket.io'

  'rest'
  'rest.auth'

  'google.maps'
  'facebook'
  'promise'
  'concurrency'
  'toast'
  'log'

  'popdown'
]

.config (toastProvider) ->
  toastProvider.config.autoExpose = true

.config (facebookProvider) ->
  facebookProvider.config.appId = 299095383509760

.config (socketProvider) ->
  socketProvider.config.host = 'http://jessethegame.net:5000'

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
  new Api 'jtg', 'http://api.jessethegame.net'

.factory 'Reward', (jtg) ->
  jtg.model 'rewards'
