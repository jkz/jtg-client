angular.module 'jtg'

.controller 'ChatCtrl', ($scope, socket, session) ->
  console.log "ChatCtrl"
  $scope.messages = []

  $scope.broadcast = (msg) ->
    now = new Date
    name = session.user?.name ? 'Anonymous'
    socket.emit 'chat', "#{/\d\d:\d\d:\d\d/i.exec now.toString()} #{name}: #{msg}"

  socket.on 'chat', (msg) ->
    console.log 'chat', msg
    $scope.messages.push msg

.directive 'chat', (socket, session, $timeout) ->
  restrict: 'E'
  templateUrl: "app/chat/chat.html"
  link: (scope, elem) ->
    scope.session = session
    scope.messages = []

    scope.broadcast = (msg) ->
      now = new Date
      name = session.user?.name ? 'Anonymous'
      socket.emit 'chat', "#{/\d\d:\d\d:\d\d/i.exec now.toString()} #{name}: #{msg}"

    socket.on 'chat.history', (messages) ->
      scope.messages = [messages..., scope.messages...]

    socket.on 'chat', (msg) ->
      scope.messages.push msg

    socket.emit 'chat.init'

.directive 'watchBottom', ->
  restrict: 'A'
  scope:
    target: '=watchBottom'
    transition: '='
  link: (scope, elem) ->
    _elem = elem[0]

    scope.$watch 'target', ->
      # elem.animate {scrollTop: elem.height()}, scope.transition ? 0
      _elem.scrollTop = _elem.offsetHeight
