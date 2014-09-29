angular.module 'jtg'

# ## Provider
# ---
# Representation of authentication (and perhaps api) providers
.service 'Provider', (auth) ->
  class Provider
    @cache = {}

    @create = (args...) =>
      provider = new this args...
      @cache[provider.slug] = provider

    constructor: (@name, @slug) ->
      @slug ?= @name.toLowerCase()

    connect: =>
      auth.connect @slug

.directive 'provider', ->
  restrict: 'E'
  templateUrl: 'app/provider/provider.html'
  controller: ($scope, Account) ->
    $scope.Account = Account

