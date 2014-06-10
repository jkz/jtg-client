angular.module 'jtg'

.controller 'ChatCtrl', ($scope, socket, session) ->
  console.log "ChatCtrl"
  $scope.messages = []

  $scope.send = (msg) ->
    now = new Date
    name = session.user?.name ? 'Anonymous'
    socket.emit 'broadcast', "#{now} #{name}: #{msg}"

  socket.on 'broadcast', (msg) ->
    console.log 'broadcast', msg
    $scope.messages.unshift msg
    $scope.messages = $scope.messages[0..8]
