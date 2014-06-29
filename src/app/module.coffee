angular.module 'jtg', [
  'ngCookies'

  'emitter'
  'socket.io'
  'rest'
  'google.maps'
  'facebook'
  'promise'
  'concurrency'
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

.service 'request', ($http) ->
  request = (method, url, options={}) ->
    options.method ?= 'GET'
    options.url ?= url

    $http options
    .then (response) ->
      response.data

  request.get  = (url, options) -> request 'GET', url, options
  request.post = (url, options) -> request 'POST', url, options
  request.del  = (url, options) -> request 'DELETE', url, options
  request.put  = (url, options) -> request 'PUT', url, options

  request


.service 'jtgOld', ($http, session, request) ->
  jtg =
    request: (method, url, options) ->
      options.query ?= {}
      options.query.token ?= session.token if session.token
      request method, url, options

    get:  (url, options) -> jtg.request 'GET', url, options
    post: (url, options) -> jtg.request 'POST', url, options
    del:  (url, options) -> jtg.request 'DELETE', url, options
    put:  (url, options) -> jtg.request 'PUT', url, options

.service 'jtg', (Api) ->
  # new Api '/api/v1'
  jtg = new Api 'http://localhost:3000'

.factory 'Reward', (jtg) ->
  jtg.model 'rewards'
