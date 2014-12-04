'use strict';

describe('Service: coupon', function () {

  // load the service's module
  beforeEach(module('coubrBusinessApp'));

  // instantiate service
  var coupon;
  beforeEach(inject(function (_coupon_) {
    coupon = _coupon_;
  }));

  it('should do something', function () {
    expect(!!coupon).toBe(true);
  });

});
