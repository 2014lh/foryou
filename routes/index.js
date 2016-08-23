/*
 * GET home page.
 */
// var mongoose=require('mongoose');
// require('./db');
// var User=mongoose.model('User');
exports.index = function(req,res){
  res.render('index');
};
exports.partials=function (req,res){
  	var name = req.params.name;
	// var query = {userid:"1003",'password':"123456"};
	// User.find(query, function(err, doc){//count返回集合中文档的数量，和 find 一样可以接收查询条件。query 表示查询的条件
	// 	var count = doc.length;
	// 	if(count >= 1){
	// 		console.log(query.userid + ": 登陆成功 " + new Date());
	// 		if(name=='addPost'){
	// 		}
			res.render('partials/' + name);	
	// 	}else{
	// 		console.log(query.userid + ": 登陆失败 " + new Date());
	// 		res.redirect('/');
	// 	}
	// });
};