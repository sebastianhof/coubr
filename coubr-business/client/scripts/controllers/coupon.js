define(['angular'], function (angular) {
  'use strict';

  /**
   * @ngdoc function
   * @name coubrBusinessApp.controller:CouponCtrl
   * @description
   * # CouponCtrl
   * Controller of the coubrBusinessApp
   */
  angular.module('coubr.controllers.CouponCtrl', [])
    .controller('CouponCategoryController', ['$scope', 'Coupon', function ($scope, Coupon) {

      $scope.categories = Coupon.categories('coupon');

      $scope.hasCategories = function () {
        return $scope.categories != null && $scope.categories.length > 0;
      }

      $scope.selectType = function (id) {
        $scope.data.type = id;
        $scope.data.category = null;
        $scope.categories = null;
        $scope.categories = Coupon.categories(id);
      };

      $scope.selectCategory = function (id) {
        $scope.data.category = id;
      };

      $scope.$on('success', function (event, success) {

        if (success.data && success.data.category) {
          $scope.selectCategory(success.data.category);
        }

      });

    }])
    .controller('CouponActivationController', ['$scope', 'Coubr', function ($scope, Coubr) {

      $scope.isActivated = function () {
        return $scope.data.status == 'active';
      }

      $scope.isDeactivated = function () {
        return $scope.data.status == 'inactive';
      }

      $scope.activate = function () {

        Coubr.post(Coubr.transformURI('/b/coupon/:couponId/activate')).then(function (success) {
          $scope.fetch();
        });

      }

      $scope.deactivate = function () {

        Coubr.post(Coubr.transformURI('/b/coupon/:couponId/deactivate')).then(function (success) {
          $scope.fetch();
        });

      }


    }])
    .controller('CouponStoreController', ['$scope', 'Coupon', 'Coubr', function ($scope, Coupon, Coubr) {

      $scope.stores = {};

      if (!$scope.data.stores) {
        $scope.data.stores = [];
      }

      $scope.hasStores = function () {
        // use bind
        return $scope.stores.stores != null && $scope.stores.stores.length > 0;
      }

      $scope.isStoreSelected = function (storeId) {
        return $scope.data.stores.indexOf(storeId) >= 0;
      }

      $scope.selectStore = function (storeId) {
        if ($scope.isStoreSelected(storeId)) {
          var idx = $scope.data.stores.indexOf(storeId);

          $scope.data.stores.splice(idx, 1);
        } else {
          $scope.data.stores.push(storeId);
        }
      };

      $scope.selectAllStores = function () {
        $scope.data.stores = [];

        $scope.stores.stores.forEach(function (store) {
          $scope.data.stores.push(store.storeId);
        });
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

      Coubr.get('/b/stores').then(function (success) {

        if (success.data) {

          if (angular.isObject(success.data)) {
            Object.getOwnPropertyNames(success.data).forEach(function (entry) {

              $scope.stores[entry] = success.data[entry];

            });
          }

        }

      });


    }])
    .controller('CouponValidToDateController', ['$scope', 'Coubr', function ($scope, Coubr) {

      $scope.today = Date.now();

      Coubr.get(Coubr.transformURI('coupon/:couponId/validTo')).then(function (success) {

        $scope.data.validTo = new Date(success.data.validTo);

      });

      // $scope.$on('success', function (event, success) {
      //
      //     if (success.data && success.data.validTo) {
      //         $scope.data.validTo = new Date(success.data.validTo);
      //     }
      //
      // });


    }]);

});
