# Socket adapter for rest model backend
angular.module 'rest.socket', [
  'socket.io'
  'events'
]

.provider 'rocket', ->
  @config =
    host: undefined

  @socket = undefined

  @$get = (io) =>
    @socket ||= io.connect @config.host

    # Subscribe to socket events
    register: (Model) ->
      socket.on "#{Model.plural}", ({event, data}) =>
        remote = data[Model.singular]
        local  = Model.cache[remote.id] ?= new Model

        switch event
          when 'create', 'update'
            local.extend remote
          when 'delete'
            delete Model.cache[local.id]

        Model.emit event, local

    this

.run (rest, rocket) ->
  rest.on 'Api:new', (api) ->
    api.on 'Model:new', rocket.register
