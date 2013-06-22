/*jslint es5: true, white: true ,plusplus: true,nomen: true, sloppy: true */
/*globals angular */

var storage = angular.module("storage",[]);

storage.factory("Storage",function($window,$log){
    return {
        save:function (key,value) {
            if(typeof(value)!=="string"){
                value=angular.toJson(value);
            }
            $window.localStorage.setItem(key,value);
            return value;
        },
        get:function(key){
            var value;
            try{
                value = JSON.parse($window.localStorage.getItem(key));
            }catch(e){
                $log.info("Error parsing "+key+" in localstorage");
            }
            return value ;   
        }
    };
});

var phpStorage = angular.module("php.storage",['ngResource']);

phpStorage.factory("Storage",function($resource,$log){
    return $resource('/api/snippet/:id.json',{"id":"@id"},{});
//    return {
//        save:function (key,value) {
//            if(typeof(value)!=="string"){
//                value=angular.toJson(value);
//            }
//            $window.localStorage.setItem(key,value);
//            return value;
//        },
//        get:function(key){
//            var value;
//            try{
//                value = JSON.parse($window.localStorage.getItem(key));
//            }catch(e){
//                $log.info("Error parsing "+key+" in localstorage");
//            }
//            return value ;
//        }
//    };
});
