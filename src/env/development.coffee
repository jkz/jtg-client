angular.module 'jtg'

.config (facebookProvider) ->
  facebookProvider.config.appId = 299095383509760

.config (githubProvider) ->
  githubProvider.config.clientId = '96acc831e0388a4b4afc'

.config (socketProvider) ->
  socketProvider.config.host = 'http://localhost:8080'

.config (feedsProvider) ->
  feedsProvider.config.host = 'http://localhost:8080'

.config (jtgProvider) ->
  jtgProvider.config.host = 'http://localhost:3000'

.config (minimapProvider) ->
  minimapProvider.config.host = 'http://localhost:8080'

.run (Mock) ->
  # Enable the mock provider
  null
