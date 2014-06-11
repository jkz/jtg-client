angular.module 'jtg'

.controller 'ChatCtrl', ($scope, socket, session) ->
  console.log "ChatCtrl"
  $scope.messages = []

  $scope.broadcast = (msg) ->
    now = new Date
    name = session.user?.name ? 'Anonymous'
    socket.emit 'broadcast', "#{/\d\d:\d\d:\d\d/i.exec now.toString()} #{name}: #{msg}"

  socket.on 'broadcast', (msg) ->
    console.log 'broadcast', msg
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
      socket.emit 'broadcast', "#{/\d\d:\d\d:\d\d/i.exec now.toString()} #{name}: #{msg}"

    socket.on 'broadcast', (msg) ->
      console.log 'broadcast', msg
      scope.messages.push msg
      $timeout ->
        elem.animate {scrollTop: 10000}, 200
      , 0

