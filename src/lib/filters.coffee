angular.module 'filters', []

.filter 'capitalize', ->
  (input, all) ->
    return '' unless input
    input.replace /([^\W_]+[^\s-]*) */g, (txt) ->
      txt[0].toUpperCase() + txt.substr(1).toLowerCase()

.filter 'orderObjectBy', ->
  (items, field, reverse) ->
    filtered = (item for _, item of items)
    filtered.sort (a, b) -> if a[field] > b[field] then 1 else -1
    filtered.reverse() if reverse
    filtered
