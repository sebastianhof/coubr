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
  'controllers/auth',
  'controllers/coupon',
  'controllers/feedback',
  'controllers/other',
  'controllers/store',
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
      'coubrJS',
      'coubr.controllers.AuthCtrl',
      'coubr.controllers.CouponCtrl',
      'coubr.controllers.FeedbackCtrl',
      'coubr.controllers.OtherCtrl',
      'coubr.controllers.StoreCtrl',
    ])
    .config(['$routeProvider',
      function ($routeProvider) {
        $routeProvider.
          when('/', {
            templateUrl: '/views/dashboard_DE.html'
          }).
          when('/anmelden', {
            templateUrl: '/views/auth_DE.html',
            controller: 'AuthController'
          }).
          when('/zuruecksetzen', {
            templateUrl: '/views/auth_DE.html',
            controller: 'ResetPasswordController'
          }).
          when('/passwortbestaetigen', {
            templateUrl: '/views/auth_DE.html',
            controller: 'ResetPasswordConfirmController'
          }).
          when('/bestaetigen', {
            templateUrl: '/views/auth_DE.html',
            controller: 'ConfirmRegistrationController'
          }).
          when('/bestaetigungscode', {
            templateUrl: '/views/auth_DE.html',
            controller: 'ResendConfirmationController'
          }).
          /*
           * Dashboard
           */
          when('/dashboard', {
            templateUrl: '/views/dashboard_DE.html'
          }).
          /*
           * Stores
           */
          when(
          '/store', {
            templateUrl: '/views/store.html'
          }).
          when('/store/pictures', {
            templateUrl: '/views/store/pictures.html'
          }).
          when('/store/code', {
            templateUrl: '/views/store/code.html'
          }).
          /*
           * Coupons
           */
          when('/coupons', {
            templateUrl: '/views/coupons.html'
          }).
          when('/coupons/inactive', {
            templateUrl: '/views/coupon/inactive.html'
          }).
          when('/coupons/invalid', {
            templateUrl: '/views/coupon/invalid.html'
          }).
          when('/coupons/add', {
            templateUrl: '/views/coupon/add.html'
          }).
          /*
           * Stamps
           */
          when('/stampcards', {
            templateUrl: '/views/stampcards.html'
          }).
          when('/stampcardsInactive', {
            templateUrl: '/views/stampcard/stampcardsInactive.html'
          }).
          when('/stampcardsInvalid', {
            templateUrl: '/views/stampcard/stampcardsInvalid.html'
          }).
          when('/stampcards/add', {
            templateUrl: '/views/stampcard/addStampCard.html'
          }).
          /*
           * Specials
           */
          when('/specialoffers', {
            templateUrl: '/views/specialoffers.html'
          }).
          when('/specialoffersInactive', {
            templateUrl: '/views/specialoffer/specialoffersInactive.html'
          }).
          when('/specialoffersInvalid', {
            templateUrl: '/views/specialoffer/specialoffersInvalid.html'
          }).
          when('/specialoffers/add', {
            templateUrl: '/views/specialoffer/addSpecialOffers.html'
          }).
          /*
           * Help
           */
          when('/help', {
            templateUrl: '/views/help.html'
          }).
          /*
           * Settings
           */
          when('/settings', {
            templateUrl: '/views/settings.html'
          }).
          /*
           * Account
           */
          when('/konto', {
            templateUrl: '/views/account_DE.html'
          }).
          when('/konto/email', {
            templateUrl: '/views/accountEmail_DE.html'
          }).
          when('/konto/passwort', {
            templateUrl: '/views/accountPassword_DE.html'
          }).
          when('/konto/name', {
            templateUrl: '/views/accountName_DE.html'
          }).
          when('/konto/loeschen', {
            templateUrl: '/views/accountDelete_DE.html'
          }).
          /*
           * otherwise
           */
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

