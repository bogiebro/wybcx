db = require("massive")

exports.connect = ->
    db.connect(process.env.DATABASE_URL, (err, db)->

        exports.verify := (username, pass)->
            db.run('select uid from users where username = $1
                    and pass = md5(salt || $2)', [username, pass],
                (err, result)->
                    if err
                        console.log(err)
                        return null
                    if result.length != 1
                        console.log('No matching username')
                        return false;
                    result[0].uid)

        exports.addAccount := (user, dept, pass)->
            db.run('with salt as md5(random()::text)
                    insert into users (username, department, salt, pass)
                    values ($1, $2, salt, md5(salt || $3))
                    returning uid',
                    [user, dept, pass], (err, result)->
                        console.log err if err
                        return result.uid))