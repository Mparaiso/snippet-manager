/*jslint eqeq:true,node:true,es5:true,white:true,plusplus:true,nomen:true,unparam:true,devel:true,regexp:true */
require('coffee-script').register();
var container = require('./coffee/container');
var http = require('http');

if(!module.parent){
    if(process.env.IS_HEROKU){
        http.createServer(container.app).listen(container.port,function(){
            console.log('listening on %s',container.port);
        });

    }else{
        http.createServer(container.app).listen(container.port,container.ip,function(){
            console.log('listening on %s:%s',container.ip,container.port);
        });

    }
}else{
    module.exports = container;
}

