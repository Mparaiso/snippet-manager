/*jslint es5: true, white: true ,plusplus: true,nomen: true, sloppy: true */
/*globals angular */
var app = angular.module("snippetd");

app.animation('sd-show',['$rootScope',function($rootScope){
    return{
        setup:function(element) {
            element.hide();
        },
        start:function(element,done){
            element.show('fast',function(){
                    done();
            });
        }
    };
}]);

app.animation('sd-hide',['$rootScope',function($rootScope){
    return{
        setup:function(element) {
            element.show();
        },
        start:function(element,done){
            element.hide('fast',function(){
                    done();
            });
        }
    };
}]);
