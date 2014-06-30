angular.module 'jtg', [
  'ngCookies'

  'events'
  'socket.io'
  'rest'
  'google.maps'
  'facebook'
  'promise'
  'concurrency'
  'toast'
  'log'
]

.config (facebookProvider) ->
  facebookProvider.config.appId = 299095383509760

.config (socketProvider) ->
  socketProvider.config.host = 'https://hub-jessethegame.herokuapp.com:443'
  socketProvider.config.host = 'http://pewpew.nl:5000'
  socketProvider.config.host = 'http://localhost:8080'

.run (socket) ->
  socket.on 'connect', ->
    socket.emit 'init', 'client'

  socket.on 'location', (x) ->
    console.log "LOC", x

  socket.on 'broadcast', (x) ->
    console.log "BC", x

  socket.on 'ack', ->
    console.log "ACK"

.service 'jtg', (Api) ->
  # new Api '/api/v1'
  jtg = new Api 'jtg', 'http://localhost:3000'

.factory 'Reward', (jtg) ->
  jtg.model 'rewards'
