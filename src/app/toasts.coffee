angular.module 'jtg'

.run (toast, session) ->
  session.emitter.on 'connect', (user) ->
    toast.create "Welcome #{user.name}!"

  session.emitter.on 'disconnect', (user) ->
    toast.create "Bye #{user.name}!"
