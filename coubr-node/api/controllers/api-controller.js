/************************************
*
* Sebastian Hof CONFIDENTIAL
* __________________________
*
* Copyright 2014. Sebastian Hof
* All Rights Reserved.
*
************************************/

"use strict"

module.exports = function(model) {

var exploreStore = function(geo) {
  var base64url = require('base64-url');

  return {
    si: base64url.encode(geo.obj._id.toString()),
    sn: geo.obj.name,
    st: geo.obj.type,
    sc: geo.obj.category,
    ss: geo.obj.subcategory,
    lt: geo.obj.location.coordinates[1],
    lg: geo.obj.location.coordinates[0],
    oc: geo.obj.coupons.length,
    d: geo.dis,
  };

}

var explore = function(stores) {

  var s = [];
  stores.forEach(function(entry) {
    s.push(exploreStore(entry));
  });

  return {
    s: s
  }

}

var couponJSON = function(coupon) {
  var base64url = require('base64-url');

  return {
    i: base64url.encode(coupon._id.toString()),
    t: coupon.title,
    d: coupon.description,
    c: coupon.category,
    v: coupon.validTo,
    a: coupon.amount,
    ar: coupon.amountRedeemed,
  };

};

var storeJSON = function(store, coupons) {
  var base64url = require('base64-url');

  var couponJSONs = [];
  coupons.forEach(function(entry) {
    couponJSONs.push(couponJSON(entry));
  });

  return {
    i: base64url.encode(store._id.toString()),
    n: store.name,
    d: store.description,
    t: store.type,
    c: store.category,
    s: store.subcategory,
    lt: store.location.coordinates[1],
    lg: store.location.coordinates[0],
    as: store.street,
    ap: store.postalCode,
    ac: store.place,
    ct: store.phone,
    ce: store.email,
    cw: store.website,
    co: couponJSONs,
  }

}

var error = function(code) {

  return {
    code: code
  };

};

return {
  explore: function(req, res) {
    // validation
    req.checkBody('lt').notEmpty();
    req.checkBody('lg').notEmpty();
    req.checkBody('d').notEmpty();

    if (req.validationErrors()) {
      res.status(400).json(error("10099"));
      return;
    }

    // sanitize
    req.sanitize('lt').toFloat();
    req.sanitize('lg').toFloat();
    req.sanitize('d').toFloat();

    var data = req.body;
    var point = { type : "Point", coordinates : [data.lg, data.lt] };

    // current bug in mongoose
    var EARTH_RADIUS = 6371 * 1000;

    model.Store.geoNear(point, { maxDistance: data.d / EARTH_RADIUS , spherical: true, distanceMultiplier: EARTH_RADIUS }, function (err, stores) {

      if (err) { console.log(err); res.status(500).json(error("50000")); return; }

      if (!stores) stores = [];

      res.json(explore(stores));

    });

  },
  store: function(req, res) {
    req.checkBody('id').notEmpty();

    if (req.validationErrors()) {
      res.status(400).json(error("10099"));
      return;
    }


    var base64url = require('base64-url');
    var id = base64url.decode(req.params.id);
    var data = req.body;

    model.Store.findOne({ '_id': id }, function (err, store) {

      if (err) { console.log(err); res.status(500).json(error("50000")); return; }

      if (!store) { res.status(400).json(error("10001")); return; }

      model.Coupon.find({ '_id': {$in : store.coupons} } , function (err, coupons) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        res.json(storeJSON(store, coupons));

      });

      var storeVisit = new model.StoreVisit();
      storeVisit.storeId = store._id;
      storeVisit.userId = data.id;
      storeVisit.date = new Date();
      storeVisit.save(function (err) {

        if (err) { console.log(err); return; }

      });

    });

  },
  redeemCoupon: function(req, res) {
    req.checkBody('si').notEmpty();
    req.checkBody('sc').notEmpty();
    req.checkBody('id').notEmpty();

    if (req.validationErrors()) {
      res.status(400).json(error("10099"));
      return;
    }

    var data = req.body;

    var base64url = require('base64-url');
    var id = base64url.decode(req.params.id);
    model.Coupon.findOne({ '_id': id }, function (err, coupon) {

      if (err) { console.log(err); res.status(500).json(error("50000")); return; }

      if (!coupon) { res.status(400).json(error("10002")); return; }

      var storeId = base64url.decode(data.si);
      model.Store.findOne({ '_id': storeId }, function (err, store) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!store) { res.status(400).json(error("10001")); return; }

        if (store.code != data.sc) { res.status(400).json(error("10003")); return; }

        // redeem
        model.Coupon.update( {'_id': id }, { $inc : { amountRedeemed: 1 } }, function (err) {

          if (err) { console.log(err); res.status(500).json(error("50000")); return; }

          // callback
          res.json({ code: 'success'});

          // add to coupon redemption
          var couponRedemption = new model.CouponRedemption();
          couponRedemption.couponId = coupon._id;
          couponRedemption.storeId = store._id;
          couponRedemption.userId = data.id;
          couponRedemption.date = new Date();
          couponRedemption.save(function (err) {

            if (err) { console.log(err); return; }

          });

        });

      });

    });

  }
};

};
