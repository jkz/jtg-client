angular.module('socket.io', [])

.service 'io', ($rootScope) ->
  connect: (host) ->

    socket = io.connect host

    disconnect: ->
      socket.disconnect()

    socket:
      disconnect: ->
        socket.socket.disconnect()

    on: (eventName, callback) ->
      socket.on eventName, ->
        args = arguments
        console.log '-->', eventName, callback
        $rootScope.$apply ->
          callback.apply socket, args
    emit: (eventName, data, callback) ->
      console.log '<<-', eventName, data, callback
      socket.emit eventName, data, ->
        args = arguments
        $rootScope.$apply ->
          callback.apply socket, args
    send: (eventName, data, callback) ->
      console.log '<--', eventName, data, callback
      socket.send eventName, data, ->
        args = arguments
        $rootScope.$apply ->
          callback.apply socket, args

.provider 'socket', ->
  @config =
    host: null

  @.$get = (io) =>
    io.connect @config.host

  @