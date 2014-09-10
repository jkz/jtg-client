angular.module 'jtg.minimap'

.service 'navigator', ($rootScope) ->
  throw "Geolocation not supported" unless navigator?.geolocation?

  geolocation:
    getCurrentPosition: (callback) ->
      navigator.geolocation.getCurrentPosition (args...) ->
        $rootScope.$apply ->
          callback args...

# TODO
# - pass in host/channel as parameter to support multiple minimaps
.provider 'minimap', ->
  @config =
    host: null
    namespace: '/location'

  @$get = (io, navigator, $interval) =>

    stopper = null

    console.log {google}
    console.log google.maps

    @feed =
      coords: undefined
      socket: io.connect("#{@config.host}#{@config.namespace}")
      running: no

      broadcast: (coords) =>
        @feed.socket.emit('location', coords ? @feed.coords)

      locate: =>
        navigator.geolocation.getCurrentPosition ({coords}) =>
          @feed.coords = coords

      start: =>
        stopper ?= $interval @feed.locate, 3000
        @feed.running = yes

      stop: =>
        @feed.running = no
        stopper?()
        stopper = null

    this

  this

.directive 'minimap', (minimap, navigator, $timeout) ->
  restrict: 'E'
  templateUrl: 'app/minimap/minimap.html'

  controller: ($scope) ->
    # TODO
    # Not entirely sure why this doesn't work on link,
    # but does work as controller. Maybe a priority thing?
    $scope.map =
      zoom: 15
      center:
        latitude: 0
        longitude: 0

  link: (scope) ->
    scope.minimap = minimap

    scope.markers = {}
    scope.markerOptions = {}

    scope.center = ({longitude, latitude}) ->
      scope.map.center = {longitude, latitude}

    scope.centerYou = ->
      navigator.geolocation.getCurrentPosition ({coords}) ->
        console.log "COORDS", {coords}
        scope.center coords

    scope.centerHost = ->
      # TODO special case jesse
      scope.center (scope.markers.Jesse ? scope.markers.Anon)?.coords

    createIcon = (url) ->
      # url: url
      # scaledSize: new google.maps.Size 32, 32
      url: '/img/jesse.png'
      scaledSize: new google.maps.Size (186 / 4), (518 / 4)

    createMarker = ({name, image}) ->
      idKey: name
      icon: createIcon image

    minimap.feed.socket.on 'location', ({coords, user}) ->
      {longitude, latitude} = coords
      marker = scope.markers[user.name] ?= createMarker user
      marker.coords = {longitude, latitude}
      # marker.label = user.name
      scope.map.center = {longitude, latitude}

# .run ($rootScope) ->
#   $rootScope.map =
#     zoom: 15
#     center:
#       latitude: 0
#       longitude: 0

