angular.module 'jtg'

.service 'slang', ->
  sample = (arr) -> arr[Math.floor(Math.random() * arr.length)]

  slang =
    hi: ->
      sample(['Hey', 'Sup', 'Hi', 'Welcome', 'Heya', 'Yo'])
    bye: ->
      sample(['Bye', 'Cya', 'Later', 'Ciao', 'Peace'])

.run (toast, session, feeds, io, slang) ->
  session.emitter.on 'connect', (user) ->
    toast.create "#{slang.hi()} #{user.name}!"

  session.emitter.on 'disconnect', (user) ->
    toast.create "#{slang.bye()} #{user.name}!"

  feeds('/mock/hosts/jessethegame/all').socket.on 'data', (data) ->
    toast.create JSON.stringify(data)

  feeds('/rewards/all').socket.on 'data', (data) ->
    toast.create JSON.stringify(data)

  io.connect('http://localhost:8080/jessethegame').on 'data', (data) ->
    toast.create JSON.stringify(data)
