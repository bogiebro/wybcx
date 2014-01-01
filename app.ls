# external dependencies
express = require('express')
http = require('http')
path = require('path')
io = require('socket.io')
app = express()
passport = require('passport')
local = require('passport-local')
fs = require('fs')
knox = require('knox')

# my dependencies
sockets = require('./sockets')
model = require('./model')

# Set up express
app.use(require('connect-assets')())
app.set('port', process.env.PORT || 3000)
app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
app.use(express.logger('dev'))
app.use(express.bodyParser())
app.use(express.methodOverride())
app.use(express.cookieParser())
app.use(express.session({secret: 'keyboard cat'}))
app.use(passport.initialize())
app.use(passport.session())
app.use(app.router)
app.use(express.static(path.join(__dirname, 'build')))

# development only
app.use(express.errorHandler()) if 'development' == app.get('env')

# setup passport
passport.use(new local.Strategy(model.verify))
passport.serializeUser((id, done)-> done(null, id))
passport.deserializeUser((id, done)-> done(null, id))
auth = (req, res, next)->
  if !req.isAuthenticated! then res.send(401) else next!

# setup s3
s3 = knox.createClient(
    key: process.env.S3ID
    secret: process.env.S3SECRET
    bucket: 'wybcpics')

# http responses
app.get('/', (req, res)-> res.redirect('/listener/index.html'))
app.post('/upload', auth, (req, res)->
    n = req.files.myFile.name
    loc = '/' + req.body.uploadtype + '/' + req.user.show + path.extname(n)
    # s3.putFile(req.files.myFile.path, loc, (err, r)->
    #     console.log(err) if err
    #     console.log(r.statusCode) if (r.statusCode != 200)
    #     res.json(result: loc)))
    res.json(result: loc))
app.post('/login', passport.authenticate('local'), (req, res)->
  res.json(req.user))
app.get('/loggedin', (req, res)->
  if req.isAuthenticated! then res.json(req.user) else res.send('0'))
app.post('/logout', (req, res)-> 
  req.logOut()
  res.send(200))
app.post('/showdesc', auth, (req, res)->
    model.setShowDesc(req.user.show, req.body.desc)
    res.send(200))
app.get('/showdesc/:show', (req, res)->
    model.getShowDesc(req.params.show, res))

# socketio responses
server = http.createServer(app)
ioapp = io.listen(server)
sockets.startRedis(ioapp)
ioapp.sockets.on('connection', sockets.connect)

# start the server
server.listen(app.get('port'), ->
  console.log('Express server listening on port ' + app.get('port')))
