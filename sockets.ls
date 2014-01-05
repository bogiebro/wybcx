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
        io.sockets.emit('chat', JSON.parse(message)))
    subscriber.subscribe("showchat")

exports.connect = (s) ->
    pusher.get 'showinfo', (err, reply)->
        if err then console.error err
        else
            console.log('sending reply ' + reply)
            s.emit('show', JSON.parse(reply))
    s.on('chat', (data)->
      pusher.publish('showchat', JSON.stringify(data)))
    s.on('show', (data)->
      pusher.set('showinfo', JSON.stringify(data))
      pusher.publish('showchat', JSON.stringify(data)))
