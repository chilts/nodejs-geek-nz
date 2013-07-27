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
// load some data

var port = process.argv[2] || 8765;

var events = require('./data/calendar.json');
events = events.filter(function(event) {
    return event.show;
});

// ----------------------------------------------------------------------------
// the app itself

var app = express();

// add some local data
app.use(function(req, res, next) {
    res.locals.events = events;
    next();
});

app.configure(function(){
    app.set('port', port);
    app.set('views', __dirname + '/views');
    app.set('view engine', 'jade');

    app.use(express.favicon(__dirname + '/public/favicon.ico'));
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
