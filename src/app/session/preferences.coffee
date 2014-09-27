# This module stores all information specific to
# a client machine.
#
# This probably belongs in the session module

deepExtend = (dst, srcs...) ->
  for src in srcs
    for key, val of src
      if dst[key]?.constructor == Object
        deepExtend dst[key], val
      else
        dst[key] = val

  dst

angular.module 'jtg.session'

.value 'deepExtend', deepExtend

.service 'preferences', ($localStorage, deepExtend) ->
  prefs =
    key: 'anonymous'
    defaults:
      fontSize: 16

      tutorial: on
      toasts: on

      rocket:
        all: on
        challenges: on
        boosts: on
        users: on

      minimap:
        widget: on
        broadcast: on

      chat: on
    load: (key='anonymous') ->
      prefs.key = key
      # Special case for anonymous users
      $localStorage[key] ?= deepExtend {}, prefs.defaults, $localStorage.anonymous
    reload: ->
      storage = prefs.load(prefs.key)
      console.log prefs.key, {storage}
      storage

.run (preferences, session) ->
  session.preferences = preferences.load()

  session.emitter.on 'connect', (user) ->
    session.preferences = preferences.load(user.id)

  session.emitter.on 'misconnect', ->
    session.preferences = preferences.load()

  session.emitter.on 'disconnect', ->
    session.preferences = preferences.load()

# This propagates preference changes to other windows.
.run ($window, $rootScope, preferences, session) ->
  angular.element($window).on 'storage', (event) ->
    event = event.originalEvent if event.originalEvent
    if event.key == 'ngStorage-' + preferences.key
      session.preferences = preferences.reload()
      $rootScope.$apply()
