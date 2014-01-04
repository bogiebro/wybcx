require! <[ express http path passport fs knox passport-local gm multiparty ]>
io = require('socket.io')
im = gm.subClass(imageMagick: true)
require! <[ ./sockets ./model ]>

# Express config
app = express!
development = 'development' == app.get('env')
app.set('port', process.env.PORT || 3000)
app.use _
  .. if development then express.logger 'dev' else express.logger!
  .. express.compress!
  .. <| express.static <| path.join(__dirname, 'build')
  .. express.urlencoded!
  .. app.router
  .. express.errorHandler! if development

session =
  express.cookieParser!
  express.session(secret: 'keyboard cat')
  passport.initialize!
  passport.session!

json = express.json!

# setup passport
passport
  ..use(new passport-local.Strategy(model.verify))
  ..serializeUser((id, done)!-> done(null, id))
  ..deserializeUser((id, done)!-> done(null, id))
auth = (req, res, next)!->
  if !req.isAuthenticated! then res.send(401) else next!

# setup s3
s3 = knox.createClient do
    key: process.env.S3ID
    secret: process.env.S3SECRET
    bucket: 'wybcsite'

s3result = (res, err, r)-->
  console.error err if err
  console.error r.statusCode if r.statusCode != 200
  res.send 200

# http responses
app.get '/', (req, res)!-> res.redirect('/listener/index.html')

app.post '/login', session, json, passport.authenticate('local'), (req, res)!->
  res.json(req.user)

app.get '/loggedin', session, (req, res)!->
  if req.isAuthenticated! then res.json(req.user) else res.send('0')

app.post '/logout', session, (req, res)!-> req.logOut!; res.send 200

app.post '/upload', session, auth, (req, res)!->
  form = new multiparty.Form!
  upload = {}
  form.on 'field', (name, value)!-> upload.dir = value if (name is 'uploadtype')
  form.on 'part', (part)!-> upload.stream = part if part.filename

  form.on 'close', !->
    if (upload.dir && upload.stream)
      n = upload.stream.filename
      loc = '/' + upload.dir + '/' + req.user.show + '.jpg'
      if n is /png|jpg|jpeg|pdf/i
        im(upload.stream, n).resize(250).setFormat('jpeg').toBuffer (err, buffer)!->
          if err then console.error err else
            s3.putBuffer(buffer, loc, {}, s3result)
      else
        header = 'Content-Length': stream.byteCount
        s3.putStream upload.stream, loc, header, (s3result res)
    else
      console.error('Missing multipart fields')
      res.send 400

  form.parse(req)

app.post('/showdesc', session, json, auth, (req, res)->
    model.setShowDesc(req.user.show, req.body.desc)
    res.send(200))

app.get('/showdesc/:show', (req, res)->
    model.getShowDesc(req.params.show, res))

app.post '/showreq', session, auth, (req, res)->
  form = new multiparty.Form!
  show = {}
  form.on 'part', (part)!-> 
    if part.filename
      h = 'Content-Length': part.byteCount
      s3.putStream part, ('/samples/' + req.user.show + path.extname(that)), h, (s3result res)
  form.on 'field', (name, value)!-> show[name] = value
  form.on 'close', !-> model.storeShow(req.user, show, req, res)
  form.parse(req)

# socketio responses
server = http.createServer(app)
ioapp = io.listen(server)
sockets.startRedis(ioapp)
ioapp.sockets.on('connection', sockets.connect)

# start the server
server.listen(app.get('port'), ->
  console.log('Express server listening on port ' + app.get('port')))
