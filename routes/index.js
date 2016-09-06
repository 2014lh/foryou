/*
 * GET home page.
 */
// var mongoose=require('mongoose');
// require('./db');
// var User=mongoose.model('User');
common = require('../controller/common'),
exports.index = function(req,res){
  res.render('index');
};
exports.partials=function (req,res){
  	var name = req.params.name;
  		if(name=="addPost"){
  			if(common.loginChecked(req,res)){
  				res.render('partials/' + name);		
  			}else{
  				res.redirect('/login');
  			}
  		}else{
  			res.render('partials/' + name);	
  		}
		
};