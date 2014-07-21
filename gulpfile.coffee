fs   = require 'fs'
gulp = require 'gulp'
$    = do require 'gulp-load-plugins'
es   = require 'event-stream'
runSequence = require 'run-sequence'

{argv}   = require 'yargs'

pkg = JSON.parse fs.readFileSync './package.json'
ssh = JSON.parse fs.readFileSync './secrets/ssh.json'

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
    .pipe $.connect.reload()

gulp.task 'js', ->
  gulp.src ['src/**/*.js', '!src/**/*.spec.js']
    .pipe gulp.dest 'build'
    .pipe $.connect.reload()

  gulp.src ['src/**/*.coffee', '!src/**/*.spec.coffee']
    .pipe $.cached 'js'
    .pipe $.plumber()
    .pipe $.coffee()
    .pipe gulp.dest 'build'
    .pipe $.connect.reload()

gulp.task 'templates', ->
  gulp.src 'src/**/*.jade'
    .pipe $.plumber()
    .pipe $.jade()
    .pipe gulp.dest 'build'
    .pipe $.using color: 'cyan'
    .pipe $.angularTemplates module: pkg.name
    .pipe $.concat 'templates.js'
    .pipe gulp.dest 'build'
    .pipe $.connect.reload()

gulp.task 'lib', ->
  $.bowerFiles()
    .pipe $.using color: 'cyan'
    .pipe $.cached 'lib'
    .pipe gulp.dest 'build/lib'

gulp.task 'static', ->
  gulp.src 'static/**/*'
    .pipe $.symlink 'build'

gulp.task 'index', ['lib', 'css', 'js', 'templates'], ->
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
        '!build/lib/**/*'
      ], read: false)
    , ignorePath: 'build')
    .pipe $.inject(
      gulp.src('build/templates.js', read: false),
      ignorePath: 'build'
      starttag: '<!-- inject:templates.js -->'
    )
    .pipe gulp.dest 'build'

gulp.task 'serve', ->
  $.connect.server
    port: argv.port || 8000
    root: ['public', 'static']
    livereload: true

gulp.task 'compile', ['index']

gulp.task 'build', ->
  runSequence 'clean', ['compile'], ->
    symlink 'build', 'public'

gulp.task 'watch', ['clean', 'build'], ->
  watcher = gulp.watch 'src/**/*', ['compile']
  watcher.setMaxListeners 50
  watcher

gulp.task 'deploy', ->
  s3 =
    conf: require './secrets/s3.json'
    options:
      gzippedOnly: true
      #headers: 'Cache-Control': "max-age=#{60 * 60 * 24 * 365 * 10}, no-transform, public"
  gulp.src ['build/**/*'] #, 'static/**/*']
    .pipe $.gzip()
    .pipe $.s3 s3.conf, s3.options


gulp.task 'clean', ->
  gulp.src [
    'build/**/*'
    'public'
  ]
    .pipe $.clean()

gulp.task 'default', ['build', 'serve', 'watch']
