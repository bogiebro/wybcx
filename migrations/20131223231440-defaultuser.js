var dbm = require('db-migrate');
var type = dbm.dataType;

exports.up = function(db, callback) {
    db.runSql("select * from adduser('root', 'engies', 'password');", callback);
};

exports.down = function(db, callback) {
    db.runSql("delete from users where username = 'root';", callback);
};
