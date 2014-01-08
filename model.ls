db = require 'any-db'
async = require 'async'
pool = db.createPool(process.env.DATABASE_URL, {min: 2, max: 20})

exports.verify = (username, pass, done)->
    err, result <- pool.query 'select id, username, show from users where username = $1 
                and pass = md5(salt || $2)', [username, pass]
    if err
        console.error err
        return done(null, false)
    return done(null, false) if result.rows.length != 1
    done(null, result.rows[0])

exports.addAccount = (user, dept, pass)->
    err, result <- pool.query 'select id from adduser($1, $2, $3)', [user, dept, pass]
    if err then console.error err; res.send(500) else result.id

exports.setShowDesc = (show, desc)->
    err, result <- pool.query 'update shows set description = $2 where id = $1', [show, desc]
    console.error(err) if err

exports.getShowDesc = (show, cb, ecb)->
    err, result <- pool.query(
        'select description, name, time, hasimage, hosts from shows where id = $1', [show])
    if err && ecb then ecb(err)
    else cb(result.rows[0])

exports.hasImage = (show)->
    pool.query('update shows set hasimage = true where id = $1', [show])

exports.storeShow = (user, show, req, res)->
    hosts = if show.cohost then user.username + ' and ' + show.cohost else user.username
    async.waterfall [
        pool.query(
            'insert into shows (name, proptime, description, hosts) values ($1, $2, $3, $4) returning id',
            [show.name, show.times, show.description, hosts], _),
        (val, cb)-> pool.query('update users set show = $1 where id = $2 or username = $3 returning show',
            [val.rows[0].id, user.id, show.cohost or ''], cb),
        (val, cb)-> req.login(user with show: val.rows[0].show, cb)]
        , (err, result)->
            if err then console.error err; res.send(500)
            else res.send(200)

exports.findHosts = (search, cb)->
    err, result <- pool.query('select username from users where username like $1', [search + '%'])
    console.error(err) if err
    res = result.rows.map((.username))
    cb(res)