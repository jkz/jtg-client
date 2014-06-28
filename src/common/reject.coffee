angular.module 'reject' []

.service 'reject', ($q, toast, log) ->
  # TODO
  # - minimum level to toast
  (reason, level='info') ->
    toast reason
    log[level] reason
    $q.reject reason
