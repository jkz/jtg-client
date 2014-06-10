lazypipe = require 'lazypipe'
cached   = require 'gulp-cached'
using    = require 'gulp-using'

DEFAULT_NAME = '_default'

# Pass in an array of writeable streams
module.exports = (name=DEFAULT_NAME) ->
  lazypipe()
    .pipe cached, name
    .pipe using, prefix: 'lazycachepipe', color: 'gray'
