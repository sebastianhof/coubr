define(['angular'], function (angular) {
  'use strict';

  /**
   * @ngdoc service
   * @name coubrBusinessApp.Store
   * @description
   * # Store
   * Service in the coubrBusinessApp.
   */
  angular.module('coubrBusinessApp.services.Store', [])
	.service('Store', function () {

      /*****************************
       * Store Types
       *****************************/

      var types = function () {

        return [
          {id: 'food', name: 'Food Establishment'}
        ];

      };

      /*****************************
       * Store Categories
       *****************************/

      var categories = function (typeId) {

        if (typeId == 'food') {

          return [
            {id: 'bakery', name: 'Bakery'},
            {id: 'bar', name: 'Bar and Pub'},
            {id: 'brewery', name: 'Brewery'},
            {id: 'cafe', name: 'Cafe'},
            {id: 'fastfood', name: 'Fast Food Restaurant'},
            {id: 'ice', name: 'Ice Cream'},
            {id: 'restaurant', name: 'Restaurant'},
            {id: 'winery', name: 'Winery'}
          ];

        }

      };

      /*****************************
       * Store Subcategories
       *****************************/

      var subcategories = function (categoryId) {

        if (categoryId == 'restaurant') {

          return [
            {id: 'asian', name: 'Asian'},
            {id: 'french', name: 'French'},
            {id: 'german', name: 'German'},
            {id: 'italian', name: 'Italian'}
          ];

        }

      };

      return {
        types: types,
        categories: categories,
        subcategories: subcategories
      }

	});
});
