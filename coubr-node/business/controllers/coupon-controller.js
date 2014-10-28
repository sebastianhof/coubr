'use strict'

module.exports = function(model) {

  // objects to json
  var coupon = function(coupon) {
    var base64url = require('base64-url');

    return {
      couponId: base64url.encode(coupon._id.toString()),
      title: coupon.title,
      status: 'active' // TODO set status
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
      amountIssued: coupon.amountIssued,
      status: 'active', // TODO set status,
      // TODO stores coupons
    };

  };

  var couponStores = function(coupon) {

  };

  var couponSettings = function(coupon) {

  };

  var couponTitle = function(coupon) {

  };

  var couponValidTo = function(coupon) {

  };

  var couponAmount = function(coupon) {

  };

  var couponCategory = function(coupon) {

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

      var stores = [];
      data.stores.each(function(entry) {

        // TODO search for store and add information

      });

      coupon = new model.Coupon();
      coupon.owner = owner.id;
      coupon.title = data.title;
      coupon.description = data.description;
      coupon.category = data.category;

      require('datejs');
      coupon.validTo = data.validTo.set( { hour: 23, minute: 59, second: 59 });
      coupon.activated = data.activated;
      coupon.amount = data.amount;

      // TODO stores coupons

      coupon.save(function (err) {
        if (err) { res.status(500).json(error("50000")); return; }

        res.json(coupon(coupon));
      });


    },
    getAll: function(req, res) {
      var owner = req.user;

      model.Coupon.find({ 'owner': owner.id }, function (err, coupons) {

        if (err) { res.status(500).json(error("50000")); return; }

        var data = {};
        data.coupons = [];

        coupons.forEach(function(entry) {

          // TODO Filtering
          data.coupons.push(coupon(entry));

        });

        res.json(data);
      });

    },
    getAllActive: function(req, res) {
      var owner = req.user;

      model.Coupon.find({ 'owner': owner.id }, function (err, coupons) {

        if (err) { res.status(500).json(error("50000")); return; }

        var data = {};
        data.coupons = [];

        coupons.forEach(function(entry) {

          // TODO Filtering
          data.coupons.push(couponDetails(entry));

        });

        res.json(data);
      });

    },

    getAllInactive: function(req, res) {
      var owner = req.user;

      model.Coupon.find({ 'owner': owner.id }, function (err, coupons) {

        if (err) { res.status(500).json(error("50000")); return; }

        var data = {};
        data.coupons = [];

        coupons.forEach(function(entry) {

          // TODO Filtering
          data.coupons.push(couponDetails(entry));

        });

        res.json(data);
      });

    },
    getAllInvalid: function(req, res) {
      var owner = req.user;

      model.Coupon.find({ 'owner': owner.id }, function (err, coupons) {

        if (err) { res.status(500).json(error("50000")); return; }

        var data = {};
        data.coupons = [];

        coupons.forEach(function(entry) {

          // TODO Filtering
          data.coupons.push(couponDetails(entry));

        });

        res.json(data);
      });

    },
    get: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Coupon.findOne({ '_id': id, 'owner': owner.id }, function (err, coupon) {

        if (err) { res.status(500).json(error("50000")); return; }

        if (!coupon) { res.status(400).json(error("40010")); return; }

        res.json(couponDetails(coupon));

      });

    },
    stores: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Coupon.findOne({ '_id': id, 'owner': owner.id }, function (err, coupon) {

        if (err) { res.status(500).json(error("50000")); return; }

        if (!coupon) { res.status(400).json(error("40010")); return; }

        if (req.body && req.method == 'POST') {

          // TODO stores coupons

          coupon.save(function (err) {
            if (err) { res.status(500).json(error("50000")); return; }

            res.json("ok");
          });

        } else {

          res.json(couponStores(coupon));

        }


      });

    },
    settings: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Coupon.findOne({ '_id': id, 'owner': owner.id }, function (err, coupon) {

        if (err) { res.status(500).json(error("50000")); return; }

        if (!coupon) { res.status(400).json(error("40010")); return; }

        res.json(couponSettings(coupon));

      });

    },
    title: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Coupon.findOne({ '_id': id, 'owner': owner.id }, function (err, coupon) {

        if (err) { res.status(500).json(error("50000")); return; }

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
            if (err) { res.status(500).json(error("50000")); return; }

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

      model.Coupon.findOne({ '_id': id, 'owner': owner.id }, function (err, coupon) {

        if (err) { res.status(500).json(error("50000")); return; }

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
            if (err) { res.status(500).json(error("50000")); return; }

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

      model.Coupon.findOne({ '_id': id, 'owner': owner.id }, function (err, coupon) {

        if (err) { res.status(500).json(error("50000")); return; }

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
            if (err) { res.status(500).json(error("50000")); return; }

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

      model.Coupon.findOne({ '_id': id, 'owner': owner.id }, function (err, coupon) {

        if (err) { res.status(500).json(error("50000")); return; }

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
            if (err) { res.status(500).json(error("50000")); return; }

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

      model.Coupon.findOne({ '_id': id, 'owner': owner.id }, function (err, coupon) {

        if (err) { res.status(500).json(error("50000")); return; }

        if (!coupon) { res.status(400).json(error("40010")); return; }

        coupon.activated = true;
        coupon.save(function (err) {
          if (err) { res.status(500).json(error("50000")); return; }

          res.json("ok");
        });

      });

    },
    deactivate: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Coupon.findOne({ '_id': id, 'owner': owner.id }, function (err, coupon) {

        if (err) { res.status(500).json(error("50000")); return; }

        if (!coupon) { res.status(400).json(error("40010")); return; }

        coupon.activated = false;
        coupon.save(function (err) {
          if (err) { res.status(500).json(error("50000")); return; }

          res.json("ok");
        });

      });

    },
    delete: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Coupon.findOne({ '_id': id, 'owner': owner.id }, function (err, coupon) {

        if (err) { res.status(500).json(error("50000")); return; }

        if (!coupon) { res.status(400).json(error("40010")); return; }

        // TODO delete + delete offers -> delete set flag
        // TODO inform customers

      });

    },

  };

};
