angular.module 'directives', []

.directive 'watchTop', ->
  restrict: 'A'
  scope:
    target: '=watchTop'
    transition: '='
  link: (scope, elem) ->
    scope.$watch 'target', ->
      elem.animate(scrollTop: 0, scope.transition)
    , true

.directive 'watchBottom', ->
  restrict: 'A'
  scope:
    target: '=watchBottom'
    transition: '='
  link: (scope, elem) ->
    scope.$watch 'target', ->
      elem.animate(scrollTop: elem[0].scrollHeight, scope.transition)
    , true

