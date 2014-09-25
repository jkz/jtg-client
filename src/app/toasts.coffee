angular.module 'jtg'

.service 'slang', ->
  sample = (arr) -> arr[Math.floor(Math.random() * arr.length)]

  slang =
    hi: ->
      sample(['Hey', 'Sup', 'Hi', 'Welcome', 'Heya', 'Yo'])
    bye: ->
      sample(['Bye', 'Cya', 'Later', 'Ciao', 'Peace'])
    idle: ->
      sample([
        "Are you ok? Click me if you need any help!"
        "Like what you see? I'm up for hire!"
        "You look nice today."
        "Have you listened to my track Arcadia yet?"
        "Tell a friend! If you hashtag #jtg you'll even score points..."
        "I work hard to improve my game."
        "People used to laugh when I told them I'd be a comedian. Now they don't."
      ])


.run (toast, session, feeds, io, slang, Challenge) ->
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

  Challenge.emitter.on 'create', ({text}) ->
    toast.create "New challenge: #{text}"

.run ($timeout, $window, slang, toast) ->
  messages = [
    "Are you ok? Click me if you need any help!"
    "Like what you see? I'm up for hire!"
    "You look nice today."
    "Have you listened to my track Arcadia yet?"
    "Tell a friend! If you hashtag #jtg you'll even score points..."
    "I work hard to improve my game."
    "People used to laugh when I told them I'd become a comedian. Now they don't laugh anymore."
  ]

  timeout = null

  do resetTimer = ->
    $timeout.cancel timeout if timeout
    timeout = $timeout ->
      return unless messages.length
      toast.create messages.shift()
      resetTimer()
    , 5000

  $win = angular.element($window)
  $win.on 'click', resetTimer

