/************************************
*
* Sebastian Hof CONFIDENTIAL
* __________________________
*
* Copyright 2014. Sebastian Hof
* All Rights Reserved.
*
************************************/

'use strict'

module.exports = function(model) {

  // helper
  var status = function(coupon) {
    var today = new Date();

    if ((coupon.amount - coupon.amountRedeemed > 0) && coupon.validTo > today) {

      if (coupon.activated) {
        return 'active';
      } else {
        return 'inactive';
      }

    } else {
        return 'invalid';
    }

  }

  // objects to json
  var couponJSON = function(coupon) {
    var base64url = require('base64-url');

    return {
      couponId: base64url.encode(coupon._id.toString()),
      title: coupon.title,
      status: status(coupon),
    };

  };

  var couponDetails = function(coupon) {
    var base64url = require('base64-url');

    return {
      couponId: base64url.encode(coupon._id.toString()),
      title: coupon.title,
      description: coupon.description,
      category: coupon.category,
      validTo: coupon.validTo, // convert to json date
      amount: coupon.amount,
      amountRedeemed: coupon.amountRedeemed,
      status: status(coupon),
      // stores: [],
    };

  };

  var storeJSON = function(store) {
    var base64url = require('base64-url');

    return {
      storeId: base64url.encode(store._id.toString()),
      name: store.name,
    };

  }

  var couponStores = function(coupon, stores) {
    var base64url = require('base64-url');

    var storeJSONs = [];
    stores.forEach(function(entry) {
      storeJSONs.push(storeJSON(entry));
    });

    return {
      couponId: base64url.encode(coupon._id.toString()),
      stores: storeJSONs,
    };

  };

  var couponSettings = function(coupon) {
    var base64url = require('base64-url');

    return {
      couponId: base64url.encode(coupon._id.toString()),
      title: coupon.title,
      description: coupon.description || 'no description',
      category: coupon.category,
      validTo: coupon.validTo, // convert to json date
      amount: coupon.amount,
      amountRedeemed: coupon.amountRedeemed,
      status: status(coupon),
    };

  };

  var couponTitle = function(coupon) {
    var base64url = require('base64-url');

    return {
      couponId: base64url.encode(coupon._id.toString()),
      title: coupon.title,
      description: coupon.description,
    };

  };

  var couponValidTo = function(coupon) {
    var base64url = require('base64-url');

    return {
      couponId: base64url.encode(coupon._id.toString()),
      validTo: coupon.validTo, // convert to json date
    };

  };

  var couponAmount = function(coupon) {
    var base64url = require('base64-url');

    return {
      couponId: base64url.encode(coupon._id.toString()),
      amount: coupon.amount,
      amountRedeemed: coupon.amountRedeemed,
    };

  };

  var couponCategory = function(coupon) {
    var base64url = require('base64-url');

    return {
      couponId: base64url.encode(coupon._id.toString()),
      category: coupon.category,
    };

  };

  var error = function(code) {
    return {
      code: code
    };
  };

  return {
    add: function(req, res) {
      // validation
      req.checkBody('title').notEmpty();
      req.checkBody('category').isCouponCategory();
      req.checkBody('validTo').notEmpty().isDate().isAfter(new Date());
      req.checkBody('activated').notEmpty();
      req.checkBody('amount').notEmpty().isInt();

      if (req.validationErrors()) {
        res.status(400).json(error("40099"));
        return;
      }

      // sanitize
      req.sanitize('title').trim();
      req.sanitize('title').escape();
      req.sanitize('description').trim();
      req.sanitize('description').escape();
      req.sanitize('validTo').toDate();
      req.sanitize('activated').toBoolean();
      req.sanitize('amount').toInt();

      var owner = req.user;
      var data = req.body;

      var coupon = new model.Coupon();
      coupon.owner = owner._id;
      coupon.title = data.title;
      coupon.description = data.description;
      coupon.category = data.category;

      require('datejs');
      coupon.validTo = data.validTo.set( { hour: 23, minute: 59, second: 59 });
      coupon.activated = data.activated;
      coupon.amount = data.amount;

      // stores
      var storeIds = [];
      var base64url = require('base64-url');
      // convert encoded ids to mongo id
      data.stores.forEach(function(entry) {
        storeIds.push(base64url.decode(entry));
      });

      // find stores
      model.Store.find({ '_id': {$in : storeIds}, 'owner': owner._id } , function (err, stores) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        // set stores
        coupon.stores = [];
        stores.forEach(function(entry) {
          coupon.stores.push(entry._id);
        });

        // save coupon
        coupon.save(function (err) {
          if (err) { console.log(err); res.status(500).json(error("50000")); return; }

          // update store
          model.Store.update( {'_id': { $in: storeIds }}, { $addToSet: { 'coupons': coupon._id } }, { multi: true }, function (err) {

            // return
            res.json(couponJSON(coupon));

          });

        });

      });

    },
    getAll: function(req, res) {
      var owner = req.user;

      model.Coupon.find({ 'owner': owner._id }, function (err, coupons) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        var data = {};
        data.coupons = [];

        coupons.forEach(function(entry) {


          data.coupons.push(couponJSON(entry));

        });

        res.json(data);
      });

    },
    getAllActive: function(req, res) {
      var owner = req.user;

      var today = new Date();
      model.Coupon.find({ 'owner': owner._id, 'activated': true, 'validTo': { $gte: today }}, function (err, coupons) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        var data = {};
        data.coupons = [];

        coupons.forEach(function(entry) {

          // filter as no aggregation is applied
          if ((entry.amount - entry.amountRedeemed) > 0) {
            data.coupons.push(couponDetails(entry));
          }

        });

        res.json(data);
      });

    },

    getAllInactive: function(req, res) {
      var owner = req.user;

      model.Coupon.find({ 'owner': owner._id, 'activated': false, 'validTo': { $gte: new Date() }}, function (err, coupons) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        var data = {};
        data.coupons = [];

        coupons.forEach(function(entry) {

          // filter as no aggregation is applied
          if ((entry.amount - entry.amountRedeemed) > 0) {
            data.coupons.push(couponDetails(entry));
          }

        });

        res.json(data);
      });

    },
    getAllInvalid: function(req, res) {
      var owner = req.user;

      model.Coupon.find({ 'owner': owner._id, 'validTo': { $lt: new Date() }}, function (err, coupons) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        var data = {};
        data.coupons = [];

        coupons.forEach(function(entry) {

          // filter as no aggregation is applied
          if ((entry.amount - entry.amountRedeemed) <= 0) {
            data.coupons.push(couponDetails(entry));
          }

        });

        res.json(data);
      });

    },
    get: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Coupon.findOne({ '_id': id, 'owner': owner._id }, function (err, coupon) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!coupon) { res.status(400).json(error("40010")); return; }

        res.json(couponDetails(coupon));

      });

    },
    stores: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Coupon.findOne({ '_id': id, 'owner': owner._id }, function (err, coupon) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!coupon) { res.status(400).json(error("40010")); return; }

        if (req.body && req.method == 'POST') {

          // stores
          var data = req.body;

          var storeIds = [];
          var base64url = require('base64-url');
          // convert encoded ids to mongo id
          data.stores.forEach(function(entry) {
            storeIds.push(base64url.decode(entry));
          });

          // find stores
          model.Store.find({ '_id': {$in : storeIds}, 'owner': owner._id } , function (err, stores) {

            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            // set stores
            coupon.stores = [];
            stores.forEach(function(entry) {
              coupon.stores.push(entry._id);
            });

            // save coupon
            coupon.save(function (err) {
              if (err) { console.log(err); res.status(500).json(error("50000")); return; }

              // remove from all stores
              model.Store.update( { 'owner': owner._id }, { $pull: { 'coupons': coupon._id } }, { multi: true }, function (err) {
                if (err) { console.log(err); res.status(500).json(error("50000")); return; }

                 // update store
                model.Store.update( {'_id': { $in: storeIds }, 'owner': owner._id }, { $addToSet: { 'coupons': coupon._id } }, { multi: true }, function (err) {
                  if (err) { console.log(err); res.status(500).json(error("50000")); return; }

                  // return
                  res.json(couponJSON(coupon));

                });

              });

            });

          });

        } else {

          model.Store.find({ '_id': {$in : coupon.stores}, 'owner': owner._id } , function (err, stores) {

            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            res.json(couponStores(coupon, stores));

          });

        }


      });

    },
    settings: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Coupon.findOne({ '_id': id, 'owner': owner._id }, function (err, coupon) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!coupon) { res.status(400).json(error("40010")); return; }

        res.json(couponSettings(coupon));

      });

    },
    title: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Coupon.findOne({ '_id': id, 'owner': owner._id }, function (err, coupon) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!coupon) { res.status(400).json(error("40010")); return; }

        if (req.body && req.method == 'POST') {
          // validation
          req.checkBody('title').notEmpty();

          if (req.validationErrors()) {
            res.status(400).json(error("40099"));
            return;
          }

          // sanitize
          req.sanitize('title').trim();
          req.sanitize('title').escape();
          req.sanitize('description').trim();
          req.sanitize('description').escape();

          var data = req.body;

          coupon.title = data.title;
          coupon.description = data.description;

          coupon.save(function (err) {
            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            res.json("ok");
          });

        } else {

          res.json(couponTitle(coupon));

        }

      });

    },
    validTo: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Coupon.findOne({ '_id': id, 'owner': owner._id }, function (err, coupon) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!coupon) { res.status(400).json(error("40010")); return; }

        if (req.body && req.method == 'POST') {
          // validation
          req.checkBody('validTo').notEmpty().isDate().isAfter(new Date());

          if (req.validationErrors()) {
            res.status(400).json(error("40099"));
            return;
          }

          // sanitize
          req.sanitize('validTo').toDate();

          var data = req.body;

          require('datejs');
          coupon.validTo = data.validTo.set( { hour: 23, minute: 59, second: 59 });

          coupon.save(function (err) {
            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            res.json("ok");
          });

        } else {

          res.json(couponValidTo(coupon));

        }

      });

    },
    amount: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Coupon.findOne({ '_id': id, 'owner': owner._id }, function (err, coupon) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!coupon) { res.status(400).json(error("40010")); return; }

        if (req.body && req.method == 'POST') {
          // validation
          req.checkBody('amount').notEmpty().isInt();

          if (req.validationErrors()) {
            res.status(400).json(error("40099"));
            return;
          }

          // sanitize
          req.sanitize('amount').toInt();

          var data = req.body;

          coupon.amount = data.amount;

          coupon.save(function (err) {
            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            res.json("ok");
          });

        } else {

          res.json(couponAmount(coupon));

        }

      });

    },
    category: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Coupon.findOne({ '_id': id, 'owner': owner._id }, function (err, coupon) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!coupon) { res.status(400).json(error("40010")); return; }

        if (req.body && req.method == 'POST') {
          // validation
          req.checkBody('category').isCouponCategory();

          if (req.validationErrors()) {
            res.status(400).json(error("40099"));
            return;
          }

          var data = req.body;

          coupon.category = data.category;

          coupon.save(function (err) {
            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            res.json("ok");
          });

        } else {

          res.json(couponCategory(coupon));

        }

      });
    },
    activate: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Coupon.findOne({ '_id': id, 'owner': owner._id }, function (err, coupon) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!coupon) { res.status(400).json(error("40010")); return; }

        coupon.activated = true;
        coupon.save(function (err) {
          if (err) { console.log(err); res.status(500).json(error("50000")); return; }

          res.json("ok");
        });

      });

    },
    deactivate: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Coupon.findOne({ '_id': id, 'owner': owner._id }, function (err, coupon) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!coupon) { res.status(400).json(error("40010")); return; }

        coupon.activated = false;
        coupon.save(function (err) {
          if (err) { console.log(err); res.status(500).json(error("50000")); return; }

          res.json("ok");
        });

      });

    },
    delete: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Coupon.findOne({ '_id': id, 'owner': owner._id }, function (err, coupon) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!coupon) { res.status(400).json(error("40010")); return; }

        // remove from all stores
        model.Store.update( { 'owner': owner._id }, { $pull: { 'coupons': coupon._id } }, { multi: true }, function (err) {
          if (err) { console.log(err); res.status(500).json(error("50000")); return; }

          // remove coupon
          model.Coupon.remove({ '_id': id, 'owner': owner._id }, function (err) {

            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            res.json("ok");

          });

        });

      });

    },

  };

};
