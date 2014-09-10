angular.module 'jtg'

.provider 'jtg', ->
  @config =
    host: null

  @$get = (Api) =>
    new Api 'jtg', @config.host

  this

.factory 'Reward', (jtg) ->
  jtg.model 'rewards'