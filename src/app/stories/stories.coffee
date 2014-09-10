angular.module 'jtg'

# This polymorphic story directive expects a `story` object on the scope
# It fetches the right template by provider and model and
# passes the payload in as `scope[story.model]`
.directive 'story', ($compile, $templateCache) ->
  restrict: 'E'
  link: (scope, elem) ->
    update = ({provider, model, data}={}) ->
      return unless provider and model and data
      scope[model] = data
      templateUrl = "/app/stories/#{provider}/#{model}.html"
      template = $templateCache.get templateUrl
      elem.html template
      $compile(elem.contents())(scope)

    scope.$watch 'story', update
    update scope.story

.controller 'StoryCtrl', ($scope, feeds) ->
  $scope.stories = feeds('/stories/hosts/jessethegame/all').entries
