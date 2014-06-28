# TODO
# - log level critical to emit to socket or post
# - colors
angular.module 'log', []

.service 'log', (colors) ->
  log =
    levels:
      info: 'gray'
      warn: 'yellow'
      error: 'red'
      critical: 'red'

    logger: (level) ->
      (args...) ->
        console.log level.toUpperCase(), (colors[levels[level]] arg for arg in args)...

  for level of levels
    log[level] = log.logger level

  log
