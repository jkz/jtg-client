angular.module 'jtg'

.controller 'GithubCtrl', ($scope, socket, toast) ->
  $scope.user = 'jessethegame'
  $scope.activities = []

  socket.on 'github', (activity) ->
    $scope.activities.unshift activity
    toast
      payload: switch activity.type
        when 'PushEvent'
          """
          I committed to #{activity.repo.name} to "{{commit.message}}"
          """
          # '//github.com/{{activity.repo.name}}/commit/{{commit.sha}}'
        when 'CreateEvent'
          """
          I Created {activity.repo.name}."
          """
          # '//github.com/{{activity.repo.name}}'
        when 'WatchEvent'
          """
          I started watching #{activity.repo.name} on github.
          """
          # '//github.com/{{activity.repo.name}}'
        when 'IssuesEvent'
          """
          I #{activity.payload.action} an issue on #{activity.repo.name}.
          #{activity.payload.issue.title}
          """
        else
          """
          I did something on github!
          """

  socket.on 'github.history', (events) ->
    $scope.activities = [$scope.activities..., events...]

  socket.emit 'github.init'

