// ----------------------------------------------------------------------------
//
// app.js
//
// ----------------------------------------------------------------------------

var http = require('http');
var path = require('path');

var express = require('express');
var moment = require('moment');

var routes = require('./lib/routes.js')

// ----------------------------------------------------------------------------
// load some data

process.title = 'nodejs.geek.nz';

var port = process.argv[2] || 8765;

var events = require('./data/calendar.json');
var menu = require('./data/menu.js');

// filter out the old events
events = events.filter(function(event) {
    return event.show;
});

// ----------------------------------------------------------------------------
// the app itself

var app = express();

app.locals.menu = menu;

// add some local data
app.use(function(req, res, next) {
    res.locals.events = events;
    res.locals.moment = moment;
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
app.get('/talks', routes.talks);
app.get('/about', routes.about);

http.createServer(app).listen(app.get('port'), function() {
    console.log("Express server listening on port " + app.get('port'));
});

// ----------------------------------------------------------------------------
