require! "redis"

var pusher, subscriber

exports.startRedis = (io)->
    if process.env.REDISTOGO_URL
        rtg   = require("url").parse(process.env.REDISTOGO_URL)
        subscriber := redis.createClient(rtg.port, rtg.hostname)
        subscriber.auth(rtg.auth.split(":")[1])
        pusher := redis.createClient(rtg.port, rtg.hostname)
        pusher.auth(rtg.auth.split(":")[1])
    else
        subscriber := redis.createClient()
        pusher := redis.createClient()

    subscriber.on("message", (channel, message)->
        io.sockets.emit('chat', JSON.parse(message)))
    subscriber.subscribe("showchat")

exports.connect = (s) ->
  console.log('socket connected')
  s.on('chat', (data)->
    pusher.publish('showchat', JSON.stringify(data)))
