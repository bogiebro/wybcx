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
    subscriber.on "message", (channel, message)->
        io.sockets.emit(channel, JSON.parse(message))
    subscriber.subscribe('chat')
    subscriber.subscribe('show')

exports.connect = (s) ->
    s.on 'join', (name)->
        <- s.set('nickname', name)
        pusher.publish('chat', JSON.stringify({type: 'join', name: name}))
    s.on 'disconnect', (data)->
        (err, name) <- s.get 'nickname'
        pusher.publish('chat', JSON.stringify({type: 'leave', name: name}))
    s.on 'chat' (data)->
        (err, name) <- s.get 'nickname'
        console.error err if err 
        pusher.publish('chat', JSON.stringify({type: 'chat', name: name, content: data}))

    pusher.get 'showinfo', (err, reply)->
        res =   if reply then JSON.parse reply
                else {name: 'Automation', hosts: 'wybc robot djs'}
        s.emit('show', res)

exports.sendChat = (data)-> pusher.publish('chat', JSON.stringify(data))

djOn = (show)->
    str = JSON.stringify(show{name, hosts, id})
    pusher.set('showinfo', str)
    pusher.publish('show', str)

djOff = (showid)->
    pusher.get 'showinfo', (err, reply)->
        if reply && showid is (JSON.parse reply).id
            djOn(name: 'Automation', hosts: 'wybc robot djs')