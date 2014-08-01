var express, Pimple, pimple, http, port;

http = require('http');
port = process.env.NODE_PORT || process.env.PORT || 3000;
express = require('express');
Pimple = require('pimple');

container = new Pimple;

container.set('app', function (c) {
    var app = express();
    app.use(function (req, res, next) {
        console.log('%s %s', req.method, req.url);
        next();
    });
    app.get('/', function (req, res) {
        res.send('Hello World!');
    })
    return app;
});

container.register(require('./controller'));

if (!module.parent) {
    http.createServer(container.app).listen(port, function () {
        console.log('listening on port ' + port);
    });
} else {
    module.export = container;
}