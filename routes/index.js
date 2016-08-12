
/*
 * GET home page.
 */
var user=require('../db').user;
exports.index = function(req, res){
    res.render('index');
};
exports.partials = function (req, res) {
  var name = req.params.name;
  console.log(user);
  res.render('partials/' + name);
};