angular.module 'jtg'

.directive 'minimap', (socket) ->
  restrict: 'E'
  template: """
    {{area}}
    <google-map area="coords"></google-map>
  """
  link: (scope, elem) ->
    scope.coords =
      latitude: 0
      longitude: 0

    socket.on 'location', (coords) ->
      console.log {latitude, longitude}
      scope.coords = {latitude, longitude} = coords
