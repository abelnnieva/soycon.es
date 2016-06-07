"use strict"

gulp      = require "gulp"
coffee    = require "gulp-coffee"
concat    = require "gulp-concat"
sync      = require "browser-sync"
header    = require "gulp-header"
gutil     = require "gulp-util"
sass      = require "gulp-sass"
scomment  = require "gulp-strip-css-comments"
uglify    = require "gulp-uglify"
pkg       = require "./package.json"
cp        = require "child_process"
cleanCSS  = require "gulp-clean-css"

messages = jekyllBuild: "<span style='color: grey'>Running:</span> $ jekyll build"

source =
  coffee: [ "./_coffee/app.coffee"
            "./_coffee/app.*.coffee" ]
  sass  :
    watch : [ "./_sass/_*.scss" ]
    dist  : [ "./_sass/site.scss" ]
  html  : [ "./*.html", "./_includes/*.html", "./_layouts/*.html" ]
  dest  : "./assets"

thirds =
  js    : [ "bower_components/jquery/dist/jquery.js",
            "bower_components/flexslider/jquery.flexslider.js"]
  css   : [ "bower_components/flexslider/flexslider.css"]
  fonts : []


banner = [
  "/**"
  " * <%= pkg.name %> - <%= pkg.description %>"
  " * @version v<%= pkg.version %>"
  " * @link    <%= pkg.homepage %>"
  " * @author  <%= pkg.author.name %> <<%= pkg.author.email %>>"
  " * @license <%= pkg.license %>"
  " */"
  ""
].join("\n")

# Build the Jekyll Site
gulp.task "jekyll-build", (done) ->
  sync.notify messages.jekyllBuild
  cp.spawn("jekyll", [ "build" ], stdio: "inherit").on "close", done

# Rebuild Jekyll & do page reload
gulp.task "jekyll-rebuild", [ "jekyll-build" ], ->
  sync.reload()
  return

# browser-sync task for starting the server.
gulp.task "browser-sync", [ "jekyll-build" ], ->
  sync
    server:
      baseDir: "./_site"

gulp.task "thirds", ->
  gulp.src thirds.js
    .pipe concat "#{pkg.name}.thirds.js"
    .pipe uglify mangle: true
    .pipe gulp.dest "#{source.dest}/js"
    .pipe sync.reload stream: true

  gulp.src thirds.css
    .pipe concat "#{pkg.name}.thirds.css"
    .pipe cleanCSS()
    .pipe gulp.dest "#{source.dest}/css"
    .pipe sync.reload stream: true

gulp.task "coffee", ->
  gulp.src source.coffee
    .pipe concat "#{pkg.name}.coffee"
    .pipe coffee().on "error", gutil.log
    .pipe uglify mangle: false
    .pipe header banner, pkg: pkg
    .pipe gulp.dest "#{source.dest}/js"
    .pipe sync.reload stream: true

gulp.task "sass", ->
  gulp.src source.sass.dist
    .pipe concat "#{pkg.name}.scss"
    .pipe sass outputStyle: "compressed"
    .pipe scomment all: true
    .pipe header banner, pkg: pkg
    .pipe gulp.dest "#{source.dest}/css"
    .pipe sync.reload stream: true

gulp.task "html", ->
  gulp.src source.html
    .pipe sync.reload stream: true

gulp.task "init", [ "thirds", "coffee", "sass" ]

gulp.task "watch", ->
  gulp.watch source.coffee, [ "coffee", "jekyll-rebuild" ]
  gulp.watch source.sass.watch, [ "sass", "jekyll-rebuild" ]
  gulp.watch source.sass.dist, [ "sass", "jekyll-rebuild" ]
  gulp.watch source.html, [ "html", "jekyll-rebuild" ]
  gulp.run [ "browser-sync" ]

gulp.task "default", [ "watch", "thirds", "coffee", "sass", "browser-sync" ]
