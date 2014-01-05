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

exports.getShowDesc = (show, res)->
    err, result <- pool.query(
        'select description, name, time, hasimage from shows where id = $1', [show])
    if err then console.error err; res.send(500)
    else res.json(result.rows[0])

exports.hasImage = (show)->
    pool.query('update shows set hasimage = true where id = $1', [show])

exports.storeShow = (user, show, req, res)->
    async.waterfall do
        pool.query(
            'insert into shows (name, proptime, description) values ($1, $2, $3) returning id',
            [show.name, show.times, show.description], _)
        pool.query('update users set show = $1 where id = $2 returning show',
            [_.rows[0].id, user.id], _)
        , (err, result)->
            if err then console.error err; res.send(500)
            else res.json(id: result.rows[0].show)
