# An extension of the lovely $q service
angular.module 'promise', [
  'toast'
]

# Extend the $q object
.run ($q) ->
  # TODO test if this runs before it dependent services are
  $q.resolve = (args...) ->
    dfd = $q.defer()
    dfd.resolve args...
    dfd.promise

.service 'promise', (resolve, reject) ->
  {resolve, reject}

.service 'resolve', ($q, toast) ->
  # TODO
  # - clear toast circumstances
  (reason, level='silent') ->
    unless level == 'silent'
      console[level] reason
      toast.create reason
    $q.resolve reason

.service 'reject', ($q, toast) ->
  # TODO
  # - minimum level to toast
  (reason, level='log') ->
    unless level == 'silent'
      console[level] reason
      toast.create reason
    $q.reject reason
