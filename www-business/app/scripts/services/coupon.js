define(['angular'], function (angular) {
  'use strict';

  /**
   * @ngdoc service
   * @name coubrBusinessApp.Coupon
   * @description
   * # Coupon
   * Service in the coubrBusinessApp.
   */
  angular.module('coubrBusinessApp.services.Coupon', [])
	.service('Coupon', function () {

      var categories = function (typeId) {

        if (typeId == 'coupon') {

          return [
            {id: 'default', name: 'Default'}
          ];

        }
      };

      return {
        categories: categories
      }

	});
});
