# TODO
# - log level critical to emit to socket or post
angular.module 'log', []

# TODO
# - colors
.service 'colors', ->
  colors = {}
  for color in ['gray', 'yellow', 'red', 'red']
    do (color) ->
      colors[color] = (s) -> "#{color.toUpperCase()}: #{s}"
  colors

.service 'log', (colors) ->
  log =
    levels:
      info: 'gray'
      warn: 'yellow'
      error: 'red'
      critical: 'red'

    logger: (level) ->
      (args...) ->
        console.log level.toUpperCase(), (colors[log.levels[level]] arg for arg in args)...

  for level of log.levels
    log[level] = log.logger level

  log
