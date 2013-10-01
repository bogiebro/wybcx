var model = require('./model');
var sequelize = model.sequelize;
var Sequelize = model.Sequelize;
var indices = require('./indices');

exports.Show = sequelize.define('show', {
  name: {type: Sequelize.STRING, primaryKey: true},
  time: Sequelize.STRING,
  desc: Sequelize.TEXT,
  pic:  Sequelize.STRING
}, {timestamps: false});

exports.Member = sequelize.define('member', {
  id: {type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true},
  name: Sequelize.STRING,
  desc: Sequelize.TEXT,
  shows: Sequelize.ARRAY(Sequelize.INTEGER),
  admin: Sequelize.BOOLEAN,
  department: Sequelize.STRING,
}, {timestamps: false});

exports.BlogPost = sequelize.define('blogpost', {
  id: {type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true},
  author: {type: Sequelize.INTEGER, references: "member", referencesKey: "id"},
  content: Sequelize.TEXT,
  desc: Sequelize.TEXT,
  heading: Sequelize.STRING,
  category: Sequelize.STRING
}, {timestamps: false});

exports.Chatter = sequelize.define('chatter', {
  id: {type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true},
  who: Sequelize.STRING,
  type: Sequelize.STRING,
  content: Sequelize.STRING,
});

sequelize.sync().success(function() {
  // do all your migration stuff here
}).error(function(error) {
  console.log("Could not sync database");
  console.log(error);
});
