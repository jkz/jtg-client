angular.module 'jtg'

.config (socketProvider) ->
  socketProvider.config.host = 'http://localhost:8080'

.config (feedsProvider) ->
  feedsProvider.config.host = 'http://localhost:8080'

.config (jtgProvider) ->
  jtgProvider.config.host = 'http://localhost:3000'

.config (minimapProvider) ->
  minimapProvider.config.host = 'http://localhost:8080'

.config (hubProvider) ->
  hubProvider.config.host = 'http://localhost:8080'

.config (omniauthProvider) ->
  omniauthProvider.config.host = 'http://localhost:3000'

.run (Account, Provider) ->
  Account.providers.push Provider.create 'Developer'
