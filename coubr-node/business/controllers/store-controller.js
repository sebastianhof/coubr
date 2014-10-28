'use strict'

module.exports = function(model) {

  // object to json
  var storeJSON =  function(store) {
    var base64url = require('base64-url');

    return {
      storeId: base64url.encode(store._id.toString()),
      name: store.name,
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
      type: store.type,
      category: store.category,
      subcategory: store.subcategory,
      offers: [] // TODO stores offers

    };

  };

  var storePictures = function(store) {
    var base64url = require('base64-url');

    return {
      storeId: base64url.encode(store._id.toString()),
    };

  };

  var storeLocation = function(store) {
    var base64url = require('base64-url');

    return {
      storeId: base64url.encode(store._id.toString()),
      latitude: store.location.coordinates[1],
      longitude: store.location.coordinates[0],
    };

  };

  var storeCode = function(store) {
    var base64url = require('base64-url');

    return {
      storeId: base64url.encode(store._id.toString()),
    };

  };

  var storeSettings = function(store) {
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
      type: store.type,
      category: store.category,
      subcategory: store.subcategory,
    };

  };

  var storeName = function(store) {
    var base64url = require('base64-url');

    return {
      storeId: base64url.encode(store._id.toString()),
      name: store.name,
      description: store.description,
    };

  };

  var storeAddress = function(store) {
    var base64url = require('base64-url');

    return {
      storeId: base64url.encode(store._id.toString()),
      street: store.street,
      postalCode: store.postalCode,
      city: store.place,
    };

  };

  var storeContact = function(store) {
    var base64url = require('base64-url');

    return {
      storeId: base64url.encode(store._id.toString()),
      phone: store.phone,
      email: store.email,
      website: store.website,
    };

  };

  var storeType = function(store) {
    var base64url = require('base64-url');

    return {
      storeId: base64url.encode(store._id.toString()),
      type: store.type,
      category: store.category,
      subcategory: store.subcategory,
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
      req.checkBody('type').notEmpty().isStoreType();
      req.checkBody('category').notEmpty().isStoreCategory(req.body.type);
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
      store.owner = owner.id;
      store.name = data.name;
      store.description = data.description;
      store.type = data.type;
      store.category = data.category;
      store.subcategory = data.subcategory;
      store.phone = data.phone;
      store.email = data.email;
      store.website = data.website;
      store.place = data.city;
      store.postalCode = data.postalCode;
      store.street = data.street;

      var geocoder = require('node-geocoder').getGeocoder('google','https');
      var query = data.street + ', ' + data.postalCode  + ' ' + data.city;
      geocoder.geocode(query, function(err, geo) {

        if (err) { res.status(400).json(error("40008")); return; }

        if (geo.length > 0) {

          store.latitude = geo[0].latitude;
          store.longitude = geo[0].longitude;
          store.country = geo[0].countryCode;
          store.region = geo[0].stateCode;

        } else {
          res.status(400).json(error("40008"));
          return;
        }

        store.save(function (err) {
          if (err) { res.status(500).json(error("50000")); return; }

          res.json(storeJSON(store));
        });

      });

    },
    getAll: function(req, res) {
      var owner = req.user;

      model.Store.find({ 'owner': owner.id }, function (err, stores) {

        if (err) { res.status(500).json(error("50000")); return; }

        var data = {};
        data.stores = [];

        stores.forEach(function(entry) {

          data.stores.push(storeJSON(entry));

        });

        res.json(data);
      });

    },
    getAllDetails: function(req, res) {
      var owner = req.user;

      model.Store.find({ 'owner': owner.id }, function (err, stores) {

        if (err) { res.status(500).json(error("50000")); return; }

        var data = {};
        data.stores = [];

        stores.forEach(function(entry) {

          data.stores.push(storeDetails(entry));

        });

        res.json(data);
      });

    },
    get: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Store.findOne({ '_id': id, 'owner': owner.id }, function (err, store) {

        if (err) { res.status(500).json(error("50000")); return; }

        if (!store) { res.status(400).json(error("40007")); return; }

        res.json(storeDetails(store));

      });

    },
    pictures: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Store.findOne({ '_id': id, 'owner': owner.id }, function (err, store) {

        if (err) { res.status(500).json(error("50000")); return; }

        if (!store) { res.status(400).json(error("40007")); return; }

        res.json(storePictures(store));

      });

    },
    location: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Store.findOne({ '_id': id, 'owner': owner.id }, function (err, store) {

        if (err) { res.status(500).json(error("50000")); return; }

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
            if (err) { res.status(500).json(error("50000")); return; }

            res.json("ok");
          });

        } else {

          res.json(storeLocation(store));

        }

      });

    },
    code: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Store.findOne({ '_id': id, 'owner': owner.id }, function (err, store) {

        if (err) { res.status(500).json(error("50000")); return; }

        if (!store) { res.status(400).json(error("40007")); return; }

        res.json(storeCode(store));

      });

    },
    settings: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Store.findOne({ '_id': id, 'owner': owner.id }, function (err, store) {

        if (err) { res.status(500).json(error("50000")); return; }

        if (!store) { res.status(400).json(error("40007")); return; }

        res.json(storeSettings(store));

      });

    },
    name: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Store.findOne({ '_id': id, 'owner': owner.id }, function (err, store) {

        if (err) { res.status(500).json(error("50000")); return; }

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
            if (err) { res.status(500).json(error("50000")); return; }

            res.json("ok");
          });

        } else {

          res.json(storeName(store));

        }


      });


    },
    address: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Store.findOne({ '_id': id, 'owner': owner.id }, function (err, store) {

        if (err) { res.status(500).json(error("50000")); return; }

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

          var geocoder = require('node-geocoder').getGeocoder('google','https');
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
              if (err) { res.status(500).json(error("50000")); return; }

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
      var data = req.body;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Store.findOne({ '_id': id, 'owner': owner.id }, function (err, store) {

        if (err) { res.status(500).json(error("50000")); return; }

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
            if (err) { res.status(500).json(error("50000")); return; }

            res.json("ok");
          });

        } else {

          res.json(storeContact(store));

        }

      });

    },
    type: function(req, res) {
      var owner = req.user;
      var data = req.body;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Store.findOne({ '_id': id, 'owner': owner.id }, function (err, store) {

        if (err) { res.status(500).json(error("50000")); return; }

        if (!store) { res.status(400).json(error("40007")); return; }

        if (req.body && req.method == 'POST') {
          // validation
          req.checkBody('type').notEmpty().isStoreType();
          req.checkBody('category').notEmpty().isStoreCategory(req.body.type);
          req.checkBody('subcategory').isStoreSubcategory(req.body.category);

          if (req.validationErrors()) {
            res.status(400).json(error("40099"));
            return;
          }

          var data = req.body;

          store.type = data.type;
          store.category = data.category;
          store.subcategory = data.subcategory;

          store.save(function (err) {
            if (err) { res.status(500).json(error("50000")); return; }

            res.json("ok");
          });

        } else {

          res.json(storeType(store));

        }

      });

    },
    delete: function(req, res) {
      var owner = req.user;
      var base64url = require('base64-url');
      var id = base64url.decode(req.params.id);

      model.Store.findOne({ '_id': id, 'owner': owner.id }, function (err, store) {

        if (err) { res.status(500).json(error("50000")); return; }

        if (!store) { res.status(400).json(error("40007")); return; }

        // TODO delete + delete offers -> delete set flag
        // TODO inform customers

      });

    },

  };

};
