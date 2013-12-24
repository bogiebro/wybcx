var dbm = require('db-migrate');
var type = dbm.dataType;

exports.up = function(db, callback) {
    db.runSql( 'CREATE FUNCTION adduser(varchar, varchar, varchar) \
                RETURNS TABLE(uid integer) AS $$ \
                DECLARE salt varchar; BEGIN \
                salt := md5(random()::text); \
                RETURN QUERY insert into users (email, department, salt, pass) \
                values ($1, $2, salt, md5(salt || $3)) \
                returning users.id; \
                END$$ LANGUAGE plpgsql;', callback );
};

exports.down = function(db, callback) {
    db.runSql('DROP FUNCTION adduser(varchar, varchar, varchar);', callback);
};

