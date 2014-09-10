angular.module 'jtg'

.config (facebookProvider) ->
  facebookProvider.config.appId = 299095383509760

.config (githubProvider) ->
  githubProvider.config.clientId = '96acc831e0388a4b4afc'

.config (socketProvider) ->
  socketProvider.config.host = 'http://hub.staging.jessethegame.net'

.config (feedsProvider) ->
  feedsProvider.config.host = 'http://hub.staging.jessethegame.net'

.config (jtgProvider) ->
  jtgProvider.config.host = 'http://api.staging.jessethegame.net'

.config (minimapProvider) ->
  minimapProvider.config.host = 'http://hub.staging.jessethegame.net'
