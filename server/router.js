/*
 * router.js
 * Copyright (C) 2014 sushil <sushil@zlemma.com>
 *
 * Distributed under terms of the MIT license.
 */
module.exports = function (server) {
  // serve index.html
  server.get('/', function (req, res, next) {
    res.render('index.html');
  });
};
