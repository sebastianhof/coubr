/*jshint unused: vars */
define(['angular', 'coubr']/*deps*/, function (angular, coubrJS)/*invoke*/ {
  'use strict';

  /**
   * @ngdoc overview
   * @name coubr
   * @description
   * # wwwApp
   *
   * Main module of the application.
   */
  return angular
    .module('coubr', [
/*angJSDeps*/
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngRoute',
    'ngAnimate',
    'ngTouch',
    'coubrJS'
  ])
    .config(['$routeProvider',
      function ($routeProvider) {
        $routeProvider.
          when('/', {
            templateUrl: '/views/index_DE.html'
          }).
          when('/ueber', {
            templateUrl: '/views/about_DE.html'
          }).
          // contact
          when('/kontakt', {
            templateUrl: '/views/contact_DE.html'
          }).
          when('/jobs', {
            templateUrl: '/views/jobs_DE.html'
          }).
          when('/team', {
            templateUrl: '/views/team_DE.html'
          }).
          // legal
          when('/impressum', {
            templateUrl: '/views/imprint_DE.html'
          }).
          when('/datenschutz', {
            templateUrl: '/views/privacy_DE.html'
          }).
          when('/agb', {
            templateUrl: '/views/terms_DE.html'
          }).
          // explore
          when('/entdecke', {
            templateUrl: '/views/explore_DE.html'
          }).
          // blog
          when('/blog', {
            templateUrl: '/views/blog_DE.html'
          }).
          otherwise({
            redirectTo: '/'
          });
      }]);
});
