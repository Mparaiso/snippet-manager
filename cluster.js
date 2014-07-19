/*jslint eqeq:true,node:true,es5:true,white:true,plusplus:true,nomen:true,unparam:true,devel:true,regexp:true */
/* parrallel server */
"use strict";
var cluster = require('cluster');
var http=require('http');
var numCPUs = require('os').cpus().length;
var container = require('./server');
var i;
if (cluster.isMaster){
    for(i =0;i<numCPUs;i++){
        cluster.fork();
    }
 cluster.on('exit', function(worker, code, signal) {
    console.log('worker ' + worker.process.pid + ' died');
  });
}else{
http.createServer(container.app).listen(container.port,container.ip,function  () {
    console.log('listening on %s:%s',container.ip,container.port);
});
}

