mongoose = require 'mongoose'
Schema = mongoose.Schema

userSchema = new Schema
  userid: String
  username: String
  email: String
  phoneNumber:String
  password: {type: String, default: 0}
  date: Date
  imgHead: String
  ticket:String
  login:[
    time:Date
  ]

userSchema.statics =

  login: (phoneNumber,password,cb)->
    thisUser=@
    @count().exec((err, count)->
      if err
        cb err, null
      else  
        thisUser.find({phoneNumber: phoneNumber,password:password}).exec((err, user)->
          if err
            cb err, 0 , null
          else
            user.password=null
            cb null, count, user
        )
    )

  userCheckedByPhone: (phoneNumber,cb)->
    @find({phoneNumber: phoneNumber}).count().exec((err, count)->
      if err
        cb err, null
      else
        cb null, count
    )

 　userChecked: (phoneNumber,password,cb)->
    @find({phonenumber: phoneNumber,password: password}).count().exec((err, count)->
      if err
        cb err, null
      else
        cb null, count
    )
  userCount: (cb)->
    @count().exec((err, count)->
      if err
        cb err, null
      else 
        cb null, count 
    ) 


User = mongoose.model 'User', userSchema
module.exports = User