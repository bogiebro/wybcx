var model = require('../model');
var sequelize = model.sequelize;
var Sequelize = model.Sequelize;
var indices = require('../indices');

exports.Show = sequelize.define('Show', {
}, {timestamps: false});

sequelize.sync().success(function() {
  // do all your error stuff here
}).error(function(error) {
  console.log("Could not sync database");
  console.log(error);
});
