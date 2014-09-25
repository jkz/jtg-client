angular.module 'jtg.conf'

.config (toastProvider) ->
  toastProvider.config.autoExpose = true

.config (HOSTS) ->
  console.log {HOSTS}

.config (socketProvider, HOSTS) ->
  socketProvider.config.host = HOSTS.HUB

.config (feedsProvider, HOSTS) ->
  feedsProvider.config.host = HOSTS.HUB

.config (jtgProvider, HOSTS) ->
  jtgProvider.config.host = HOSTS.API

.config (minimapProvider, HOSTS) ->
  minimapProvider.config.host = HOSTS.HUB

.config (hubProvider, HOSTS) ->
  hubProvider.config.host = HOSTS.HUB

.config (rocketProvider, HOSTS) ->
  rocketProvider.config.host = HOSTS.HUB + '/rocket'
  rocketProvider.config.autoConnect = true

.config (omniauthProvider, HOSTS) ->
  omniauthProvider.config.host = HOSTS.API
