angular.module 'jtg'

.config (socketProvider) ->
  socketProvider.config.host = 'http://hub.staging.jessethegame.net'

.config (feedsProvider) ->
  feedsProvider.config.host = 'http://hub.staging.jessethegame.net'

.config (jtgProvider) ->
  jtgProvider.config.host = 'http://api.staging.jessethegame.net'

.config (minimapProvider) ->
  minimapProvider.config.host = 'http://hub.staging.jessethegame.net'
