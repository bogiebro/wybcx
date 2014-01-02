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
    return if err then console.error err else result.uid

exports.setShowDesc = (show, desc)->
    err, result <- pool.query 'update shows set description = $2 where id = $1', [show, desc]
    console.log(err) if err

exports.getShowDesc = (show, res)->
    err, result <- pool.query 'select description, name, time from shows where id = $1', [show]
    if err then console.error err
    res.json(result.rows[0])
