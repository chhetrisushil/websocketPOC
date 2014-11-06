var application_root = __dirname,
    express = require('express'),
    bodyParser = require('body-parser'),
    methodOverride = require('method-override'),
    errorHandler = require('express-error-handler'),
    ejs = require('ejs'),
    path = require('path'),
    server = express();

server.use(bodyParser());
server.use(methodOverride());
server.use(errorHandler({ dumpExceptions: true, showStack: true }));
server.use(express.static('client/static/'));
server.set('views', path.join(application_root, '..', '/client'));
server.engine('html', ejs.renderFile);

// serve index.html
server.get('/', function (req, res, next) {
      res.render('index.html'); 
});

server.listen(3001);
