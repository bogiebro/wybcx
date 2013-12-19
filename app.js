// Module dependencies
var express = require('express');
var http = require('http');
var path = require('path');
var io = require('socket.io');
var app = express();
app.use(require('connect-assets')());

// Handler dependencies
var listener = require('./handlers/listener');
var upload = require('./handlers/upload');
var dj = require('./handlers/dj');
var admin = require('./handlers/admin');
var json = require('./json');
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
app.use(express.static(path.join(__dirname, 'public')));
app.use('/bower_components', express.static(path.join(__dirname, 'bower_components')));

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler())
};

// html responses
app.get('/', listener.index);
app.get('/listener/partials/:name', listener.partials);
app.get('/dj', dj.dash);
app.get('/onair', dj.onair);
app.get('/blog', dj.blog);
app.get('/prog', admin.prog);
app.post('/upload', upload.upload);

// socketio responses
var server = http.createServer(app);
var ioapp = io.listen(server);
// ioapp.configure(function() {
//  ioapp.set('log level', '1');
// });
ioapp.sockets.on('connection', sockets.connect);

// start the server
server.listen(app.get('port'), function() {
  console.log('Express server listening on port ' + app.get('port'))});
