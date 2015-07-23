/*jslint es5: true, white: true ,plusplus: true,nomen: true, sloppy: true */
/*globals angular,$ */

var app = angular.module("snippetd");
app.factory("Notification", function ($window, $timeout, $log, Options) {

    var notification = {
    };
    if ($window.Notification) {
        notification.notify = function (message, title) {
            if (Options.params.showNotifications == false) {
                return
            }
            var _notification;
            message = message || "default message";
            title = title || 'SnippetD';
            _notification = new $window.Notification(title, {
                body: message
            });
            _notification.onshow = function () {
                $timeout(function () {
                    _notification.close()
                }, Options.params.notificationTimeout)
            }
            _notification.show();
        };
    }
    else {
        notification.notify = function () {
        };
    }
    return notification;
});
app.factory("Options", function (Storage, $window, $log) {
    var backgrounds, themes, selectedTheme, selectedBackground, options;
    $($window).on("beforeunload", function (e) {
        Storage.save("options", options.params);
    });
    themes = [
        {id: 1, value: "default"},
        {id: 2, value: "monokai"},
        {id: 3, value: "arta"},
        {id: 4, value: "idea"},
        {id: 5, value: "magula"},
        {id: 6, value: "sunburst"},
        {id: 7, value: "dark"},
        {id: 8, value: "github"},
        {id: 9, value: "tomorrow"},
        {id: 10, "value": "far"}
    ];
    backgrounds = [
        {id: 1, value: "white"},
        {id: 2, value: "black"}
    ];
    options = {
        search: {},
        themes: themes,
        backgrounds: backgrounds,
        getDefaultParams: function () {
            var _defaultParams = angular.extend({}, options.defaultParams);
            return angular.extend(_defaultParams, Storage.get("options"));
        },
        getThemeById: function (id) {
            var i;
            for (i = 0; i < this.themes.length; i++) {
                if (this.themes[i].id === +id) {
                    return this.themes[i];
                }
            }
        },
        getBgById: function (id) {
            var i;
            for (i = 0; i < this.backgrounds.length; i++) {
                if (this.backgrounds[i].id === +id) {
                    return this.backgrounds[i];
                }
            }
        }
    };
    options.defaultParams = {
        selectedTheme: {id: 2, value: "monokai"},
        selectedBackground: {id: 2, value: "black"},
        notificationTimeout: 3000,
        snippetPerPage: 20,
        showNotifications: true
    };
    options.params = options.getDefaultParams();
    return options;
});
app.factory("UtilService", function () {
    /**
     * @name UtilService
     */
    var UtilService = {
        /** FR : cree un id unique */
        makeId: function () {
            return Date.now();
        },
        /* EN : creates a date string */
        makeDate: function () {
            return (new Date()).toISOString();
        },
        /** EN : get a date object from a date string */
        parseDate: function (dateString) {
            return new Date(dateString);
        }
    };
    return UtilService;
});
app.factory("ModelService", function () {
    return {
        config: {},
        defaults: {
            defaultSnippet: {
                id: null,
                title: 'Snippet title',
                description: 'Snippet Descrition',
                content: 'Snippet Content',
                tags: [],
                category: null
            },
            defaultCategory: {
                id: 0,
                name: "Default"
            }
        },
        data: {
            snippets: [],
            categories: []
        }
    };
});
app.factory('SnippetService', function (UtilService, ModelService, Options, $http, $log, $window, Prettify, Snippet) {
    /**
     * @name SnippetService
     */
    var SnippetService;

    SnippetService = {
        page: {
            FIRST: "first",
            PREVIOUS: "previous",
            LAST: "last",
            NEXT: "next"
        },
        total: null,
        /**
         * search a word
         * @param {string} keyword
         * @param {function} callback
         */
        _keyword: null,
        search: function (keyword, callback, callbackArgs) {
            var that = this;
            callbackArgs = callbackArgs || [];
            $http.get("/api/snippet/search/" + encodeURI(keyword)
                , {params: {limit: Options.params.snippetPerPage}}
            ).success(function (result) {
                    that.snippets = result.snippets;
                    that.total = that.snippets.length;
                    that.setOffset(0);
                    return callback.apply(this, [].slice.call(callbackArgs));
                });
        },
        getTotal: function (callback, callbackArgs) {
            $http({method: "GET", url: "/api/snippet/count"}).success(function (data) {
                SnippetService.total = data.count;
                console.log("count=", SnippetService.total);
                if (callback) {
                    callback.apply(SnippetService, callbackArgs);
                }
            });
        },
        isFirstPage: function () {
            return this._offset == 0;
        },
        hasPrevious: function () {
            return this._offset > 0;
        },
        hasNext: function () {
            return this._offset * Options.params.snippetPerPage < this.getTotal();
        },
        getSnippets: function (page) {
            if (page) {
                switch (page) {
                    case "next":
                        SnippetService.setOffset(SnippetService.getOffset() + 1);
                        break;
                    case "previous":
                        SnippetService.setOffset(SnippetService.getOffset() - 1);
                        break;
                    case "last":
                        SnippetService.setOffset(Math.floor((this.total - 1) / Options.params.snippetPerPage));
                        break;
                    default:
                        this.setOffset(0);
                        break;
                }
                $log.info("page = ", page, "offset = ", SnippetService.getOffset());
            }
            Snippet.get(
                {limit: Options.params.snippetPerPage, offset: SnippetService.getOffset()},
                SnippetService.onsnippetresult
            );
        },
        _offset: 0,
        getOffset: function () {
            return SnippetService._offset;
        },
        setOffset: function (value) {
            console.log("new offset=", value, "total=", SnippetService.total);
            if ((value * Options.params.snippetPerPage) < this.total && value >= 0) {
                console.log("new offset=", value);
                SnippetService._offset = value;
            }
            return this;
        },
        onsnippetresult: function (result) {
            SnippetService.snippets = result.snippets;
        },
        snippets: [],
        filterCategory: function (item) {
            var predicat = true;
            if (Options.search.category) {
                predicat = item.category_id === +Options.search.category.id;
            }
            return predicat;
        },
        getById: function (id, copy) {
            var snippet = null, i;
            if (typeof(copy) === "undefined") {
                copy = true;
            }
            for (i = 0; i < this.snippets.length; i++) {
                if (id == this.snippets[i].id) {
                    if (copy === true) {
                        snippet = angular.extend({}, this.snippets[i]);
                    } else {
                        snippet = this.snippets[i];
                    }
                }
            }
            return snippet;
        },
        save: function (snippet) {
            snippet.prettyContent = Prettify.print(snippet.content);
            Snippet.save(snippet, function (r) {
                SnippetService.getSnippets();
            });


        },
        "new": function () {
            return new Snippet;
        },
        remove: function (snippet) {
            Snippet.delete(snippet, function () {
                SnippetService.getSnippets();
            });
        }
    };
    // obtenir le total des snippets , puis les snippets
    SnippetService.getTotal(SnippetService.getSnippets);
    return SnippetService;
})
;
app.factory('CategoryService', function (Category) {

    var CategoryService = {
        getById: function (id) {
            var i;
            for (i = 0; i < this.categories.length; i++) {
                if (this.categories[i].id === id) {
                    return this.categories[i];
                }
            }
        },
        categories: []
    };
    Category.get(function (result) {
        [].push.apply(CategoryService.categories, result.categories);
    });
    return CategoryService;
});
app.factory('Export', function ($window, $log) {
    return {
        /* export des données */
        doExport: function (data) {
            var blob, url;
            blob = new $window.Blob([angular.toJson(data)], {type: "application/json"});
            url = $window.URL.createObjectURL(blob);
            $window.open(url);
        }
    };
});

