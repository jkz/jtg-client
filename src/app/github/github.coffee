angular.module 'jtg'

.controller 'GithubCtrl', ($scope, github, $interval) ->
  $scope.user = 'jessethegame'

  console.log {github}

  do refreshActivities = ->
    github.activities($scope.user).success (data) ->
        $scope.activities = data.slice(0, 10)

  # $interval refreshActivities, 60000

