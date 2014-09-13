angular.module 'omniauth', []

.provider 'omniauth', ->
  @config =
    host: ''
    interval: 200

  @$get = ($window, $q, $interval) =>
    busy = false

    @authenticate = (provider) =>
      return $q.reject 'in progress' if busy
      busy = true

      dfd = $q.defer()

      dfd.promise.finally ->
        busy = false

      child = $window.open "#{@config.host}/auth/#{provider}"

      $win = angular.element(window)

      # Listen for a cross window message from the given host
      $win.on 'message', handler = ({originalEvent}) =>
        {data, origin} = originalEvent
        return unless origin == @config.host
        $win.off 'message', handler
        dfd.resolve data

      # Detect when the window has closed without a response
      stop = $interval ->
        return unless child.closed
        $interval.cancel stop
        delete $window.OmniauthCallback
        dfd.reject 'no response'

      dfd.promise

    this

  this
