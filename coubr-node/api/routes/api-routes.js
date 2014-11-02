/************************************
*
* Sebastian Hof CONFIDENTIAL
* __________________________
*
* Copyright 2014. Sebastian Hof
* All Rights Reserved.
*
************************************/

'use strict';

module.exports = function(app, controller) {

  app.post('/explore', function(req, res) {
    controller.api.explore(req, res);
  });

  app.post('/store/:id', function(req, res) {
    controller.api.store(req, res);
  });

  app.post('/coupon/:id/redeem', function(req, res) {
    controller.api.redeemCoupon(req, res);
  });

};
