angular.module 'jtg'

.provider 'hub', ->
  @config =
    host: ''

  @$get = (io) ->
    sockets =
      users: {}
      hosts: {}
      chat: {}

    channel = (namespace) =>
      # obj =
      #   forget: (uid) ->
      #     return unless sockets[namespace][uid]
      #     obj.all.leave(uid)
      #     delete sockets[namespace][uid]

      # Object.defineProperty obj, 'all',
      #   value: io.connect("#{@config.host}/#{namespace}")

      # Object.defineProperty obj, 'for',
      #   get: ->
      #     (uid) ->
      #       console.log {obj}

      #       return sockets[namespace][uid] if sockets[namespace][uid]
      #       obj.all.join(uid)
      #       sockets[namespace][uid] = obj.all.to(uid)
      # obj
      io.connect("#{@config.host}/#{namespace}")

      # all: io.connect("#{@config.host}/#{namespace}")
      # in: (uid) ->
      #   return sockets[namespace][uid] if sockets[namespace][uid]
      #   hub[namespace]all.join(uid)
      #   sockets[namespace][uid] = hub[namespace].all.to(uid)
      # out: (uid) ->
      #   return unless sockets[namespace][uid]
      #   hub[namespace]all.leave(uid)
      #   delete sockets[namespace][uid]

    users: channel 'users'
    hosts: channel 'hosts'
    chat: channel 'chat'

  this
