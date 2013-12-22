var dbm = require('db-migrate');
var type = dbm.dataType;

exports.up = function(db, callback) {
    db.createTable('users', {
        uid: { type: 'serial', primaryKey: true },
        username: { type: 'varchar(32)', unique: true },
        pass: 'text',
        salt: 'varchar(10)',
        department: 'varchar(32)',
        admin: { type: 'boolean', defaultValue: false }
    }, callback)
};

exports.down = function(db, callback) {
    db.dropTable('users', callback);
};
