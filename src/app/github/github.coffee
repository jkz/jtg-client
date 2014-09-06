angular.module 'jtg'

.controller 'GithubCtrl', ($scope, toast, feeds) ->
  {socket, entries} = feeds 'github'

  $scope.user = 'jessethegame'
  $scope.activities = entries

  socket.on 'entry', (activity) ->
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
