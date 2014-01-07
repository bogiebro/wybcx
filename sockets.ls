require! <[ redis url ]>

var pusher, subscriber, redisClient

if process.env.REDISTOGO_URL
    rtg   = url.parse(process.env.REDISTOGO_URL)
    redisClient = ->
        redis.createClient(rtg.port, rtg.hostname)
            ..auth(rtg.auth.split(":")[1])
else redisClient = -> redis.createClient!

exports.startRedis = (io)->
    subscriber := redisClient!
    pusher := redisClient!
    subscriber.on("message", (channel, message)->
        io.sockets.emit(channel, JSON.parse(message)))
    subscriber.subscribe("chat")
    subscriber.subscribe("show")

disconnect = (s)->
    robot = JSON.stringify(name: 'Automation', dj: 'wybc robot djs')
    pusher.set('showinfo', robot)
    pusher.publish('show', robot)

exports.connect = (s) ->
    s.on('disconnect', disconnect)
    pusher.get 'showinfo', (err, reply)->
        if err then console.error err
        else
            res = if reply then JSON.parse reply
                  else {name: 'Automation', dj: 'wybc robot djs'}
            s.emit('show', res)
    s.on('chat', (data)->
      pusher.publish('chat', JSON.stringify(data)))
    s.on('show', (data)->
      pusher.set('showinfo', JSON.stringify(data))
      pusher.publish('show', JSON.stringify(data)))
