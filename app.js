// Module dependencies
var express = require('express');
var handlers = require('./handlers');
var http = require('http');
var path = require('path');
var app = express();
app.use(require('connect-assets')());


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
app.get('/', handlers.index);
app.get('/dj', handlers.dj);
app.get('/partials/:name', handlers.partials);

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
