gulp = require 'gulp'
mem = require './mem'

module.exports = sip =
  # A task that pipes its output to memory to make it
  # readable without using disk
  task: (name, dependencies, cb=(->), async=true) ->
    if typeof dependencies == 'function'
      cb = dependencies
      dependencies = []

    gulp.task name, dependencies, (callback) ->
      stream = cb()
        .pipe mem.dest name

      if async
        stream
      else
        stream.on 'end', callback
        return

  sync: (name, dependencies, cb) ->
    sip.task name, dependencies, cb, false

  async: (name, dependencies, cb) ->
    sip.task name, dependencies, cb, true