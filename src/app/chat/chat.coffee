angular.module 'jtg'

.directive 'chat', (feeds, session, $timeout, $interval) ->
  restrict: 'E'
  templateUrl: "app/chat/chat.html"
  link: (scope, elem) ->
    {entries, socket} = feeds 'chat'

    scope.session = session
    scope.messages = entries

    scope.broadcast = (msg) ->
      socket.emit 'chat', msg if msg

    scope.readCount = 0

    scope.markRead = ->
      scope.readCount = scope.messages.length


    scope.$watch 'expanded', ->
      scope.markRead() if scope.expanded

    scope.$watch 'messages.length', ->
      scope.markRead() if scope.expanded
