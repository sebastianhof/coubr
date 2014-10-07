var coubrApp = angular.module('coubrApp', [
    'ngRoute',
    'coubrAppControllers',
    'coubrAppFilters',
    'coubrAppServices'
]);

coubrApp.config(['$routeProvider',
    function ($routeProvider) {
        $routeProvider.
            when('/', {
                templateUrl: 'static/pages/app/index.html'
            }).
            when('/about', {
                templateUrl: 'static/pages/app/about.html'
            }).
            // legal
            when('/imprint', {
                templateUrl: 'static/pages/legal/imprint.html'
            }).
            when('/privacy', {
                templateUrl: 'static/pages/legal/privacy.html'
            }).
            when('/terms', {
                templateUrl: 'static/pages/legal/terms.html'
            }).
            // explore
            when('/explore', {
                templateUrl: 'static/pages/explore/explore.html',
                controller: 'ExploreCtrl'
            }).
            // blog
            when('/blog', {
                templateUrl: 'static/pages/blog/blog.html',
                controller: 'BlogCtrl'
            }).
            otherwise({
                redirectTo: '/'
            });
    }]);
