angular.module 'jtg.tutorial'

.controller 'GithubTutorialCtrl', ($scope, jtg) ->
  $scope.messages = [
    "I absolutely love writing code."
    "You can find all of the code I wrote for the game on my profile."
  ]

  # jtg
  #   .get '/rewards/github'
  #   .then (rewards) ->
  $scope.rewards =
    connect:
      points: 100
      count: 0
    follow:
      points: 200
      count: 0
    stargaze:
      points: 150
      count: 0
