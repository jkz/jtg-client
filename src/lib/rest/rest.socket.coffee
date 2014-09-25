# Socket adapter for rest model backend
angular.module 'rest.socket', [
  'rest'
  'socket.io'
  'events'
]

.provider 'rocket', ->
  @config =
    host: undefined
    autoConnect: false

  @socket = null

  @$get = (io) =>
    @socket ||= io.connect @config.host if @config.autoConnect

    # Subscribe to socket events
    @register = (Model) =>
      @socket.on "#{Model.plural}", ({action, data}) =>
        remote = data
        local  = Model.cache[remote.id] ?= new Model

        switch action
          when 'create', 'update'
            angular.extend local, remote
          when 'destroy'
            delete Model.cache[local.id]

        #TODO add a way to describe to other actions

        Model.emitter.emit action, local

    this

  this

.run (rest, rocket) ->
  rest.emitter.on 'Api:new', (api) ->
    api.emitter.on 'Model:new', rocket.register
