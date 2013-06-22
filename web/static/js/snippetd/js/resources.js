/*jslint es5: true, white: true ,plusplus: true,nomen: true, sloppy: true */
/*globals angular */

var resources = angular.module("snippetd.resources", ["ngResource"]);


resources.factory("Snippet", function ($resource, $log) {
    return $resource('/api/snippet/:id.json', {"id": "@id"}, {});

});


resources.factory("Category", function ($resource, $log) {
    return $resource('/api/category/:id.json', {"id": "@id"}, {});

});
