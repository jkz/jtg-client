angular.module 'jtg'

.service 'Provider', (EventEmitter, jtg, lock) ->
  class Provider
    @cache = {}

    emitter: new EventEmitter

    constructor: (@name, @slug) ->
      @slug ?= @name.toLowerCase()
      Provider.cache[@slug] = this

      @connect = lock "Connecting", (args...) =>
        @creds args...
          .then (creds) =>
            jtg.auth.connect
              provider: @slug
              creds: creds

    creds: ->
      throw new Error "Not implemented"

  Provider

.directive 'provider', ->
  restrict: 'E'
  templateUrl: 'app/provider/provider.html'

.service 'providers', (Provider, Facebook, Twitter, Github) ->
  # TODO make this a provider, so the set of providers
  # are configurable
  Provider.cache
