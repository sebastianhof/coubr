/*jshint unused: vars */
require.config({
  paths: {
    angular: '../../bower_components/angular/angular',
    'angular-animate': '../../bower_components/angular-animate/angular-animate',
    'angular-cookies': '../../bower_components/angular-cookies/angular-cookies',
    'angular-mocks': '../../bower_components/angular-mocks/angular-mocks',
    'angular-resource': '../../bower_components/angular-resource/angular-resource',
    'angular-route': '../../bower_components/angular-route/angular-route',
    'angular-sanitize': '../../bower_components/angular-sanitize/angular-sanitize',
    'angular-scenario': '../../bower_components/angular-scenario/angular-scenario',
    'angular-touch': '../../bower_components/angular-touch/angular-touch',
    bootstrap: '../../bower_components/bootstrap/dist/js/bootstrap',
    'angular-bootstrap': '../../bower_components/angular-bootstrap/ui-bootstrap-tpls'
  },
  shim: {
    angular: {
      exports: 'angular'
    },
    'angular-route': [
      'angular'
    ],
    'angular-cookies': [
      'angular'
    ],
    'angular-sanitize': [
      'angular'
    ],
    'angular-resource': [
      'angular'
    ],
    'angular-animate': [
      'angular'
    ],
    'angular-touch': [
      'angular'
    ],
    'angular-mocks': {
      deps: [
        'angular'
      ],
      exports: 'angular.mock'
    }
  },
  priority: [
    'angular'
  ],
  packages: []
});

//http://code.angularjs.org/1.2.1/docs/guide/bootstrap#overview_deferred-bootstrap
window.name = 'NG_DEFER_BOOTSTRAP!';

require([
  'angular',
  'coubr',
  'angular-route',
  'angular-cookies',
  'angular-sanitize',
  'angular-resource',
  'angular-animate',
  'angular-touch'
], function (angular) {
  'use strict';

  var app = angular
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
          // blog
          when('/blog', {
            templateUrl: '/views/blog_DE.html'
          }).
          // register
          when('/register', {
            templateUrl: '/views/auth/register.html'
          }).
          when('/login', {
            templateUrl: '/views/login_DE.html'
          }).
          when('/resetPassword', {
            templateUrl: '/views/auth/resetPassword.html'
          }).
          when('/resetPasswordConfirm', {
            templateUrl: '/views/auth/resetPasswordConfirm.html'
          }).
          when('/confirmRegistration', {
            templateUrl: '/views/auth/confirmRegistration.html'
          }).
          when('/resendConfirmation', {
            templateUrl: '/views/auth/resendConfirmation.html'
          }).

          otherwise({
            redirectTo: '/'
          });
      }]);


  /* jshint ignore:start */
  var $html = angular.element(document.getElementsByTagName('html')[0]);
  /* jshint ignore:end */
  angular.element().ready(function () {
    angular.resumeBootstrap([app.name]);
  });
});

