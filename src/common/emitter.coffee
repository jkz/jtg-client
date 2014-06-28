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
