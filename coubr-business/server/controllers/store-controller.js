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

  // object to json
  var storeJSON =  function(store) {
    var base64url = require('base64-url');

    return {
      storeId: base64url.encode(store._id.toString()),
      name: store.name
    };

  };

  var storeDetails = function(store) {
    var base64url = require('base64-url');

    return {
      storeId: base64url.encode(store._id.toString()),
      name: store.name,
      description: store.description,
      street: store.street,
      postalCode: store.postalCode,
      city: store.place,
      phone: store.phone,
      email: store.email,
      website: store.website,
      category: store.category,
      subcategory: store.subcategory,
      latitude: store.location.coordinates[1],
      longitude: store.location.coordinates[0]
    };

  };

  var storePictures = function(store) {
    var base64url = require('base64-url');

    return {
      storeId: base64url.encode(store._id.toString())
    };

  };


  var storeName = function(store) {
    var base64url = require('base64-url');

    return {
      storeId: base64url.encode(store._id.toString()),
      name: store.name,
      description: store.description
    };

  };

  var storeAddress = function(store) {
    var base64url = require('base64-url');

    return {
      storeId: base64url.encode(store._id.toString()),
      street: store.street,
      postalCode: store.postalCode,
      city: store.place
    };

  };

  var storeContact = function(store) {
    var base64url = require('base64-url');

    return {
      storeId: base64url.encode(store._id.toString()),
      phone: store.phone,
      email: store.email,
      website: store.website
    };

  };

  var storeCategory = function(store) {
    var base64url = require('base64-url');

    return {
      storeId: base64url.encode(store._id.toString()),
      category: store.category,
      subcategory: store.subcategory
    };

  };

  var storeLocation = function(store) {
    var base64url = require('base64-url');

    return {
      storeId: base64url.encode(store._id.toString()),
      latitude: store.location.coordinates[1],
      longitude: store.location.coordinates[0]
    };

  };


  var error = function(code) {

    return {
      code: code
    };

  };

  // functions
  return {
    add: function(req, res) {
      // validation
      req.checkBody('name').notEmpty();
      req.checkBody('city').notEmpty();
      req.checkBody('postalCode').notEmpty();
      req.checkBody('street').notEmpty();
      if (req.body.email && req.body.email.length > 0) req.checkBody('email').isEmail();
      if (req.body.website && req.body.website.length > 0) req.checkBody('website').isURL();
      req.checkBody('category').notEmpty().isStoreCategory('gastronomy'); // deprecated in FUTURE
      req.checkBody('subcategory').isStoreSubcategory(req.body.category);

      if (req.validationErrors()) {
        console.log(req.validationErrors());
        res.status(400).json(error("40099"));
        return;
      }

      // sanitize
      req.sanitize('name').trim()
      req.sanitize('name').escape();
      req.sanitize('description').trim();
      req.sanitize('description').escape();
      req.sanitize('city').trim();
      req.sanitize('city').escape();
      req.sanitize('postalCode').trim();
      req.sanitize('postalCode').escape();
      req.sanitize('street').trim();
      req.sanitize('street').escape();
      req.sanitize('phone').trim();
      req.sanitize('phone').escape();

      var owner = req.user;
      var data = req.body;

      var store = new model.Store();
      store.owner = owner._id;
      store.name = data.name;
      store.description = data.description;
      store.category = data.category;
      store.subcategory = data.subcategory;
      store.phone = data.phone;
      store.email = data.email;
      store.website = data.website;
      store.place = data.city;
      store.postalCode = data.postalCode;
      store.street = data.street;

      var randomString = require('random-string');
      store.code = randomString({length: 128});

      var googleConfig = require('../config/google');
      var geocoder = require('node-geocoder').getGeocoder('google','https', { apiKey: googleConfig.key } );
      var query = data.street + ', ' + data.postalCode  + ' ' + data.city;
      geocoder.geocode(query, function(err, geo) {

        if (err) { res.status(400).json(error("40008")); return; }

        if (geo.length > 0) {

          store.location = { type : "Point", coordinates : [geo[0].longitude, geo[0].latitude] };
          store.country = geo[0].countryCode;
          store.region = geo[0].stateCode;

        } else {
          res.status(400).json(error("40008"));
          return;
        }

        store.save(function (err) {
          if (err) { console.log(err); res.status(500).json(error("50000")); return; }

          res.json(storeJSON(store));
        });

      });

    },
    getAll: function(req, res) {
      var owner = req.user;

      model.Store.find({ 'owner': owner._id }, function (err, stores) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        var data = {};
        data.stores = [];

        stores.forEach(function(entry) {

          data.stores.push(storeJSON(entry));

        });

        res.json(data);
      });

    },
    get: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Store.findOne({ '_id': id, 'owner': owner._id }, function (err, store) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!store) { res.status(400).json(error("40007")); return; }

        res.json(storeDetails(store));

      });

    },
    pictures: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Store.findOne({ '_id': id, 'owner': owner._id }, function (err, store) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!store) { res.status(400).json(error("40007")); return; }

        res.json(storePictures(store));

      });

    },
    name: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Store.findOne({ '_id': id, 'owner': owner._id }, function (err, store) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!store) { res.status(400).json(error("40007")); return; }

        if (req.body && req.method == 'POST') {
          // validation
          req.checkBody('name').notEmpty();

          if (req.validationErrors()) {
            res.status(400).json(error("40099"));
            return;
          }

          // sanitize
          req.sanitize('name').trim();
          req.sanitize('name').escape();
          req.sanitize('description').trim();
          req.sanitize('description').escape();

          var data = req.body;

          store.name = data.name;
          store.description = data.description;

          store.save(function (err) {
            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            res.json("ok");
          });

        } else {

          res.json(storeName(store));

        }


      });


    },
    category: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Store.findOne({ '_id': id, 'owner': owner._id }, function (err, store) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!store) { res.status(400).json(error("40007")); return; }

        if (req.body && req.method == 'POST') {
          // validation
          req.checkBody('category').notEmpty().isStoreCategory('gastronomy'); // deprecated in FUTURE
          req.checkBody('subcategory').isStoreSubcategory(req.body.category);

          if (req.validationErrors()) {
            res.status(400).json(error("40099"));
            return;
          }

          var data = req.body;

          store.category = data.category;
          store.subcategory = data.subcategory;

          store.save(function (err) {
            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            res.json("ok");
          });

        } else {

          res.json(storeCategory(store));

        }

      });

    },
    address: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Store.findOne({ '_id': id, 'owner': owner._id }, function (err, store) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!store) { res.status(400).json(error("40007")); return; }

        if (req.body && req.method == 'POST') {
          // validation
          req.checkBody('city').notEmpty();
          req.checkBody('postalCode').notEmpty();
          req.checkBody('street').notEmpty();

          if (req.validationErrors()) {
            res.status(400).json(error("40099"));
            return;
          }

          // sanitize
          req.sanitize('city').trim();
          req.sanitize('city').escape();
          req.sanitize('postalCode').trim();
          req.sanitize('postalCode').escape();
          req.sanitize('street').trim();
          req.sanitize('street').escape();

          var data = req.body;

          store.place = data.city;
          store.postalCode = data.postalCode;
          store.street = data.street;

          var googleConfig = require('../config/google');
          var geocoder = require('node-geocoder').getGeocoder('google','https', { apiKey: googleConfig.key } );
          var query = data.street + ', ' + data.postalCode  + ' ' + data.city;
          geocoder.geocode(query, function(err, geo) {

            if (err) { res.status(400).json(error("40008")); return; }

            if (geo.length > 0) {

              store.location = { type : "Point", coordinates : [geo[0].longitude, geo[0].latitude] };
              store.country = geo[0].countryCode;
              store.region = geo[0].stateCode;

            } else {
              res.status(400).json(error("40008"));
              return;
            }

            store.save(function (err) {
              if (err) { console.log(err); res.status(500).json(error("50000")); return; }

              res.json("ok");

            });

          });

        } else {

          res.json(storeAddress(store));

        }

      });

    },
    contact: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Store.findOne({ '_id': id, 'owner': owner._id }, function (err, store) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!store) { res.status(400).json(error("40007")); return; }

        if (req.body && req.method == 'POST') {
          // validation
          if (req.body.email && req.body.email.length > 0) req.checkBody('email').isEmail();
          if (req.body.website  && req.body.website.length > 0) req.checkBody('website').isURL();

          if (req.validationErrors()) {
            res.status(400).json(error("40099"));
            return;
          }

          // sanitize
          req.sanitize('phone').trim()
          req.sanitize('phone').escape();

          var data = req.body;

          store.phone = data.phone;
          store.email = data.email;
          store.website = data.website;

          store.save(function (err) {
            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            res.json("ok");
          });

        } else {

          res.json(storeContact(store));

        }

      });

    },
    location: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Store.findOne({ '_id': id, 'owner': owner._id }, function (err, store) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!store) { res.status(400).json(error("40007")); return; }

        if (req.body && req.method == 'POST') {
          // validation
          req.checkBody('latitude').notEmpty();
          req.checkBody('longitude').notEmpty();

          if (req.validationErrors()) {
            res.status(400).json(error("40099"));
            return;
          }

          // sanitize
          req.sanitize('latitude').toFloat();
          req.sanitize('longitude').toFloat();

          var data = req.body;

          store.location = { type : "Point", coordinates : [data.longitude, data.latitude] };

          store.save(function (err) {
            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            res.json("ok");
          });

        } else {

          res.json(storeLocation(store));

        }

      });

    },
    close: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      var data = req.body;
      var reason = data.reason; // 1. No list, 2. Store closes, 3. other
      var inform = data.inform;

      model.Store.findOne({ '_id': id, 'owner': owner._id }, function (err, store) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        if (!store) { res.status(400).json(error("40007")); return; }

          // remove from all coupons
          model.Coupon.update( { 'owner': owner._id }, { $pull: { 'stores': store._id } }, { multi: true }, function (err) {
            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            // remove store
            model.Store.remove({ '_id': id, 'owner': owner._id }, function (err) {

              if (err) { console.log(err); res.status(500).json(error("50000")); return; }

              res.json("ok");

            });

          });

          // TODO log reason
          // TODO inform customers

      });

    }

  };

};
