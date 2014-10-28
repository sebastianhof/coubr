'use strict';

module.exports = function(app, passport, controller) {

  var auth = function (req,res,next) {
    if (req.isAuthenticated()) {
      next();
    } else {
      res.redirect('http://business.coubr.de/#/login');
    }
  }

  /*
   * authentication
   */
  app.post('/login', passport.authenticate('local', { successRedirect: '/' } ));

  app.get('/logout', auth, function(req, res) {
    req.logout();
    res.redirect('/');
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

  // get
  app.get('/', auth, function(req, res) {
      res.render('app.html');
  });

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
  app.delete('/account', auth, function(req, res) {
    controller.account.delete(req, res);
  });

  /*
   * store
   */

  // get
  app.get('/stores', auth, function(req, res) {
    controller.store.getAll(req, res);
  });

  app.get('/stores/details', auth, function(req, res) {
    controller.store.getAllDetails(req, res);
  });

  app.get('/store/:id', auth, function(req, res) {
    controller.store.get(req, res);
  });

  app.get('/store/:id/pictures', auth, function(req, res) {
    controller.store.pictures(req, res);
  });

  app.get('/store/:id/location', auth, function(req, res) {
    controller.store.location(req, res);
  });

  app.get('/store/:id/code', auth, function(req, res) {
    controller.store.code(req, res);
  });

  app.get('/store/:id/settings', auth, function(req, res) {
    controller.store.settings(req, res);
  });

  app.get('/store/:id/name',auth, function(req, res) {
    controller.store.name(req, res);
  });

  app.get('/store/:id/address', auth, function(req, res) {
    controller.store.address(req, res);
  });

  app.get('/store/:id/contact', auth, function(req, res) {
    controller.store.contact(req, res);
  });

  app.get('/store/:id/type', auth, function(req, res) {
    controller.store.type(req, res);
  });

  // post
  app.post('/store', auth, function(req, res) {
    controller.store.add(req, res);
  });

  app.post('/store/:id/location', auth, function(req, res) {
    controller.store.location(req, res);
  });

  app.post('/store/:id/name', auth, function(req, res) {
    controller.store.name(req, res);
  });

  app.post('/store/:id/address', auth, function(req, res) {
    controller.store.address(req, res);
  });

  app.post('/store/:id/contact', auth, function(req, res) {
    controller.store.contact(req, res);
  });

  app.post('/store/:id/type', auth, function(req, res) {
    controller.store.type(req, res);
  });

  // delete
  app.delete('/store/:id', auth, function(req, res) {
    controller.store.delete(req, res);
  });

  /*
   * coupon
   */

  // get
  app.get('/coupons', auth, function(req, res) {
    controller.coupon.getAll(req, res);
  });

  app.get('/coupons/active', auth, function(req, res) {
    controller.coupon.getAllActive(req, res);
  });

  app.get('/coupons/inactive', auth, function(req, res) {
    controller.coupon.getAllInactive(req, res);
  });

  app.get('/coupons/invalid', auth, function(req, res) {
    controller.coupon.getAllInvalid(req, res);
  });

  app.get('/coupon/:id', auth, function(req, res) {
    controller.coupon.get(req, res);
  });

  app.get('/coupon/:id/stores', auth, function(req, res) {
    controller.coupon.stores(req, res);
  });

  app.get('/coupon/:id/settings', auth, function(req, res) {
    controller.coupon.settings(req, res);
  });

  app.get('/coupon/:id/title', auth, function(req, res) {
    controller.coupon.title(req, res);
  });

  app.get('/coupon/:id/validTo', auth, function(req, res) {
    controller.coupon.validTo(req, res);
  });

  app.get('/coupon/:id/amount', auth, function(req, res) {
    controller.coupon.amount(req, res);
  });

  app.get('/coupon/:id/category', auth, function(req, res) {
    controller.coupon.category(req, res);
  });

  // post
  app.post('/coupon', auth, function(req, res) {
    controller.coupon.add(req, res);
  });

  app.post('/coupon/:id/stores', auth, function(req, res) {
    controller.coupon.stores(req, res);
  });

  app.post('/coupon/:id/title', auth, function(req, res) {
    controller.coupon.title(req, res);
  });

  app.post('/coupon/:id/validTo', auth, function(req, res) {
    controller.coupon.validTo(req, res);
  });

  app.post('/coupon/:id/amount', auth, function(req, res) {
    controller.coupon.amount(req, res);
  });

  app.post('/coupon/:id/category', auth, function(req, res) {
    controller.coupon.category(req, res);
  });

  app.post('/coupon/:id/activate', auth, function(req, res) {
    controller.coupon.activate(req, res);
  });

  app.post('/coupon/:id/deactivate', auth, function(req, res) {
    controller.coupon.deactivate(req, res);
  });

  // delete
  app.delete('/coupon/:id', auth, function(req, res) {
    controller.coupon.delete(req, res);
  });

  // feedback
  app.post('/feedback', auth, function(req, res) {
    controller.service.feedback(req, res);
  });

};
