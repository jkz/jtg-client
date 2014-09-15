angular.module 'jtg.conf'

.constant 'HOSTS',
  API: 'http://localhost:3000'
  HUB: 'http://localhost:8080'

.run (Account, Provider) ->
  Account.providers.push Provider.create 'Developer'
