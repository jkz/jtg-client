angular.module 'jtg.minimap'

.service 'geolocation', ->
  navigator.geolocation

.service 'locationFeed', (io, socket, geolocation, $interval) ->
  stopper = null

  feed =
    coords: undefined
    running: false
    # TODO add namespace support to socket service
    socket: io.connect('http://localhost:8080/location')
    socket: io.connect('http://jessethemacbook.local:8080/location')

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

.controller 'MinimapCtrl', ($scope, locationFeed) ->
  $scope.feed = locationFeed

  $scope.markers = {}
  $scope.markerOptions = {}

  $scope.map =
    zoom: 15
    center:
      latitude: 45
      longitude: -73

  $scope.rerenderMarkers = ->
    for marker in $scope.markerControl.getGMarkers()
      marker.setPosition marker.position

  createIcon = (url) ->
    url: url
    scaledSize: new google.maps.Size 32, 32

  createMarker = ({name, image}) ->
    idKey: name
    icon: createIcon image

  locationFeed.socket.on 'location', ({coords, user}) ->
    marker = $scope.markers[user.name] ?= createMarker user
    marker.coords = coords
    marker.label = user.name
    $scope.map.center = coords

.run ($rootScope, locationFeed) ->
  $rootScope.locationFeed = locationFeed
