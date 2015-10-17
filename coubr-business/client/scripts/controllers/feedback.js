define(['angular', 'angular-bootstrap'], function (angular) {
  'use strict';

  /**
   * @ngdoc function
   * @name coubrBusinessApp.controller:FeedbackCtrl
   * @description
   * # FeedbackCtrl
   * Controller of the coubrBusinessApp
   */
  angular.module('coubr.controllers.FeedbackCtrl', ['ui.bootstrap'])
    .controller('FeedbackController', ['$scope', '$modal', function ($scope, $modal) {

      $scope.open = function (size) {

        var modalInstance = $modal.open({
          templateUrl: '/views/feedback_DE.html',
          controller: 'FeedbackInstanceController',
          size: size
        });

      };

    }])
    .controller('FeedbackInstanceController', ['$scope', '$modalInstance', '$location', '$window', function ($scope, $modalInstance, $location, $window) {

      $scope.data = {};
      $scope.data.location = $location.absUrl();
      $scope.data.userAgent = $window.navigator.userAgent;

      $scope.cancel = function () {
        $modalInstance.dismiss('cancel');
      };

    }]);

});
