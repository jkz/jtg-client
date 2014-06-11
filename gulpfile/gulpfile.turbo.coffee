fs       = require 'fs'
_        = require 'lodash'
gulp     = require 'gulp'
# $        = require('gulp-load-plugins') lazy: false
$        = do require 'gulp-load-plugins'

$.mem    = require './gulp_modules/gulp-mem'
mem      = require './gulp_modules/mem'

{argv}   = require 'yargs'
{spawn}  = require 'child_process'

{merge} = es = require 'event-stream'

lazycachepipe = require './gulp_modules/lazycachepipe'
multistream = require './gulp_modules/multistream'

# Gulp normally hides the stacktrace
gulp.on 'err', (e) ->
  console.log e.err.stack

#
# Configuration
#
pkg       = JSON.parse fs.readFileSync './package.json'
# header    = fs.readFileSync './LICENSE.js'
karmaConf = 'karma.conf.js'
aws       =
  conf: JSON.parse fs.readFileSync './s3.json'
  options:
    gzippedOnly: true
    headers:
      'Cache-Control': "max-age=#{60 * 60 * 24 * 365 * 10}, no-transform, public"


globs =
  js:
    js: '**/*.js'
    coffee: '**/*.coffee'
  css:
    css: '**/*.css'
    stylus: '**/*.styl'
    sass: '**/*.sass'
    less: '**/*.less'
  html:
    html: '**/*.html'
    jade: '**/*.jade'
    templates: ['**/*.html', '!**/index.html']
  img: '**/*.(jpg|jpeg|png|gif|svg)'
  index: 'src/index.jade'

  src: 'src/**/*'
  lib: 'lib/**/*'
  static: 'static/**/*'
  test: ['test/**/*', 'src/**/**.spec.*']

globs.in = _.flatten [
    globs.src
    globs.lib
    globs.static
  ]

paths =
  dist: 'dist'
  build: 'public'


compile =
  jade:
    lazycachepipe 'jade:compile'
      .pipe $.filter, globs.html.jade
      .pipe $.jade
  stylus:
    lazycachepipe 'stylus:compile'
      .pipe $.filter, globs.css.stylus
      .pipe $.stylus
  # less:
  #   lazycachepipe 'less:compile'
  #     .pipe $.filter globs.css.less
  #     .pipe $.less()
  # sass:
  #   lazycachepipe 'sass:compile'
  #     .pipe $.filter globs.css.sass
  #     .pipe $.sass()
  coffee:
    lazycachepipe 'coffee:compile'
      .pipe $.filter, globs.js.coffee
      .pipe $.coffee
      # TODO sourcemap
  img:
    lazycachepipe 'img:compile'
      .pipe $.filter, globs.img
  templates:
    lazycachepipe 'templates:compile'
      .pipe $.filter, globs.html.templates
      # .pipe $.angularTemplates, "templates.js"

compile.html = multistream [
  # $.filter globs.html.html
  compile.jade
]

compile.css = multistream [
  # $.filter globs.css.css
  compile.stylus
  # compile.sass
  # compile.less
]

compile.js = multistream [
  # $.filter globs.js.js
  compile.coffee
]

compress =
  js: (name) ->
    lazycachepipe 'js:compress'
      .pipe $.filter, globs.js.js
      .pipe $.uglify
      .pipe $.concat, "#{name}.js"
      .pipe $.rev
  css: (name) ->
    lazycachepipe 'css:compress'
      .pipe $.filter, globs.css.css
      .pipe $.minifyCss
      .pipe $.concat, "#{name}.css"
      .pipe $.rev
  html:
    lazycachepipe 'html:compress'
      .pipe $.filter, globs.html.html
      .pipe $.minifyHtml, quotes: true
  templates: (name) ->
    lazycachepipe 'templates:compress'
      .pipe $.filter globs.html.templates
      .pipe compress.html
      .pipe $.angularTemplates, "templates.js"
      .pipe compress.js name
  img:
    lazycachepipe 'img:compress'
      .pipe $.filter, globs.img
      .pipe $.imagemin, optimizationLevel: 5
      # TODO add revision tags and reflect them in css files
  sprite: (name) ->
    # TODO
    # - replace occurences in css files
    # - build a sprite from all images in the stream
    lazycachepipe 'sprite:compress'
      .pipe $.filter, "#{name}.sprite.png"
      .pipe compress.img
      .pipe $.sprite name

