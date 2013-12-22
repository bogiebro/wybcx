# external dependencies
express = require('express')
http = require('http')
path = require('path')
io = require('socket.io')
app = express()
passport = require('passport')

# my dependencies
sockets = require('./sockets')

# setup passport
# passport.use(new LocalStrategy(
#   (username, password, done)->
#     # done(null, user)
#     # done(null, false) if there's no user
#     # or done(error)
#   ))

# Set up express
app.use(require('connect-assets')())
app.set('port', process.env.PORT || 3000)
app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
app.use(express.logger('dev'))
app.use(express.bodyParser())
app.use(express.methodOverride())
app.use(express.cookieParser('your secret here'))
app.use(express.session())
app.use(app.router)
app.use(express.static(path.join(__dirname, 'build')))
app.use(passport.initialize())
app.use(passport.session())

# development only
app.use(express.errorHandler()) if 'development' == app.get('env')

# auth stuff
# admin and dj pages go through here first
# we show a login page or set a cookie
# to get any user sensative info, javascript just asks. cookie is already there
# server can check with req.isAuthenticated()

/*
passport.serializeUser(function(user, done) {
  done(null, user.id);
});

passport.deserializeUser(function(id, done) {
  User.findById(id, function (err, user) {
    done(err, user);
  });
});

app.post('/login',  function(req, res, next) {
  passport.authenticate('local',
    function(err, user, info) {
        if (err) { return next(err) }
        if (!user) { return res.json(false) }
        return res.json(true);
    })(req, res, next)
});
*/

# html responses
app.get('/', (req, res)-> res.redirect('/listener/index.html'))
app.post('/upload', (req, res)-> res.write('ok')) # need to do this

# socketio responses
server = http.createServer(app)
ioapp = io.listen(server)
sockets.startRedis(ioapp)
ioapp.sockets.on('connection', sockets.connect)

# start the server
server.listen(app.get('port'), ->
  console.log('Express server listening on port ' + app.get('port')))
