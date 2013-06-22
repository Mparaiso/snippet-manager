/*jslint es5: true, white: true ,plusplus: true,nomen: true, sloppy: true */
/*globals angular */

var app = angular.module("snippetd");

function MainCtrl($scope, SnippetService, CategoryService, Options, $filter, Notification,$location) {
    $scope.version = angular.version.full;
    $scope.options = Options;
    $scope.find = function(keyword){
        SnippetService.search(keyword,function(results){
            $location.path("/app/snippets");
        });
    };
    $scope.resetFilter = function () {
        Options.search.category = null;
    };
    $scope.snippetService = SnippetService;
    $scope.categoryService = CategoryService;
    $scope.byCategory = SnippetService.filterCategory;
    $scope.getPage = function (page) {
        SnippetService.getTotal(SnippetService.getSnippets, [page]);
    }
    $scope.getPage();
}

function SnippetListCtrl($scope, $routeParams, SnippetService, CategoryService, Options, $log) {
    $scope.snippetService = SnippetService;
    $scope.categoryService = CategoryService;
    $scope.selectedSnippet = null;
}

function SnippetCreateCtrl($scope, $location, ModelService, SnippetService, $log) {
    $scope.snippet = SnippetService['new']();
    $log.info($scope.snippet);
    $scope.action = "Create a snippet.";
    $scope.save = function (snippet) {
        SnippetService.save(snippet);
        $log.info("snippet saved !", snippet);
        $location.path('/app/snippets');
    };
}

function SnippetFormCtrl($scope, $routeParams, CategoryService) {
    $scope.categories = CategoryService.categories;
}

function SnippetEditCtrl($scope, $routeParams, $location, $log, SnippetService, Snippet) {
    $scope.action = "Edit a snippet.";
    $scope.snippetId = $routeParams.snippetId;
    $scope.snippet = SnippetService.getById($scope.snippetId);
    if (!$scope.snippet) {
        Snippet.get({id: $scope.snippetId}, function (r) {
            $scope.snippet = r.snippet;
            ///$log.info($scope.snippet);
        });
    }
    if ($scope.snippet !== null) {
        $scope.snippetTitle = $scope.snippet.title;
    }
    $scope.save = function (snippet) {
        SnippetService.save(snippet);
        $location.path('/app/snippets');
    };
}

function SnippetReadCtrl($scope, $routeParams, $location, $log, SnippetService, Snippet) {
    $scope.SnippetService = SnippetService;
    $scope.action = "Read Snippet Infos.";
    $scope.snippetId = $routeParams.snippetId;
    $scope.snippet = SnippetService.getById($scope.snippetId);
    if (!$scope.snippet) {
        Snippet.get({id: $routeParams.snippetId}, function (r) {
                $scope.snippet = r.snippet;
            }
        );
    }
    $scope.remove = function (snippet) {
        $log.info("deleting snippet");
        return SnippetService.remove(snippet);
    };
}

function SnippetItemCtrl($scope, SnippetService, CategoryService, Snippet, Options, $routeParams, $log) {

    $scope.options = Options;
    $scope.getCategoryById = function (id) {
        return CategoryService.getById(id);
    };
    $scope.remove = function (snippet) {
        $log.info("deleting snippet");
        return SnippetService.remove(snippet);
    };
}

function OptionsCtrl($scope, Options) {
    $scope.options = Options;
}

function MainMenuCtrl($scope, Export, SnippetService) {
    $scope.export = function () {
        Export.doExport(SnippetService.snippets);
    };
}

