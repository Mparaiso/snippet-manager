/*jslint es5: true, white: true ,plusplus: true,nomen: true, sloppy: true */
/*globals angular */

/**
 * @author MPARAISO <mparaiso@online.fr>
 */

var app = angular.module("snippetd");
/**
 * FR : module gérant la coloration syntaxique
 */
app.factory("Prettify",function($window){
    return {
        print:function(string){
            return $window.hljs.highlightAuto(string).value;
        }
    };
});
