angular.module 'jtg'

.service 'geolocation', ->
  navigator.geolocation

.service 'locationFeed', (socket, geolocation, $interval) ->
  stopper = null

  feed =
    coords: undefined
    running: false

    broadcast: (coords) ->
      socket.emit 'location', coords ? feed.coords

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

.run ($rootScope, locationFeed) ->
  $rootScope.locationFeed = locationFeed
