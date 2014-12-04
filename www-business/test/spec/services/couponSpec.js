/*jshint unused: vars */
define(['angular', 'angular-mocks', 'app'], function(angular, mocks, app) {
  'use strict';

  describe('Service: Coupon', function () {

    // load the service's module
    beforeEach(module('coubrBusinessApp.services.Coupon'));

    // instantiate service
    var Coupon;
    beforeEach(inject(function (_Coupon_) {
      Coupon = _Coupon_;
    }));

    it('should do something', function () {
      expect(!!Coupon).toBe(true);
    });

  });
});
