angular.module 'jtg'

.controller 'ChatCtrl', ($scope, socket, session) ->
  $scope.messages = []

  $scope.broadcast = (msg) ->
    now = new Date
    name = session.user?.name ? 'Anonymous'
    socket.emit 'chat', "#{/\d\d:\d\d:\d\d/i.exec now.toString()} #{name}: #{msg}"

  socket.on 'chat', (msg) ->
    $scope.messages.push msg

.directive 'chat', (socket, session, $timeout) ->
  restrict: 'E'
  templateUrl: "app/chat/chat.html"
  link: (scope, elem) ->
    scope.session = session
    scope.messages = []

    scope.broadcast = (msg) ->
      return unless msg
      now = new Date
      name = session.user?.name ? 'Anonymous'
      # socket.emit 'chat', "#{/\d\d:\d\d:\d\d/i.exec now.toString()} #{name}: #{msg}"
      socket.emit 'chat', "#{/\d\d:\d\d/i.exec now.toString()} #{name}: #{msg}"

    socket.on 'chat.history', (messages) ->
      scope.messages = [messages..., scope.messages...]

    socket.on 'chat', (msg) ->
      scope.messages.push msg

    socket.emit 'chat.init'
