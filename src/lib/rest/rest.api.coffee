# This is a rest api adapter for proper resources.
#
# .factory 'api', (rest) ->
#   new rest '/api/v1'
#
# .factory 'Book', (api) ->
#   api.model 'books'
#
# .factory 'Property' (api) ->
#   api.model 'properties', 'property'
#
# TODO fix nested resource support, namely the endpoints need to be sorted.
# TODO decide on inheritance vs composition, in this case for the eventemitter
angular.module 'rest.api', [
  'events'
]

.factory 'Rest', (EventEmitter) ->
  class Rest
    constructor: ->
      @emitter = new EventEmitter
      @apis = {}

    register: (api) ->
      @apis[api.name] = api
      @emitter.emit 'Api:new', api

.service 'rest', (Rest) ->
  new Rest

.factory 'Api', ($http, $q, rest, EventEmitter) ->
  class Api
    constructor: (@name, @endpoint) ->
      @emitter = new EventEmitter
      @models = {}
      @headers = {}

      rest.register this

    register: (Model) =>
      @models[Model.plural] = Model
      @emitter.emit 'Model:new', Model


    http: (method, url, data, {headers, parsed}={}) =>
      console.log "HEADERS", angular.extend {}, @headers, headers
      response = $http
        url: "#{@endpoint}#{url}.json"
        method: method
        data: data
        headers: angular.extend {}, @headers, headers

      return response unless parsed

      response
        .error ({data}) ->
          data
        .error ({code, reason}) ->
          console.log 'rest.error', code, reason
        .then (response) ->
          console.log 'rest', method, url, data
          response

    get:  (url, query) -> @http 'get', url, query, parsed: true
    post: (url, params) -> @http 'post', url, params, parsed: true
    put:  (url, params) -> @http 'put',  url, params, parsed: true
    del:  (url) -> @http 'delete', url, null, parsed: true

    model: (plural, {singular, parent, endpoint}={}) ->
      api = this

      class Model extends EventEmitter
        @emitter = new EventEmitter
        @plural = plural
        @singular = singular ?= plural[...plural.length - 1] # Strip trailing s from plural unless given

        @endpoint = endpoint ? '/' + plural

        @cache = {}

        @_one = {}

        # TODO
        # These are not used atm, but could be a way to define model fields
        # to send on create/update, or even marshal the data.
        @fields = []
        @schema = {}

        api.register this

        # Either
        # - (id) return an instance by id
        # - (object with id) return an updated instance by id
        # - (object without id) return a fresh uncached instance
        @build: (data={}, options) =>
          return @cache[data] if not typeof data == 'object'
          instance = @cache[data.id] if data.id
          return instance.extend(data) if instance
          new this data, options

        @cacheAdd: (obj) =>
          @cache[obj.id] = obj if obj?.id

        ### Class Methods ###
        @create: (data, options) =>
          throw "Don't pass in id for create!" if data?.id
          instance = new this data, options
          instance.create()

        @index: (query) =>
          api
            .get @endpoint, query
            .then ({data}) =>
              @build obj for obj in data[@plural]

        @show: (id) =>
          return $.when @cache[id] if @cache[id]?

          api
            .get "#{@endpoint}/#{id}"
            .then ({data}) =>
              @build data[@singular]

        @update: (id, data) =>
          params = {}
          params[@singular] = data
          api.put @endpoint, params

        @destroy: (id) =>
          api
            .del "#{@endpoint}/#{id}"
            .then =>
              delete @cache[id]

        @hasOne: (Other, key) =>
          @_one[key ? Other.singular] = Other

        @hasMany: (Other, key) =>
          @_many[key ? Other.plural] = Other

        ### Instance Methods ###

        constructor: (data, {uncached}={}) ->
          super

          # Important to extend before caching, because the id needs to
          # be on the instance before it can be cached. Duh? :D
          @extend data

          # TODO we don't want to cache the minis I guess...
          @constructor.cacheAdd this unless uncached

          # WORK IN PROGRESS
          # for key, Class of @many
          #   @[key] =
          #     switch typeof @[key]
          #       when 'array'
          #         (new Class data for data in @[key])
          #       when 'object'
          #         (new Class data for _, data of @[key])
          #       else
          #         []
          @init()

        init: ->
          null

        create: (owner) =>
          prefix = if owner then "#{owner.constructor.endpoint}/#{owner.id}" else ''

          params = {}
          obj = params[@constructor.singular] = this
          api
            .post "#{prefix}/#{@constructor.endpoint}", params
            .then (response) =>
              response[@constructor.singular]
            .then @extend
            .then @constructor.cacheAdd
            .then (obj) =>
              (owner[@constructor.plural] ?= []).push obj if owner
              obj

        update: ->
          @constructor.update @id, this

        destroy: ->
          @constructor.destroy @id

        # XXX experimental, this could easily have unwanted side effects
        extend: (data={}) =>
          for key, val of data
            @[key] = switch
              when @[key]?.extend?
                @[key].extend val
              when Class = @constructor._one[key]
                Class.build val
              # when Class = @constructor._many[key]
              #   switch typeof @[key]
              #     when 'array'
              #       (new Class data for data in val)
              #     when 'object'
              #       (new Class data for _, data of val)
              #     else
              #       []
              else
                @[key] = val
          this

        serialize: =>
          obj = {}
          for key, val of this
            obj[key] =
              if val?.serialize?
                val.serialize()
              else
                val
          obj
