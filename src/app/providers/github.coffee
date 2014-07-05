angular.module 'jtg'

.provider 'github', ->
  @config =
    clientId: '96acc831e0388a4b4afc'

  @$get = ($window, $q, $interval) ->
    login: ->
      dfd = $q.defer()

      # Generate state
      # Store state (maybe make it the key on window that the child assigns to!!)
      # The child should pass a request_token
      child = $window.open "https://github.com/login/oauth/authorize?state=#{state}&client_id=#{@config.clientId}"

      stop = $interval ->
        return unless child.closed
        stop()
        # Read the code from the state key
        code = null
        dfd.resolve {code}
      , 1000

      dfd.promise

.service 'Github', (Provider, github) ->
  Github = new Provider 'Github'
  Github.creds = github.login
  Github.disconnect = ->
  Github
