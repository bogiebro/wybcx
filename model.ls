db = require 'any-db'
pool = db.createPool(process.env.DATABASE_URL, {min: 2, max: 20})

exports.verify = (username, pass, done)->
    pool.query('select id, username from users where username = $1
                and pass = md5(salt || $2)', [username, pass],
        (err, result)->
            if err
                console.error err
                done(null, false)
            if result.rows.length != 1
                done(null, false)
            done(null, result.rows[0]))

exports.addAccount = (user, dept, pass)->
    pool.query('select id from adduser($1, $2, $3)',
        [user, dept, pass], (err, result)->
            return err ? console.error err : result.uid)
