/*jslint eqeq:true,node:true,white:true,plusplus:true,nomen:true,unparam:true,devel:true,regexp:true */
/* parrallel server */
"use strict";
var cluster = require('cluster');
var http=require('http');
var numCPUs = require('os').cpus().length;
var container = require('./server');
var i;
if(!module.parent){
    if (cluster.isMaster){
        for(i =0;i<numCPUs;i++){
            cluster.fork();
        }
        cluster.on('exit', function(worker, code, signal) {
            console.log('worker ' + worker.process.pid + ' died');
        });
    }else{
        if(process.env.IS_HEROKU){
            http.createServer(container.app).listen(container.port,function  () {
                console.log('listening on port %s',container.port);
            });
        }else{
            http.createServer(container.app).listen(container.port,container.ip,function  () {
                console.log('listening on %s:%s',container.ip,container.port);
            });
        }

    }
}else{
    module.exports=container;
}

