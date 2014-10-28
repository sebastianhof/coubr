'use strict';

module.exports = function(app, controller) {

  app.post('/explore', function(req, res) {
    controller.api.explore(req, res);
  });

  app.get('/store/:id', function(req, res) {
    controller.api.store(req, res);
  });

  app.post('/coupon/:id/redeem', function(req, res) {
    controller.api.redeemCoupon(req, res);
  });

};
