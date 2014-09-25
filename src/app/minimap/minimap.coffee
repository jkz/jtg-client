angular.module 'jtg.minimap'

.service 'navigator', ($rootScope) ->
  throw "Geolocation not supported" unless navigator?.geolocation?

  geolocation:
    getCurrentPosition: (callback) ->
      navigator.geolocation.getCurrentPosition (args...) ->
        $rootScope.$apply ->
          callback args...

.service 'Minimap', (io, navigator, EventEmitter, $http, $interval) ->
  class Minimap extends EventEmitter
    constructor: ({@host, @namespace, @interval}) ->
      super

      @stopper = null
      @coords = {}

      @zoom = 15
      @center =
        latitude: 0
        longitude: 0

      @locations = {}

      @running = no

      @socket = io.connect("#{@host}#{@namespace}")

      @socket.on 'location:set', (location) =>
        @emit 'location:set', location

      @socket.on 'location:del', (location) =>
        @emit 'location:del', location

    broadcast: ({coords}={}) =>
      @coords = coords if coords?
      console.log "broadcast", {coords}
      @socket.emit('location', @coords)

    locate: =>
      navigator.geolocation.getCurrentPosition @broadcast

    start: =>
      @stopper ?= $interval @locate, 3000
      @running = yes

    stop: =>
      @running = no
      @stopper?()
      @stopper = null

    getLocations: =>
      $http
        .get "#{@host}#{@namespace}"
        .then (locations) =>
          console.log {locations}
          for id, location in @locations
            if locations[id]
              @emit 'locations.set', locations[id]
            else
              @emit 'locations.del', location

    setCenter: ({coords}={}) =>
      {longitude, latitude} = coords
      @center = {longitude, latitude}



.directive 'minimap', (navigator, $timeout) ->
  restrict: 'E'
  templateUrl: 'app/minimap/minimap.html'
  scope:
    map: '='
  controller: ($scope) ->
    $scope.updateHostVisible = (map, args...) ->
      console.log 'updateHostVisible'
      console.log {map, args}
      bounds = map?.getBounds()
      console.log {bounds}
      coords = $scope.host?.coords
      console.log {coords}
      contains = bounds?.contains?(coords)
      console.log {contains}
      $scope.map.isHostVisible = contains

  link: (scope) ->
    scope.host = null
    scope.markers = {}
    scope.markerOptions = {}

    scope.centerYou = ->
      navigator.geolocation.getCurrentPosition scope.map.setCenter

    scope.centerHost = ->
      scope.map.setCenter scope.host

    createIcon = ({image, is_host}) ->
      if is_host
        url: '/img/jesse.png'
        scaledSize: new google.maps.Size (186 / 4), (518 / 4)
      else
        url: image
        scaledSize: new google.maps.Size 32, 32

    createMarker = ({user, coords}) ->
      return unless user
      {id, image} = user
      marker = scope.markers[id] ?= idKey: id, icon: createIcon user
      marker.coords = coords
      scope.host = marker if user.is_host

    deleteMarker = ({user}) ->
      return unless user
      {id} = user
      scope.marker[id]?.setMap(null)
      delete scope.markers[id] if scope.markers[id]?

    scope.map.on 'location:set', createMarker
    scope.map.on 'location:del', deleteMarker
    scope.$watch 'host', ->
      console.log 'map', scope.map
      scope.updateHostVisible(scope.map.control?.getGMap?())
    , true

    return

