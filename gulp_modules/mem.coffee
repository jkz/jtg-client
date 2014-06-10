es = require 'event-stream'
caches = {}

module.exports =
  src: (name) ->
    cache = caches[name] || {}
    values = (val for key, val of cache)
    es.readArray values
  dest: (name) ->
    es.mapSync (file) ->
      caches[name] ||= {}
      caches[name][file.path] = file
