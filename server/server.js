var application_root = __dirname,
  express = require('express'),
  bodyParser = require('body-parser'),
  methodOverride = require('method-override'),
  errorHandler = require('express-error-handler'),
  ejs = require('ejs'),
  path = require('path'),
  router = require('./router.js'),
  server = express();

server.use(bodyParser());
server.use(methodOverride());
server.use(errorHandler({
  dumpExceptions: true,
  showStack: true
}));
server.use(express.static('client/static/'));
server.set('views', path.join(application_root, '..', '/client'));
server.engine('html', ejs.renderFile);

// register routes to server
router(server);

server.listen(3001);