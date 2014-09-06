angular.module 'jtg'

.directive 'chat', (feeds, session, $timeout) ->
  restrict: 'E'
  templateUrl: "app/chat/chat.html"
  link: (scope, elem) ->
    {entries, socket} = feeds 'chat'

    scope.session = session
    scope.messages = entries

    scope.broadcast = (msg) ->
      socket.emit 'chat', msg if msg
