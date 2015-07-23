/*jslint eqeq:true,node:true,es5:true,white:true,plusplus:true,nomen:true,unparam:true,devel:true,regexp:true */
var container;
if(process.env.NODE_ENV==="production"){
    require('source-map-support').install();
    container=require('./js/container');
}else{
    require('coffee-script').register();
    container = require('./coffee/container');
}

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

