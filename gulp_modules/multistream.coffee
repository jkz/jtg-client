es = require 'event-stream'
through = require 'through2'
{noop} = require 'gulp-util'

# Pass in an array of writeable streams
module.exports = (streams) ->
  ->
    writables = ((if typeof w == 'function' then w() else w) for w in streams)
    read = es.merge writables...

    write = through.obj (file, enc, callback) ->
      for stream in writables
        stream.write file
      callback()
    , ->
      for stream in writables
        stream.end()

    es.duplex write, read
