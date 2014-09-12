# angular.module 'jtg.conf', []

angular.module 'jtg', [
  # 'jtg.conf'

  'events'
  'socket.io'

  'rest'
  'rest.auth'

  'jtg.minimap'

  'facebook'
  'github'
  'promise'
  'concurrency'
  'toast'
  'feeds'

  'popdown'

  'angularMoment'
  'filters'
  'directives'
]

.config (toastProvider) ->
  toastProvider.config.autoExpose = true

.run (socket) ->
  socket.on 'connect', ->
    socket.emit 'init', 'client'

.service 'jesse', (hub) ->
  hub.hosts.for('jessethegame')

  #TODO keep track of the avatar location and scale
  # and render the toast bubbles accordingly

.run ($window, $rootScope) ->
  $win = angular.element($window)

  do updateScrollAtIntro = ->
    scrollTop = $win.scrollTop()
    switch
      when scrollTop > 300 and $rootScope.scrollAtIntro
        $rootScope.scrollAtIntro = false
      when scrollTop <= 300 and not $rootScope.scrollAtIntro
        $rootScope.scrollAtIntro = true
      else
        return
    $rootScope.$apply()

  $win.on 'scroll', updateScrollAtIntro
