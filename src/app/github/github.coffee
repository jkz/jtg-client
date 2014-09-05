angular.module 'jtg'

.controller 'GithubCtrl', ($scope, socket) ->
  $scope.user = 'jessethegame'
  $scope.activities = []

  socket.on 'github', (activity) ->
    $scope.activities.unshift activity

  socket.on 'github.history', (events) ->
    $scope.activities = [$scope.activities..., events...]

  socket.emit 'github.init'

