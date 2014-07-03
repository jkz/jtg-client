# Promise based concurrency decorators
# Any function that returns an angular promise
# can be wrapped by either of these factories
#
# *Functions wrapped by these decorators lose their properties*
#
# TODO
# - make providers for configuration
# - add debounce modes
angular.module 'concurrency', []

# ## Wrap
# ---
# Wrap a function with a decorator and carry over properties
# to the result. Sadly any changes after the wrap are not carried.
# Which makes this unreliable if not unusable.
.factory 'wrap', ->
  (decorator, func) ->
    wrapped = decorator func
    wrapped[key] = val for key, val of func
    wrapped

# ## Throttle
# ---
# Set a maximum number of executions within a timeframe
.factory 'throttle', ($q) ->
  count = 0
  max = 1

  (options, func) ->
    if not func?
      func = options
      options = {}

    max = options.max ? max
    # options.interval ?=

    (args...) ->
      return $q.reject "Throttled" if count >= max
      count += 1
      func.apply(this, args).finally ->
        count -= 1


# ## Mutex
# ---
# A factory factory. Return a decorator that groups the
# functions it wraps and makes sure only one of them can be executed at a time.
# Both the mutex and the decorated function expose the status as `status`
# This is only indicative, as the actual semaphore is not accessible for safety.
.factory 'mutex', ($q) ->
  (reason="Mutex locked") ->
    semaphore = off

    mutex = (func) ->
      wrap = (args...) ->
        $q.reject reason if semaphore
        wrap.locked = mutex.locked = semaphore = on
        func.apply(this, args).finally ->
          wrap.locked = mutex.locked = semaphore = off
      wrap.locked = mutex.locked = semaphore
      wrap

# ## Lock
# ---
# A special case mutex for a single function
.factory 'lock', (mutex) ->
  (reason, func) ->
    if not func?
      func ?= reason
      reason = "Locked"

    mutex(reason) func
