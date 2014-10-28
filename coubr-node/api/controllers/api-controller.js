"use strict"

module.exports = function(model) {

var exploreCoupon = function(coupon) {
  var base64url = require('base64-url');

  return {
    ci: base64url.encode(coupon._id.toString()),
    ct: coupon.title,
  };

}

var exploreStore = function(geo) {
  var base64url = require('base64-url');

  var c = [];
  // TODO add coupons

  return {
    si: base64url.encode(geo.obj._id.toString()),
    sn: geo.obj.name,
    st: geo.obj.type,
    sc: geo.obj.category,
    ss: geo.obj.subcategory,
    lt: geo.obj.latitude,
    lg: geo.obj.longitude,
    c: c,
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
    ai: coupon.amountIssued,
  };

};

var storeJSON = function(store) {
  var base64url = require('base64-url');

  var co = [];
  // TODO coupons

  return {
    i: base64url.encode(store._id.toString()),
    n: store.name,
    d: store.description,
    t: store.type,
    c: store.category,
    s: store.subcategory,
    lt: store.latitude,
    lg: store.longitude,
    as: store.street,
    ap: store.postalCode,
    ac: store.location,
    ct: store.phone,
    ce: store.email,
    cw: store.website,
    co: co,
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

      if (err) { res.status(500).json(error("50000")); return; }

      if (!stores) stores = [];

      res.json(explore(stores));

    });

  },
  store: function(req, res) {
    var base64url = require('base64-url');
    var id = base64url.decode(req.params.id);

    model.Store.findOne({ '_id': id }, function (err, store) {

      if (err) { res.status(500).json(error("50000")); return; }

      if (!store) { res.status(400).json(error("10001")); return; }

      res.json(storeJSON(store));

    });

  },
  redeemCoupon: function(req, res) {
    var base64url = require('base64-url');
    var id = base64url.decode(req.params.id);

    model.Store.findOne({ '_id': id }, function (err, coupon) {

      if (err) { res.status(500).json(error("50000")); return; }

      if (!coupon) { res.status(400).json(error("10002")); return; }

      // TODO get stores

      // store id
      // store code

      res.json({ code: 'success'});

    });

  }
};

};
