var mongoose=require('mongoose');
mongoose.Promise = global.Promise;
var Schema=mongoose.Schema;
var userSchema=new Schema({
	userid:String,
	username:String,
	password:String,
	email:String,
	phonenumber:String,
	rights:Number,
});
var dbname='foyou';
var uri = 'mongodb://localhost/' + dbname;
mongoose.connect(uri, function(err) {
  // if we failed to connect
  if (err) throw err;
});
userSchema.statics.findPersonByName = function(name, cb) {
    this.find({username: new RegExp(name, 'i')}, cb);
};
userSchema.statics.addUser=function(password,phonenumber,cb){

};
mongoose.model('User',userSchema);
