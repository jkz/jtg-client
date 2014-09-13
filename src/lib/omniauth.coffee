angular.module 'omniauth', []

.provider 'omniauth', ->
  @config =
    host: ''
    interval: 200

  @$get = ($window, $q, $interval) =>
    @authenticate = (provider) =>
      return $q.reject 'in progress' if $window.OmniauthCallback

      dfd = $q.defer()

      child = $window.open "#{@config.host}/auth/#{provider}"

      $win = angular.element(window)
      $win.on 'message', handler = ({originalEvent}) =>
        {data, origin} = originalEvent
        console.log {data, origin}
        return unless origin == @config.host
        dfd.resolve data
        $win.off 'message', handler

      $window.OmniauthCallback = (data) ->
        alert 'OMNIAUTH'
        console.log "OMNIAUTH", {data}
        data.provider = provider
        dfd.resolve data
        delete $window.OmniauthCallback

      stop = $interval ->
        return unless child.closed
        $interval.cancel stop
        delete $window.OmniauthCallback
        dfd.reject 'no response'

      dfd.promise

    this

  this
