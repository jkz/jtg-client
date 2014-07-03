angular.module 'jtg'

.service 'Dummy', (Provider, resolve) ->
  dummy = new Provider 'Dummy'
  dummy.creds = resolve
  dummy.disconnect = resolve
  dummy
