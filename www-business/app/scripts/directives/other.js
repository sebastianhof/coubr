define(['angular'], function (angular) {
  'use strict';

  /**
   * @ngdoc directive
   * @name coubrBusinessApp.directive:other
   * @description
   * # other
   */
  angular.module('coubrBusinessApp.directives.Other', [])
    .directive('cbrstoremap', function () {

      return {
        restrict: 'EA',
        controller: function ($scope, $element, Coubr) {

          var drop = function (event) {
            $scope.data.latitude = event.latLng.lat();
            $scope.data.longitude = event.latLng.lng();
          };

          var init = function (position) {

            $scope.data.latitude = position.lat;
            $scope.data.longitude = position.lng;

            var mapOptions = {
              center: position,
              zoom: 15
            };
            var map = new google.maps.Map($element[0], mapOptions);

            var marker = new google.maps.Marker({
              icon: {
                url: 'http://business.coubr.de/static/images/icons/marker-64.png'
              },
              draggable: true,
              animation: google.maps.Animation.DROP,
              position: position,
              map: map
            });

            google.maps.event.addListener(marker, 'dragend', drop);

          }

          $scope.$on('success', function (event, success) {

            if (success.data.latitude && success.data.longitude) {
              var position = {
                lat: parseFloat(success.data.latitude),
                lng: parseFloat(success.data.longitude)
              };
              init(position);
            }

          });

        }
      }

    });
});
