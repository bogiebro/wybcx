// var shows = require('./model/shows');

exports.index = function(req, res) {
  res.render('layout');
};

exports.partials = function (req, res) {
  var name = req.params.name;
  res.render(name);
};

exports.dj = function(req, res) {
	res.render('dj');
};