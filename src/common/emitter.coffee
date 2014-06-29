# A simple wrapper around the $rootScope to provide
# a less ugly service and some extra functionality
angular.module 'emitter', []

.service 'emitter', ($rootScope) ->
  on: (args...) ->
    $rootScope.$on args...
  emit: (args...) ->
    $rootScope.$emit args...
  once: (event, callback) ->
    remove = $rootScope.$on event, (args...) ->
      remove()
      callback args...
