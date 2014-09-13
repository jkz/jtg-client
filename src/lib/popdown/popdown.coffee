# Popdown is a blank page that passes query parameters over to
# the parent screen with the value of `state` as key
# on the _popdown object. The window then closes itself.
# The parent window polls the child window until it's closed
# and resolves a promise.
angular.module 'popdown', []

.provider 'popdown', ->
  @config =
    interval: 1000
    stateKey: 'state'
    redirectUri: window.location.origin + '/lib/popdown/popdown.html'
    redirectKey: 'redirect_uri'

  @$get = ($window, $q, $interval) =>
    $window._popdown = {}

    popdown = (url, options={}) =>
      for key, val of @config
        options[key] ?= val

      options.state ?= popdown.generateState()

      # TODO This is ugly with the edge case of a trailing '?'
      url = [
        url
        if '?' in url then '&' else '?'
        "#{options.stateKey}=#{options.state}&#{options.redirectKey}=#{options.redirectUri}"
      ].join ''

      child = $window.open url

      dfd = $q.defer()
      stop = $interval ->
        return unless child.closed
        $interval.cancel stop
        # Read the code from the state key
        data = $window._popdown[options.state]
        console.log "POPDOWN", {data}
        return dfd.reject "No popdown data for #{options.state}" unless data
        dfd.resolve data
      , options.interval

      dfd.promise

    popdown.generateState = ->
      Math.random().toString(36).slice(2)

    popdown

  this