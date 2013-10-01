// Module dependencies
var express = require('express');
var http = require('http');
var path = require('path');
var app = express();
app.use(require('connect-assets')());

// Handler dependencies
var listener = require('./handlers/listener');
var dj = require('./handlers/dj');
var admin = require('./handlers/admin');
var json = require('./json');

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

// handle deployment
process.on('message', function(message) {
 if (message === 'shutdown') {
   process.exit(0);
 }
});

// start the server
http.createServer(app).listen(app.get('port'), function() {
  if (process.send) process.send('online');
  console.log('Express server listening on port ' + app.get('port'))});
