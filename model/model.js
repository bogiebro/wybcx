if (!global.hasOwnProperty('db')) {
    var Sequelize = require('sequelize');
    var sequelize = null;
    if (process.env.HEROKU_POSTGRESQL_JADE_URL) {
        var match = process.env.HEROKU_POSTGRESQL_JADE_URL.match(/postgres:\/\/([^:]+):([^@]+)@([^:]+):(\d+)\/(.+)/);
        sequelize = new Sequelize(match[5], match[1], match[2], {
            dialect:  'postgres',
            protocol: 'postgres',
            port:     match[4],
            host:     match[3],
            logging:  true
        });
    } else {
        sequelize = new Sequelize(null, null, null, {
             dialect: 'sqlite'
        });
    }
    global.db = {
        Sequelize: Sequelize,
        sequelize: sequelize,
        Show:      sequelize.import(__dirname + '/show')
    }

    sequelize.sync().success(function() {
      // do all your migration stuff here
    }).error(function(error) {
      console.log("Could not sync database");
      console.log(error);
    });
}

module.exports = global.db