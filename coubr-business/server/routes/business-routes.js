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

module.exports = function(app, passport, controller) {

  var auth = function (req,res,next) {
    if (req.isAuthenticated()) {
      next();
    } else {
      res.redirect('/#login');
    }
  };

  /*
   * authentication
   */
  app.post('/login', passport.authenticate('local', { successRedirect: '/' } ));

  app.get('/connect', auth, function(req, res) {
    res.json("ok");
  });

  app.get('/logout', auth, function(req, res) {
    req.logout();
    res.redirect('/#/');
  });

  app.post('/resetPassword', function(req, res) {
    controller.auth.resetPassword(req, res);
  });

  app.post('/resetPasswordConfirm', function(req, res) {
    controller.auth.resetPasswordConfirm(req, res);
  });

  app.post('/register', function(req, res) {
    controller.auth.register(req, res);
  });

  app.post('/confirmRegistration', function(req, res) {
    controller.auth.confirmRegistration(req, res);
  });

  app.post('/resendConfirmation', function(req, res) {
    controller.auth.resendConfirmation(req, res);
  });

  /*
   * account
   */
  app.get('/account', function(req, res) {
    controller.account.get(req, res);
  });

  app.get('/account/name', auth, function(req, res) {
    controller.account.name(req, res);
  });

  // post
  app.post('/account/password', auth, function(req, res) {
    controller.account.password(req, res);
  });

  app.post('/account/email', auth, function(req, res) {
    controller.account.email(req, res);
  });

  app.post('/account/name', auth, function(req, res) {
    controller.account.name(req, res);
  });

  // delete
  app.post('/account/delete', auth, function(req, res) {
    controller.account.delete(req, res);
  });

  /*
   * store
   */

  // list

  app.get('/stores', auth, function(req, res) {
    controller.store.getAll(req, res);
  });

  // add

  app.post('/store', auth, function(req, res) {
    controller.store.add(req, res);
  });

  // information

  app.get('/store/:id', auth, function(req, res) {
    controller.store.get(req, res);
  });

  // pictures

  app.get('/store/:id/pictures', auth, function(req, res) {
    controller.store.pictures(req, res);
  });

  // settings

  app.get('/store/:id/name',auth, function(req, res) {
    controller.store.name(req, res);
  });

  app.post('/store/:id/name', auth, function(req, res) {
    controller.store.name(req, res);
  });

  app.get('/store/:id/category', auth, function(req, res) {
    controller.store.category(req, res);
  });

  app.post('/store/:id/category', auth, function(req, res) {
    controller.store.category(req, res);
  });

  app.get('/store/:id/address', auth, function(req, res) {
    controller.store.address(req, res);
  });

  app.post('/store/:id/address', auth, function(req, res) {
    controller.store.address(req, res);
  });

  app.get('/store/:id/contact', auth, function(req, res) {
    controller.store.contact(req, res);
  });

  app.post('/store/:id/contact', auth, function(req, res) {
    controller.store.contact(req, res);
  });

  app.get('/store/:id/location', auth, function(req, res) {
    controller.store.location(req, res);
  });

  app.post('/store/:id/location', auth, function(req, res) {
    controller.store.location(req, res);
  });

  app.post('/store/:id/close', auth, function(req, res) {
    controller.store.close(req, res);
  });

  /*
   * special offer
   */

  // list

  app.get('/store/:id/specialoffers', auth, function(req, res) {
    controller.specialoffer.getAll(req, res);
  });

  // add

  app.post('/specialoffer', auth, function(req, res) {
    controller.specialoffer.add(req, res);
  });

  // information

  app.get('/specialoffer/:id', auth, function(req, res) {
    controller.specialoffer.get(req, res);
  });

  // edit

  app.post('/specialoffer/:id', auth, function(req, res) {
    controller.specialoffer.edit(req, res);
  });

  // delete
  app.post('/specialoffer/:id/delete', auth, function(req, res) {
    controller.specialoffer.delete(req, res);
  });

  /*
   * coupon
   */

  // list

  app.get('/store/:id/coupons', auth, function(req, res) {
    controller.coupon.getAll(req, res);
  });

  // add

  app.post('/coupon', auth, function(req, res) {
    controller.coupon.add(req, res);
  });

  // information

  app.get('/coupon/:id', auth, function(req, res) {
    controller.coupon.get(req, res);
  });

  // edit

  app.post('/coupon/:id', auth, function(req, res) {
    controller.coupon.edit(req, res);
  });

  // delete
  app.post('/coupon/:id/delete', auth, function(req, res) {
    controller.coupon.delete(req, res);
  });

  /*
   * stamp card
   */

  // list

  app.get('/store/:id/stampcards', auth, function(req, res) {
    controller.stampcard.getAll(req, res);
  });

  // add

  app.post('/stampcard', auth, function(req, res) {
    controller.stampcard.add(req, res);
  });

  // information

  app.get('/stampcard/:id', auth, function(req, res) {
    controller.stampcard.get(req, res);
  });

  // edit

  app.post('/stampcard/:id', auth, function(req, res) {
    controller.stampcard.edit(req, res);
  });

  // delete
  app.post('/stampcard/:id/delete', auth, function(req, res) {
    controller.stampcard.delete(req, res);
  });

  /*
   * device
   */

  app.get('/store/:id/devices', auth, function(req, res) {
    controller.device.getAll(req, res);
  });
  app.post('/store/:id/devices/beacon', auth, function(req, res) {
    controller.device.addBeacon(req, res);
  });

  app.get('/store/:id/devices/qr.svg', auth, function(req, res) {
    controller.device.qrcode(req, res);
  });

  // feedback
  app.post('/feedback', auth, function(req, res) {
    controller.service.feedback(req, res);
  });

};
