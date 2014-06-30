angular.module 'jtg'

.factory 'Challenge', (jtg) ->
  Challenge = jtg.model 'challenges'

  Challenge::boost = (amount) ->
    jtg
      .post "/challenges/#{@id}/points", {amount}
      .then =>
        @points += amount

  Challenge

.controller 'ChallengeCtrl', ($scope, Challenge) ->
  $scope.categories =
    '$100':
      title: "$100 Challenge"
      text: "What should Jesse do with $100?"
    busk:
      title: "Busking Challenge"
      text: "What song should Jesse busk?"
    code:
      title: "Coding Challenge"
      text: "What feature should Jesse add to the site?"
    skill:
      title: "Skill Challenge"
      text: "What skill should Jesse acquire in a week?"
    assassin:
      title: "Assassination Challenge"
      text: "Who should Jesse assassinate by water gun?"
    social:
      title: "Social Challenge"
      text: "What social experiment should Jesse perform?"

  $scope.challenges = []

  Challenge
    .index()
    .then (challenges) ->
      # $scope.challenges = Challenge.cache
      $scope.challenges = challenges

.directive 'challenge', ->
  restrict: 'E'
  templateUrl: 'app/challenge/challenge.html'
