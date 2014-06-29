# An extension of the lovely $q service
angular.module 'promise' []

# Extend the $q object
.run ($q) ->
  # TODO test if this runs before it dependent services are
  $q.resolve = (args...) ->
    dfd = $q.defer()
    dfd.resolve args...
    dfd.promise

.service 'resolve', ($q, toast, log) ->
  # TODO
  # - clear toast circumstances
  (reason, level='info') ->
    log[level] reason
    toast reason
    $q.resolve reason

.service 'reject', ($q, toast, log) ->
  # TODO
  # - minimum level to toast
  (reason, level='info') ->
    log[level] reason
    toast reason
    $q.reject reason
