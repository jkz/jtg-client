angular.module 'jtg'

.service 'Mock', (Provider, resolve) ->
  mock = new Provider 'Mock'
  mock.creds = (creds) ->
    resolve creds ? id: 1, name: 'Mock'
  mock.disconnect = resolve
  mock
