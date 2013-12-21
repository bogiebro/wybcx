// Module dependencies
var express = require('express');
var http = require('http');
var path = require('path');
var io = require('socket.io');
var app = express();
var fs = require('fs');
var model = require('./model/model');
app.use(require('connect-assets')());

// Handler dependencies
var sockets = require('./sockets')

// Set up express
app.set('port', process.env.PORT || 3000);
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.use(express.logger('dev'));
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(express.cookieParser('your secret here'));
app.use(express.session());
app.use(app.router);
app.use(express.static(path.join(__dirname, 'build')));

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler())
};

// html responses
app.get('/', function(req, res) {
	res.redirect('/listener/index.html');
});

app.post('/upload', function(req, res) {
  fs.createReadStream(req.files.file.path).pipe(fs.createWriteStream('build/showpics/' + req.files.file.name));
  res.write('ok');
});

// socketio responses
var server = http.createServer(app);
var ioapp = io.listen(server);
ioapp.sockets.on('connection', sockets.connect);

// start the server
server.listen(app.get('port'), function() {
  console.log('Express server listening on port ' + app.get('port'))});
