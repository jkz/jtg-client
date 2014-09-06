angular.module 'jtg'

.directive 'facebookLike', ->
  restrict: 'E'
  templateUrl: 'app/feed/facebook/like.html'

.directive 'facebookPost', ->
  restrict: 'E'
  templateUrl: 'app/feed/facebook/post.html'
