define(['angular'], function (angular) {
  'use strict';

  /**
   * @ngdoc function
   * @name coubrBusinessApp.controller:OtherCtrl
   * @description
   * # OtherCtrl
   * Controller of the coubrBusinessApp
   */
  angular.module('coubr.controllers.OtherCtrl', [])
    .controller('DateController', ['$scope', function ($scope) {
      $scope.today = Date.now();
    }]);
});
