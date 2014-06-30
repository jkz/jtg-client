angular.module 'jtg'

.service 'Provider', (jtg, auth) ->
  class Provider
    @cache = {}

    constructor: (name, slug) ->
      @slug ?= name.toLowerCase()
      Provider.providers[@slug] = @

    connect: (creds) ->
      auth.connect @slug, creds

.directive 'provider', ->
  restrict: 'E'
  templateUrl: 'app/provider/provider.html'

.run ($rootScope, Provider) ->
  $rootScope.providers = Provider.cache