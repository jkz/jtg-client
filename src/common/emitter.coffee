angular.module 'emitter', []

.service 'emitter', ($rootScope) ->
  on: (args...) ->
    $rootScope.$on args...
  emit: (args...) ->
    $rootScope.$broadcast args...
