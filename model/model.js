exports.Sequelize = require('sequelize');

exports.sequelize = new exports.Sequelize('radiotest', 'node', 'happy place', {
	dialect: 'postgres',
	port: 5432
});
