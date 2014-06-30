# A node style EventEmitter class
angular.module 'events', []

# A general purpose events bus
.service 'emitter', (EventEmitter) ->
  new EventEmitter

# For now the EventEmitter base class should not be altered.
# It is the product of an angular factory, to have it create a
# fresh scope every time without requiring a super() call in
# it's descendants.
.factory 'EventEmitter', ($rootScope) ->
  class EventEmitter
    @scope: $rootScope.$new()

    @on: (event, callback) =>
      @scope.$on event, callback

    @emit: (event, data) =>
      @scope.$emit event, data

    @once: (event, callback) =>
      remove = @scope.$on event, (data) =>
        remove()
        callback data
