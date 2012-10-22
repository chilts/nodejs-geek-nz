// ----------------------------------------------------------------------------
//
// app.js
//
// ----------------------------------------------------------------------------

var http = require('http');
var path = require('path');

var express = require('express');

var routes = require('./lib/routes.js')

// ----------------------------------------------------------------------------
// the app itself

var app = express();

app.configure(function(){
    app.set('port', process.env.PORT || 3000);
    app.set('views', __dirname + '/views');
    app.set('view engine', 'jade');

    app.use(express.favicon());
    app.use(express.static(path.join(__dirname, 'public')));

    app.use(express.logger('dev'));

    app.use(app.router);
});

app.configure('development', function() {
    app.use(express.errorHandler());
});

// configure routes
app.get('/', routes.index);

http.createServer(app).listen(app.get('port'), function() {
    console.log("Express server listening on port " + app.get('port'));
});

// ----------------------------------------------------------------------------
