angular.module('socket.io', [])

.service 'io', ($rootScope) ->
  wrap = (socket) ->
    on: (event, callback) ->
      socket.on event, listener = (args...) ->
        $rootScope.$apply ->
          callback.apply socket, args
      ->
        socket.removeListener event, listener

    emit: (event, data, callback) ->
      socket.emit event, data, (args...) ->
        $rootScope.$apply ->
          callback.apply socket, args

  service = (host) ->
    socket = io.connect host
    wrapped = wrap(socket)
    wrapped.socket = socket
    wrapped.disconnect = ->
      socket.disconnect()
    # Yeyeye, these are the exact same
    wrapped.in = (room) ->
      wrap(socket.in(room))
    wrapped.to = (room) ->
      wrap(socket.to(room))
    wrapped
  service.connect = service

.provider 'socket', ->
  @config =
    host: null

  @$get = (io) =>
    io.connect @config.host

  this