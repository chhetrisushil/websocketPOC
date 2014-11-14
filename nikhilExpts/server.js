var http = require('http');
var express = require('express'),
  app = module.exports.app = express();

var server = http.createServer(app);
var io = require('socket.io').listen(server);
server.listen(3000);

app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.set("view options", {
  layout: false
});
app.use(express.static(__dirname + '/public'));
app.get('/', function(req, res) {
  res.render('home.jade');
});

io.sockets.on('connection', function(socket) {
  socket.on('setPseudo', function(data) {
    socket.pseudo = data;
  });
  socket.on('message', function(message) {
    var data = {
      'message': message
    };
    socket.broadcast.emit('message', data);
    console.log("someone " + " sent this : " + message);
  });
});