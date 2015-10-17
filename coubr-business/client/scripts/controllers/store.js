define(['angular'], function (angular) {
  'use strict';

  /**
   * @ngdoc function
   * @name coubrBusinessApp.controller:StoreCtrl
   * @description
   * # StoreCtrl
   * Controller of the coubrBusinessApp
   */
  angular.module('coubr.controllers.StoreCtrl', [])

    .controller('StoreTypeController', ['$scope', 'Store', function ($scope, Store) {

      $scope.types = Store.types();

      $scope.selectType = function (id) {
        $scope.data.type = id;
        $scope.data.category = null;
        $scope.data.subcategory = null;
        $scope.categories = null;
        $scope.categories = Store.categories(id);
      };

      $scope.selectCategory = function (id) {
        $scope.data.category = id;
        $scope.data.subcategory = null;
        $scope.subcategories = null;
        $scope.subcategories = Store.subcategories(id);
      };

      $scope.selectSubcategory = function (id) {
        $scope.data.subcategory = id;
      };

      $scope.$on('success', function (event, success) {

        if (success.data && success.data.type) {
          $scope.selectType(success.data.type);

          if (success.data.category) {
            $scope.selectCategory(success.data.category);
          }

          if (success.data.subcategory) {
            $scope.selectSubcategory(success.data.subcategory);
          }

        }

      });

    }]);
});
