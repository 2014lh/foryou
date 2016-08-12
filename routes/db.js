var mongoose=require('mongoose');
mongoose.connect('mongodb://localhost/foryou');
var Schema=mongoose.Schema;
var userSchema=new Schema({
		userid:string,
		username:string,
		password:string
});
exports.user = db.model('c_user', userScheMa);