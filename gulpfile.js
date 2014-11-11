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
    gutil = require('gulp-util'),
    livereload = require('gulp-livereload');

function swallowerror(error) {
  console.log(error);
  this.emit('end');
}

//lint task
gulp.task('lint', function () {
  return gulp.src('client/static/js/**/*.js')
          .pipe(jshint())
          .on('error', swallowerror)
          .pipe(jshint.reporter('default'))
          .on('error', swallowerror);
});

//compile our less files
gulp.task('less', function () {
  return gulp.src('client/static/less/style.less')
          // .pipe(plumber())
          .pipe(less())
          .on('error', swallowerror)
          .pipe(gulp.dest('client/static/dist/css'))
          .pipe(livereload(4000));
});

//compile our coffee files
gulp.task('coffee', function () {
  return gulp.src('client/static/coffee/**/*.coffee')
          // .pipe(plumber())
          .pipe(coffee())
          .on('error', swallowerror)
          .pipe(gulp.dest('client/static/dist/js'));
});

//copy libs to dest
gulp.task('libs-copy', function () {
  gulp.src('client/static/lib/**/*.js')
    .pipe(gulp.dest('client/static/dist/js'));

  return gulp.src('client/static/lib/**/*.css')
    .pipe(gulp.dest('client/static/dist/css'));
});

//watch files for changes
gulp.task('watch', function () {
  gulp.watch('client/static/coffee/**/*.coffee', ['coffee']);
  gulp.watch('client/static/less/**/*.less', ['less']);
});

//default task
gulp.task('default', ['lint', 'less', 'coffee', 'libs-copy','watch']);
