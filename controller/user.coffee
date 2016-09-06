mongoose = require 'mongoose'
settings = require '../routes/settings'
User=require '../model/User'

exports.regesiter= (req,res)->
  User.userCheckedByPhone req.body.phoneNumber, (err,count)->
    if err
      res.json
        success:false
        err:err
    else
      if count==0
        User.userCount((err,userCount)->
          if err
            res.redirect 'user/login'
          else
            login=[{time:new Date()}] 
            newUser=new User(
              userid:1000+count
              username:req.body.phoneNumber
              phoneNumber:req.body.phoneNumber
              password:req.body.password
              date: new Date()
              login: login
            )
            newUser.save((err)->
              if err
                res.json
                  success:false
                  err:err
              else
                console.log('emodoou_text:sucess');
                res.redirect '/user/login'
            )
        )
      else
        console.log("账号存在")
        res.redirect 'user/login'

exports.login = (req, res)->
	User.login req.body.phoneNumber, req.body.password, (err,count,user)->
		if err	
			res.redirect('/index')
		else
			if count> 0
        req.session.user = user.user
        req.session.userid = user.userid
        res.json
          success:true
			else
        res.json
          success:false




