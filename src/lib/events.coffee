# A node style EventEmitter class
angular.module 'events', []

# A general purpose events bus
.service 'emitter', (EventEmitter) ->
  new EventEmitter

# For now the EventEmitter base class should not be altered.
# It is the product of an angular factory, to have it create a
# fresh scope every time without requiring a super() call in
# it's descendants.
# ---
# Hold up, this is actually not true,
.factory 'EventEmitter', ($rootScope) ->
  class EventEmitter
    constructor: ->
      @scope = $rootScope.$new()

    on: (name, callback) =>
      @scope.$on name, (event, data) ->
        # Swap the argument order to provide data as the first.
        callback data, event

    emit: (name, data) =>
      @scope.$emit name, data

    once: (name, callback) =>
      remove = @scope.$on name, (event, data) =>
        remove()
        callback data, event
