var dbm = require('db-migrate');
var type = dbm.dataType;

exports.up = function(db, callback) {
    db.createTable('shows', {
        id: { type: 'serial', primaryKey: true },
        name: { type: 'varchar(64)', unique: true },
        description: 'text',
        time: 'varchar(32)',
        proptime: 'text',
        hasimage: {type: 'boolean', defaultValue: false},
        hosts: { type: 'varchar(64)' }
    }, callback)
};

exports.down = function(db, callback) {
    db.dropTable('shows', callback);
};
