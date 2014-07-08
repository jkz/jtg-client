angular.module 'toast', []

.provider 'toast', ->
  serial = 0

  @config =
    duration: 3000
    templateUrl: 'common/toast/toast.html'
    autoExpose: false

  @$get = ($timeout) =>
    toast =
      config: @config
      toasts: []
      history: []

      create: (payload, {duration}={}) =>
        serial += 1
        duration ?= @config.duration
        timestamp = new Date().getTime()
        _toast = {serial, duration, timestamp, payload}
        console.log "CREATED", toast: _toast
        toast.toasts.push _toast

        # TODO this can remove the wrong toast if a long
        # is followed by a short one
        cancel = $timeout ->
          _toast.dismiss()
        , duration if duration

        _toast.dismiss = ->
          cancel?()
          toast.history.push toast.toasts.shift()

  this

.directive 'toast', (toast) ->
  restrict: 'E'
  templateUrl: toast.config.templateUrl
  # scope:
  #   toast: '='
  link: (scope, elem) ->
    console.log "<toast>", scope.toast

    scope.dismiss = ->
      elem.emit 'dismiss', scope.toast

.run ($rootScope, toast) ->
  $rootScope.toast = toast if toast.config.autoExpose