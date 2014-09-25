angular.module 'jtg'

.service 'Challenge', (jtg, toast, session, User) ->
  Challenge = jtg.model 'challenges'

  Challenge.hasOne User

  Challenge::init = ->
    Object.defineProperty this, 'timestamp',
      get: =>
        new Date(@created_at).getTime()

  Challenge::boost = (amount) ->
    jtg
      .post "/challenges/#{@id}/points", {amount}
      .catch ({message}) ->
        toast message ? "Could not boost the challenge"
      .then ({challenge, user}) =>
        @extend challenge
        session.user.extend user

  Challenge

.controller 'ChallengeCtrl', ($scope, Challenge, lock, reject, toast) ->
  $scope.createChallenge = lock "Creating challenge", ->
    return reject "That's not a challenge." unless $scope.challenge

    Challenge
      .create $scope.challenge
      .catch toast.create
      .then ->
        $scope.challenge = null

  $scope.challenges = Challenge.cache

  Challenge.index()

.directive 'challenge', ->
  restrict: 'E'
  templateUrl: 'app/challenge/challenge.html'
