define(['angular', 'angular-bootstrap'], function (angular) {
  'use strict';

  /**
   * @ngdoc function
   * @name coubrBusinessApp.controller:LoginCtrl
   * @description
   * # FeedbackCtrl
   * Controller of the coubrBusinessApp
   */
  angular.module('coubr.controllers.AuthCtrl', ['ui.bootstrap'])
    .controller('AuthController', ['$scope', '$modal', function ($scope, $modal) {

      $scope.open = function (size) {

        var modalInstance = $modal.open({
          templateUrl: '/views/auth_content_DE.html',
          controller: 'AuthInstanceController',
          size: size,
          backdrop: false,
          keyboard: false
        });

      };

      $scope.open();

    }])

    .controller('ResetPasswordController', ['$scope', '$modal', function ($scope, $modal) {

      $scope.open = function (size) {

        var modalInstance = $modal.open({
          templateUrl: '/views/auth_resetPassword_DE.html',
          controller: 'AuthInstanceController',
          size: size,
          backdrop: false,
          keyboard: false
        });

      };

      $scope.open();

    }])
    .controller('ResetPasswordConfirmController', ['$scope', '$modal', function ($scope, $modal) {

      $scope.open = function (size) {

        var modalInstance = $modal.open({
          templateUrl: '/views/auth_resetPasswordConfirm_DE.html',
          controller: 'AuthInstanceController',
          size: size,
          backdrop: false,
          keyboard: false
        });

      };

      $scope.open();

    }])
    .controller('ConfirmRegistrationController', ['$scope', '$modal', function ($scope, $modal) {

      $scope.open = function (size) {

        var modalInstance = $modal.open({
          templateUrl: '/views/auth_confirmRegistration_DE.html',
          controller: 'AuthInstanceController',
          size: size,
          backdrop: false,
          keyboard: false
        });

      };

      $scope.open();

    }])
    .controller('ResendConfirmationController', ['$scope', '$modal', function ($scope, $modal) {

      $scope.open = function (size) {

        var modalInstance = $modal.open({
          templateUrl: '/views/auth_resendConfirmation_DE.html',
          controller: 'AuthInstanceController',
          size: size,
          backdrop: false,
          keyboard: false
        });

      };

      $scope.open();

    }])
    .controller('AuthInstanceController', ['$scope', '$modalInstance', '$location', '$window', function ($scope, $modalInstance, $location, $window) {

      $scope.data = {};

      $scope.cancel = function () {
        $modalInstance.dismiss('cancel');
      };

      $scope.$on('$routeChangeStart', function () {
        $scope.cancel();
      });

    }])





  ;

});
