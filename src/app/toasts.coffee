angular.module 'jtg'

.run (toast, session, feeds) ->
  session.emitter.on 'connect', (user) ->
    toast.create "Welcome #{user.name}!"

  session.emitter.on 'disconnect', (user) ->
    toast.create "Bye #{user.name}!"

  feeds('/mock/hosts/jessethegame/all').socket.on 'data', (data) ->
    toast.create JSON.stringify(data)

  feeds('/rewards/all').socket.on 'data', (data) ->
    toast.create JSON.stringify(data)
