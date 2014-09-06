angular.module 'jtg'

# Story
# ---
# Stories are nuggets of content identified
# by a `namespace`, a `model` and a `uid`.
# It might not initially have its `payload`.
.factory 'Story', (jtg, resolve) ->
  Story = jtg.model 'stories', 'story'

  Story::init = ->
    @path = "/#{namespace}/#{model}/#{uid}"
    @deeplink = "/#" + @path

  # Get the actual content data for the story
  # It returns any present `payload` immediately.
  # You can force a server request by passing `force: true`
  Story::getPayload = ({force}={}) ->
    return resolve @payload if @payload and not force

    jtg
      .get @path
      .then (data) ->
        @data = data

  Story

# This polymorphic story directive expects a `story` object on the scope
# It fetches the right template by namespace and model and
# passes the payload in as `scope[story.model]`
.directive 'story', ($compile, $templateCache, Story) ->
  restrict: 'E'
  link: (scope, elem) ->
    scope.story
      .getPayload()
      .then (payload) ->
        scope[scope.story.model] = payload
        template = $templateCache.get "app/feed/#{scope.story.namespace}/#{scope.story.model}.html"
        elem.html template
        $compile(elem.contents())(scope)

.controller 'StoryCtrl', ($scope, Story) ->
  $scope.stories = Story.cache
  Story.index()

.directive 'socialFeed', ->
  restrict: 'E'
  scope:
    stories: '='
  templateUrl: "app/feed/feed.html"

