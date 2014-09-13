# An extension of the lovely $q service
angular.module 'promise', [
  'toast'
]

.service 'promise', (resolve, reject) ->
  {resolve, reject}

.service 'resolve', ($q, toast) ->
  # TODO
  # - clear toast circumstances
  (result, level='silent') ->
    unless level == 'silent'
      console[level] result
      toast.create result
    $q.when result

.service 'reject', ($q, toast) ->
  # TODO
  # - minimum level to toast
  (reason, level='log') ->
    unless level == 'silent'
      console[level] reason
      toast.create reason
    $q.reject reason
