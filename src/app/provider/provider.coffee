angular.module 'jtg'

.service 'Provider', (EventEmitter, jtg) ->
  class Provider
    @cache = {}

    emitter: new EventEmitter

    constructor: (@name, @slug) ->
      @slug ?= @name.toLowerCase()
      Provider.cache[@slug] = this

    creds: ->
      throw new Error "Not implemented"

    connect: (args...) ->
      @creds args...
        .then (creds) =>
          jtg.auth.connect
            provider: @slug
            creds: creds

  Provider

.directive 'provider', ->
  restrict: 'E'
  templateUrl: 'app/provider/provider.html'

.service 'providers', (Provider, Facebook, Dummy) ->
  # TODO make this a provider, so the set of providers
  # are configurable
  Provider.cache
