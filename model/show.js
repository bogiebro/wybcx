module.exports = function(sequelize, DataTypes) {
  return sequelize.define("Show", {
    name: {type: DataTypes.STRING, primaryKey: true},
    time: DataTypes.STRING,
    desc: DataTypes.TEXT,
    pic:  DataTypes.STRING
  }, {timestamps: false});
}