pipes =
  compile: multistream [
    compile.js
    compile.css
    compile.html
  ]
  compress: (name) ->
    multistream [
      compress.img name
      compress.js name
      compress.css name
      compress.html
    ]

$.mem.task 'app:compile', ->
  gulp.src globs.src
    .pipe $.cached 'app:compile'
    .pipe $.using prefix: 'app:compile', color: 'red'
    .pipe pipes.compile()
    .pipe $.using prefix: 'app:compile', color: 'yellow'

$.mem.task 'lib:compile', ->
  $.bowerFiles()
    .pipe $.cached 'lib:compile'
    .pipe $.using prefix: 'lib:compile', color: 'red'
    .pipe pipes.compile()
    .pipe $.using prefix: 'lib:compile', color: 'yellow'

$.mem.task 'static:compile', ->
  console.log 'static:compile not implemented'
  # Symlink static folder

$.mem.task 'index:compile', ['app:compile', 'lib:compile'], ->
  gulp.src globs.index
    .pipe $.using color: 'yellow'
    .pipe compile.html()
    .pipe $.inject merge [
      mem.src 'app:compile'
      mem.src 'lib:compile'
    ]...

$.mem.sync 'compile', ['app:compile', 'lib:compile', 'index:compile'], ->
  merge [
    mem.src 'app:compile'
      .pipe $.using color: 'pink'
    mem.src 'lib:compile'
      .pipe $.using color: 'pink'
    # mem.src 'static:compile'
    mem.src 'index:compile'
      .pipe $.using color: 'pink'
  ]...

$.mem.task 'app:compress', ->
  pipes.compress ->
    mem.src 'app:compile'

$.mem.task 'lib:compress', ->
  pipes.compress ->
    mem.src 'lib:compile'

$.mem.task 'index:compress', ['app:compress', 'lib:compress'], ->
  mem.src 'index'
    .pipe $.inject merge [
      mem.src 'app:compress'
      mem.src 'lib:compress'
    ]...

$.mem.sync 'compress', ['compile', 'app:compress', 'lib:compress', 'index:compress'], ->
  merge [
    mem.src 'app:compress'
    mem.src 'lib:compress'
    # mem.src 'static:compress'
    mem.src 'index:compress'
  ]...

gulp.task 'build', ['compile'], ->
  mem.src 'compile'
    .pipe $.using prefix: 'build', color: 'green'
    .pipe gulp.dest paths.build,
      ignorePath: paths.src
    .pipe $.connect.reload()

gulp.task 'dist', ['compress'], ->
  mem.src 'compress'
    .pipe paths.dist

gulp.task 'deploy', ['compress', 'test'], ->
  mem.src 'compress'
    .pipe $.gzip()
    .pipe $.s3 aws.conf, aws.options

# $.mem.task 'deploy:stage'
# $.mem.task 'deploy:production'

gulp.task 'test', ['build'], ->
  gulp.src globs.test
    .pipe $.karma
      configFile: karmaConf
      action: 'run'
    .on 'error', (err) ->
      throw err

gulp.task 'serve', ->
  $.connect.server
    root: paths.build
    livereload: true

  process.on 'exit', ->
    $.connect.serverClose()
    process.exit 1

gulp.task 'watch', ->
  # TODO build only changed files
  gulp.watch globs.in, ['build', 'test'], (event) ->
    console.log 'watch', event
  # Watch all cachable files, remove a file from all caches on delete
  .on 'change', (event) ->
    console.log ":D:D"
    # console.log 'cache.caches', cache.caches
    # console.log 'remember.caches', remember.caches
    if event.type == 'deleted'
      cache.forget event.path
      remember.forget event.path

  gulp.src globs.test
    .pipe $.karma
      configFile: karmaConf
      action: 'watch'

gulp.task 'auto-reload', ->
  p = null
  spawnChildren = (e) ->
    # kill previous spawned process
    p?.kill()
    # Wait for the child process to clean up
    setTimeout ->
      # `spawn` a child `gulp` process linked to the parent `stdio`
      console.log 'Reloading', [argv.task]
      p = spawn 'gulp', [argv.task], stdio: 'inherit'
    , 0

  gulp.watch __filename, spawnChildren
  spawnChildren()


gulp.task 'default', ['build', 'serve', 'watch']
