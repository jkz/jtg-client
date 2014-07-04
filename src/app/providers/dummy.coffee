angular.module 'jtg'

.service 'Dummy', (Provider, resolve) ->
  dummy = new Provider 'Dummy'
  dummy.creds = (creds) ->
    resolve creds ? name: 'dummy'
  dummy.disconnect = resolve
  dummy
