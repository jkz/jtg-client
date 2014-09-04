angular.module 'jtg'

.service 'Github', (Provider, github) ->
  Github = new Provider 'Github'
  Github.creds = github.login
  Github.disconnect = ->
  Github
