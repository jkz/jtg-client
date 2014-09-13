angular.module 'jtg'

.config (socketProvider) ->
  socketProvider.config.host = 'http://hub.jessethegame.net'

.config (feedsProvider) ->
  feedsProvider.config.host = 'http://hub.jessethegame.net'

.config (jtgProvider) ->
  jtgProvider.config.host = 'http://api.jessethegame.net'

.config (minimapProvider) ->
  minimapProvider.config.host = 'http://hub.jessethegame.net'

