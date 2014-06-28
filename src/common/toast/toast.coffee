angular.module 'toast', []

.provider 'toast', ($timeout) ->
  @config =
    duration: 3000
    templateUrl: 'common/toast/toast.html'

  @$get = =>
    toast =
      toasts = []

    create: (payload, {duration}={}) =>
      duration ?= @config.duration
      timestamp = new Date().getTime()
      toast.toasts.push {timestamp, payload}

      # TODO this can remove the wrong toast if a long
      # is followed by a short one
      $timeout (-> toasts.shift()), duration if duration

  @

.directive 'toast', (toast) ->
  restrict: 'E'
  template: toast.templateUrl

.run ($rootScope, toast) ->
  $rootScope.toasts = toast.toasts