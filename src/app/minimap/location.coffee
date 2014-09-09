angular.module 'jtg'

.service 'geolocation', ->
  navigator.geolocation

.service 'locationFeed', (io, socket, geolocation, $interval) ->
  stopper = null

  feed =
    coords: undefined
    running: false
    # TODO add namespace support to socket service
    socket: io.connect('http://localhost:8080/location')

    broadcast: (coords) ->
      console.log {coords}
      feed.socket.emit('location', coords ? feed.coords)

    locate: ->
      geolocation.getCurrentPosition ({coords}) ->
        feed.coords = coords
        feed.broadcast coords
    start: ->
      stopper ?= $interval feed.locate, 3000
      feed.running = true
    stop: ->
      feed.running = false
      stopper?()
      stopper = null

.controller 'LocationCtrl', ($scope, locationFeed) ->
  $scope.feed = locationFeed

  $scope.locations = {}

  locationFeed.socket.on 'location', ({coords, user}) ->
    $scope.locations[user.name] = {coords, user}

.run ($rootScope, locationFeed) ->
  $rootScope.locationFeed = locationFeed
