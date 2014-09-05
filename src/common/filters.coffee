angular.module 'filters', []

.filter 'capitalize', ->
  (input, all) ->
    return '' unless input
    input.replace /([^\W_]+[^\s-]*) */g, (txt) ->
      txt[0].toUpperCase() + txt.substr(1).toLowerCase()
