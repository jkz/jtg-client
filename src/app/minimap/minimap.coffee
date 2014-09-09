angular.module 'jtg.minimap', [
  'ui.map'
  'socket.io'
]

.directive 'minimap', (socket) ->
  restrict: 'E'
  template: """
    {{area}}
    <google-map area="coords" markers="locations"></google-map>
  """
  link: (scope, elem) ->
    scope.coords =
      latitude: 0
      longitude: 0

    scope.locations = {}

    socket.on 'location', ({user, coords}) ->
      scope.locations[user.id] =
        id: user.id
        icon: user.image
        latitude: coords.latitude
        longitude: coords.longitude

      # scope.coords = {latitude, longitude} = coords
