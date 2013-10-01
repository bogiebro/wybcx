exports.index = function(req, res) {
  res.render('listener/layout');
};

exports.partials = function (req, res) {
  var name = req.params.name;
  res.render('listener/partials/' + name);
};
