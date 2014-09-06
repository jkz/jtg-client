angular.module 'jtg'

# This polymorphic story directive expects a `story` object on the scope
# It fetches the right template by provider and model and
# passes the payload in as `scope[story.model]`
.directive 'story', ($compile, $templateCache) ->
  restrict: 'E'
  link: (scope, elem) ->
    # scope.story
    #   .getPayload()
    #   .then (payload) ->
    #     scope[scope.story.model] = payload
    #     template = $templateCache.get "app/feed/#{scope.story.namespace}/#{scope.story.model}.html"
    #     elem.html template
    #     $compile(elem.contents())(scope)
    update = (story) ->
      return unless story
      {provider, model, data} = story
      scope[model] = data
      templateUrl = "/app/stories/#{provider}/#{model}.html"
      template = $templateCache.get templateUrl
      console.log {templateUrl, template}
      elem.html template
      $compile(elem.contents())(scope)

    scope.$watch 'story', update
    update scope.story


.controller 'StoryCtrl', ($scope, feeds) ->
  $scope.stories = feeds('social').entries
