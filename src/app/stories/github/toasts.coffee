angular.module 'jtg'

.run (toast, feeds) ->
  {socket} = feeds('stories/stories/jessethegame/all')

  socket.on 'data', ({provider, data}) ->
    return unless provider == 'github'
    toast
      payload: switch data.type
        when 'PushEvent'
          """
          I committed to #{data.repo.name} to "{{data.commit.message}}"
          """
          # '//github.com/{{data.repo.name}}/commit/{{data.commit.sha}}'
        when 'CreateEvent'
          """
          I created {data.repo.name}."
          """
          # '//github.com/{{data.repo.name}}'
        when 'WatchEvent'
          """
          I started watching #{data.repo.name} on github.
          """
          # '//github.com/{{data.repo.name}}'
        when 'IssuesEvent'
          """
          I #{data.action} an issue on #{data.repo.name}.
          #{data.issue.title}
          """
        else
          """
          I did something on github!
          """
