/*
 * gulpfile.js
 * Copyright (C) 2014 sushil <sushil@zlemma.com>
 *
 * Distributed under terms of the MIT license.
 */
var gulp = require('gulp'),
    jshint = require('gulp-jshint'),
    less = require('gulp-less'),
    concat = require('gulp-concat'),
    uglify = require('gulp-uglify'),
    rename = require('gulp-rename'),
    coffee = require('gulp-coffee'),
    // plumber = require('gulp-plumber'),
    gutil = require('gulp-util');

function shwallowerror(error) {
  console.log(error);
  this.emit('end');
}

//lint task
gulp.task('lint', function () {
  return gulp.src('client/static/js/*.js')
          .pipe(jshint())
          .pipe(jshint.reporter('default'));
});

//compile our less files
gulp.task('less', function () {
  return gulp.src('client/static/less/style.less')
          // .pipe(plumber())
          .pipe(less())
          .on('error', shwallowerror)
          .pipe(gulp.dest('client/static/dist/css'));
});

//compile our coffee files
gulp.task('coffee', function () {
  return gulp.src('client/static/coffee/*.coffee')
          // .pipe(plumber())
          .pipe(coffee())
          .on('error', shwallowerror)
          .pipe(gulp.dest('client/static/dist/js'));
});

//watch files for changes
gulp.task('watch', function () {
  gulp.watch('client/static/coffee/*.coffee', ['coffee']);
  gulp.watch('client/static/less/*.less', ['less']);
});

//default task
gulp.task('default', ['lint', 'less', 'coffee', 'watch']);
