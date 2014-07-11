/*jslint eqeq:true,node:true,es5:true,white:true,plusplus:true,nomen:true,unparam:true,devel:true,regexp:true */
require('coffee-script').register();
var container = require('./coffee/container');
var http = require('http');

if(!module.parent){
    http.createServer(container.app).listen(container.port,container.ip,function(){
        console.log('listening on %s:%s',container.ip,container.port);
    });
}else{
    module.exports = container;
}

