/*jslint es5: true, white: true ,plusplus: true,nomen: true, sloppy: true */
/*globals angular,$ */

/**
 * SNIPPETD
 * Manage Code snippets in the browser !
 * @author MPARAISO <mparaiso@online.fr>
 * @version 0.0.1
 *
 */

var app = angular.module('snippetd', ['ngSanitize', "storage", "snippetd.resources"]);

// FR : Configuration des routes
app.config(['$routeProvider', '$locationProvider', '$httpProvider',
    function ($routeProvider, $locationProvider, $httpProvider) {
        $routeProvider.when('/app/snippets/create', {
            templateUrl: 'snippet-edit.html',
            controller: "SnippetCreateCtrl"
        }).when('/app/snippets/read/:snippetId', {
                templateUrl: 'snippet-read.html',
                controller: "SnippetReadCtrl"
            }).when('/app/snippets/edit/:snippetId', {
                templateUrl: 'snippet-edit.html',
                controller: "SnippetEditCtrl"
            }).when('/app/snippets', {
                templateUrl: 'snippet-list.html',
                controller: 'SnippetListCtrl'
            }).when("/app/options", {
                templateUrl: "options.html",
                controller: "OptionsCtrl"
            }).otherwise({
                redirectTo: "/app/snippets"
            });

        /**
         * @see http://stackoverflow.com/questions/11956827/angularjs-intercept-all-http-json-responses
         */
        $httpProvider.interceptors.push(function ($q, Notification) {
            return {
                'response': function (response) {
                    // do something on success
                    if (response.data && response.data.status && response.data.message )
                        Notification.notify(response.data.message);
                    //console.log(response);
                    //return response;
                    return response || $q.when(response);
                }
            }
        });
    }
]);

/**
 * @see http://stackoverflow.com/questions/11956827/angularjs-intercept-all-http-json-responses
 */


app.filter("def", function () {
    return function (input, _default) {
        var out = input;
        if (typeof(input) === "undefined" || input === null) {
            out = _default;
        }
        return out;
    };
});
