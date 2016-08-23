
/**
 * Module dependencies.
 */
var express = require('express'),
  routes = require('./routes'),
  blog = require('./controller/blog'),
  user = require('./controller/user'),
  app = module.exports = express.createServer(),
  expressValidator = require('express-validator'),
  db = require('./routes/db'),
  cookieParser = require('cookie-parser'),
  session = require('express-session'),
  settings=require('./routes/settings');

// Configuration

app.use(cookieParser());

app.use(session({
  secret: settings.cookieSecret,
  name:settings.sessionID,
  cookie: 1000 * 60 * 60 * 24 * 7,
  resave: false,
  saveUninitialized: true,
}));

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.set('view options', {
    layout: false
  });
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.static(__dirname + '/public'));
  app.use(app.router);
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
  app.use(express.errorHandler());
});

// Routes
app.get('/', routes.index);
app.get('/partials/:name',routes.partials);

app.post('/user/login/', user.login);

app.get('/blog/posts', blog.blogAll);
app.get('/blog/post/:id', blog.perBlog);


app.post('/blog/post', blog.post);
// app.put('/api/post/:id', api.editPost);
// app.delete('/api/post/:id', api.deletePost);
// redirect all others to the index (HTML5 history)
app.get('*', routes.index);
// Start server

app.use(expressValidator({
  errorFormatter: function(param, msg, value) {
      var namespace = param.split('.')
      , root    = namespace.shift()
      , formParam = root;

    while(namespace.length) {
      formParam += '[' + namespace.shift() + ']';
    }
    return {
      param : formParam,
      msg   : msg,
      value : value
    };
  }
}));



app.listen(3000, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
