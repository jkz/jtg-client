angular.module 'jtg'

.controller 'GithubCtrl', ($scope, socket) ->
  $scope.user = 'jessethegame'
  $scope.activities = []

  socket.on 'github', (activity) ->
    $scope.activities.push activity

  socket.on 'github.history', (events) ->
    $scope.activities = [events..., $scope.activities...]

  socket.emit 'github.init'

