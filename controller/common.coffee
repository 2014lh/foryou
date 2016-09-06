
exports.loginChecked = (req, res)->
	console.log('common'+req.session.userid);
	if !req.session.userid
		res.redirect '/login'