###
angular.module 'jtg.feed', []

.directive 'socialFeed', (socket) ->
  restrict: 'E'
  scope:
    stories: '='
  link: (scope) ->
    null
###
