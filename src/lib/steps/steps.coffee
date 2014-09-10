angular.module 'steps', []

.directive 'steps', ->
  restrict: 'E'
  link: (scope, elem) ->
    steps = elem.find 'step'

    scope.steps = for step, index in elem.find 'step'
      index: index
      visible: false

    scope.steps[0].visible = true

    activeIndex = 0
    viewIndex = 0

    scope.prev

    scope.next = ->
      # TODO Somehow animate?
      viewIndex += 1
      activeIndex = Math.max activeIndex, viewIndex
      scope.steps[activeIndex].visible = true

    scope.prev = ->
      viewIndex = Math.max 0, viewIndex - 1
