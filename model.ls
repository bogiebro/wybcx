db = require 'any-db'
pool = db.createPool(process.env.DATABASE_URL, {min: 2, max: 20})

exports.verify = (username, pass, done)->
    err, result <- pool.query 'select id, username, show from users where username = $1 
                and pass = md5(salt || $2)', [username, pass]
    if err
        console.error err
        done(null, false)
    if result.rows.length != 1
        done(null, false)
    done(null, result.rows[0])

exports.addAccount = (user, dept, pass)->
    err, result <- pool.query 'select id from adduser($1, $2, $3)', [user, dept, pass]
    return if err then console.error err else result.id

exports.setShowDesc = (show, desc)->
    err, result <- pool.query 'update shows set description = $2 where id = $1', [show, desc]
    console.error(err) if err

exports.getShowDesc = (show, res)->
    err, result <- pool.query(
        'select description, name, time, hasimage from shows where id = $1', [show])
    if err then console.error err
    res.json(result.rows[0])

exports.storeShow = (user, show, req, res)->
    err, result <- pool.query(
            'insert into shows (name, proptime, description) values ($1, $2, $3) returning id',
            [show.name, show.times, show.description])
    if err then console.error err else
        showid = result.rows[0].id
        err, result <- pool.query('update users set show = $1 where id = $2', [showid, user.id])
        if err then console.error err
        err <- req.login(user with show: showid)
        if err then console.error err
        res.json(id: showid)
