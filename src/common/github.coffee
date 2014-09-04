angular.module 'github', []

.provider 'github', ->
  @config =
    clientId: null
    exchangeUrl: '/tokens'

  @$get = ($http, popdown) =>
    api = (url, params, status, error) ->
      $http
        method: 'GET'
        url: 'https://api.github.com' + url
        params: params

    login: =>
      # Generate state
      # Store state (maybe make it the key on window that the child assigns to!!)
      # The child should pass a request_token
      popdown "https://github.com/login/oauth/authorize?client_id=#{@config.clientId}"

    commits: (name, repo, params) ->
      url = "/repos/#{name}/#{repo}/commits"
      api(url, params)
        .success (data, status, headers, config) ->
          console.log 'commits success', data
        .error (data, status, headers, config) ->
          console.log 'commits success', data

    repos: (name, params) ->
      url = "/repos/#{name}"
      api(url, params)

    activities: (name, params) ->
      url = "/users/#{name}/events"
      api(url, params)

  this
