angular.module 'jtg'

.provider 'github', ->
  @config =
    clientId: '96acc831e0388a4b4afc'
    exchangeUrl: '/tokens'

  @$get = ($window, $q, popdown) =>
    login: =>
      # Generate state
      # Store state (maybe make it the key on window that the child assigns to!!)
      # The child should pass a request_token
      popdown "https://github.com/login/oauth/authorize?client_id=#{@config.clientId}"

  this

.service 'Github', (Provider, github) ->
  Github = new Provider 'Github'
  Github.creds = github.login
  Github.disconnect = ->
  Github
