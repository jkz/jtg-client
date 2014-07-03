angular.module 'jtg'

.factory 'Challenge', (jtg, toast, session) ->
  Challenge = jtg.model 'challenges'

  Challenge::boost = (amount) ->
    jtg
      .post "/challenges/#{@id}/points", {amount}
      .catch ({message}) ->
        toast message ? "Could not boost the challenge"
      .then =>
        # TODO maybe return challenge and user total in response
        @points += amount
        session.user.points -= amount

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

  $scope.challenges = Challenge.cache

  Challenge.index()

.directive 'challenge', ->
  restrict: 'E'
  templateUrl: 'app/challenge/challenge.html'
