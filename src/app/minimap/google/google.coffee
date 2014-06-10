angular.module('google', [
  'google.maps'
])

.service 'google', ($window) ->
  $window.google
