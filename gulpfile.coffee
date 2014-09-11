fs   = require 'fs'
gulp = require 'gulp'
$    = do require 'gulp-load-plugins'
es   = require 'event-stream'
runSequence = require 'run-sequence'

browser = require 'browser-sync'

{argv}   = require 'yargs'

pkg = require './package'
ssh = require './secrets/ssh'
s3  = require './secrets/s3'

symlink = (src, dest) ->
  if fs.existsSync dest
    return unless fs.lstatSync(dest).isSymbolicLink()
    fs.unlinkSync dest
  fs.symlink src, dest

gulp.on 'error', (err) ->
  console.log err

gulp.task 'css', ->
  gulp.src 'src/css/app.styl'
    .pipe $.plumber()
    .pipe $.stylus()
    .pipe gulp.dest 'build'

gulp.task 'js', ->
  gulp.src ['src/**/*.js', '!src/**/*.spec.js']
    .pipe gulp.dest 'build'

  gulp.src ['src/**/*.coffee', '!src/**/*.spec.coffee']
    .pipe $.cached 'js'
    .pipe $.plumber()
    .pipe $.coffee()
    .pipe gulp.dest 'build'

gulp.task 'templates', ->
  gulp.src 'src/**/*.jade'
    .pipe $.plumber()
    .pipe $.jade()
    .pipe gulp.dest 'build'
    .pipe $.using color: 'cyan'
    .pipe $.angularTemplates module: pkg.name
    .pipe $.concat 'templates.js'
    .pipe gulp.dest 'build'

gulp.task 'vendor', ->
  $.bowerFiles()
    .pipe $.using color: 'cyan'
    .pipe $.cached 'vendor'
    .pipe gulp.dest 'build/vendor'

gulp.task 'static', ->
  gulp.src 'static/**/*'
    .pipe $.symlink 'build'

gulp.task 'index', ['vendor', 'css', 'js', 'templates'], ->
  gulp.src 'src/index.jade'
    .pipe $.jade pretty: true
    .pipe $.inject(
      gulp.src([
        # 'build/lib/jquery/*.{css,js}'
        # 'build/lib/angular/*.{css,js}'
        # 'build/lib/**/*.{css,js}'
        'build/**/module.js'
        'build/**/*.{css,js}'
        '!build/templates.js'
        '!build/vendor/**/*'
        '!build/env/**/*'
      ], read: false)
    , ignorePath: 'build')
    .pipe $.inject(
      gulp.src('build/templates.js', read: false),
      ignorePath: 'build'
      starttag: '<!-- inject:templates.js -->'
    )
    .pipe gulp.dest 'build'

gulp.task 'serve', ->
  browser
    files: ['./src/**/*']
    server:
      baseDir: ['public', 'static']
    injectChanges: true
    watchOptions:
      debounceDelay: 500
    ghostMode: false

gulp.task 'compile', ['index']

gulp.task 'build', ->
  runSequence 'clean', ['compile'], ->
    symlink 'build', 'public'

gulp.task 'watch', ['clean', 'build'], ->
  watcher = gulp.watch 'src/**/*', ['compile']
  watcher.setMaxListeners 50
  watcher

gulp.task 'clean', ->
  gulp.src [
    'build/**/*'
    'public'
  ]
    .pipe $.clean()

push = (env) ->
  s3 =
    conf: require('./secrets/s3.json')[env]
    options:
      gzippedOnly: true

  runSequence 'clean', 'build', ->
    gulp.src ['build/**/*'] #, 'static/**/*']
      .pipe $.gzip()
      .pipe $.s3 s3.conf, s3.options

gulp.task 'stage', ->
  push 'staging'

gulp.task 'deploy', ->
  push 'production'

gulp.task 'default', ['build', 'serve', 'watch']
