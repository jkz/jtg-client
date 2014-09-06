angular.module('socket.io', [])

.service 'io', ($rootScope) ->
  connect: (host) ->

    socket = io.connect host

    disconnect: ->
      socket.disconnect()

    socket: socket

    on: (eventName, callback) ->
      socket.on eventName, listener = (args...) ->
        console.log '-->', eventName, callback
        $rootScope.$apply ->
          callback.apply socket, args
      ->
        socket.removeListener eventName, listener
    emit: (eventName, data, callback) ->
      console.log '<<-', eventName, data, callback
      socket.emit eventName, data, (args...) ->
        $rootScope.$apply ->
          callback.apply socket, args
    send: (eventName, data, callback) ->
      console.log '<--', eventName, data, callback
      socket.send eventName, data, (args...) ->
        $rootScope.$apply ->
          callback.apply socket, args

.provider 'socket', ->
  @config =
    host: null

  @.$get = (io) =>
    io.connect @config.host

  @