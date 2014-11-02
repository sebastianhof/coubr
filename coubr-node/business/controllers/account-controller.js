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

  // object to json
  var account = function(owner) {

    return {
      email: owner.email,
      firstName: owner.firstName,
      lastName: owner.lastName
    };

  };

  var name = function(owner) {

    return {
      firstName: owner.firstName,
      lastName: owner.lastName
    };

  };

  var error = function(code) {

    return {
      code: code
    };

  };

  // functions
  return {
    get: function(req, res) {
      var owner = req.user;

      model.Owner.findOne({ email: owner.email }, function(err, owner) {

        if (!owner) { res.status(400).json(error("40001")); return; }

        res.json(account(owner));

      });

    },
    name: function(req, res) {
      var owner = req.user;

      model.Owner.findOne({ email: owner.email }, function(err, owner) {

        if (!owner) { res.status(400).json(error("40001")); return; }

        if (req.body && req.method == 'POST') {
          // sanitize
          req.sanitize('firstName').trim();
          req.sanitize('firstName').escape();
          req.sanitize('lastName').trim();
          req.sanitize('lastName').escape();

          var data = req.body;

          owner.firstName = data.firstName;
          owner.lastName = data.lastName;

          owner.save(function (err) {
            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            res.json("ok");
          });

        } else {

          res.json(name(owner));

        }

      });

    },
    password: function(req, res) {
      // validation
      req.checkBody('password').notEmpty().len(8, 50);
      req.checkBody('newPassword').notEmpty().len(8, 50);
      req.checkBody('newPasswordRepeat').notEmpty().len(8, 50).match(req.body.newPassword);

      if (req.validationErrors()) {
        res.status(400).json(error("40099"));
        return;
      }

      var owner = req.user;
      var data = req.body;

      model.Owner.findOne({ email: owner.email }, function(err, owner) {

        if (!owner) { res.status(400).json(error("40001")); return; }

        var bcrypt = require('bcrypt');
        if (!bcrypt.compareSync(data.password, owner.password)) { res.status(400).json(error("40002")); return; }

        bcrypt.genSalt(10, function(err, salt) {

          if (err) { console.log(err); res.status(500).json(error("50000")); return; }

          bcrypt.hash(data.newPassword, salt, function(err, hash) {

            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            owner.password = hash;

            owner.save(function (err) {
              if (err) { console.log(err); res.status(500).json(error("50000")); return; }

              res.json("ok");
            });

          });

        });

      });

    },
    email: function(req, res) {
      // validation
      req.checkBody('email').notEmpty().isEmail();
      req.checkBody('emailRepeat').notEmpty().isEmail().match(req.body.email);

      if (req.validationErrors()) {
        res.status(400).json(error("40099"));
        return;
      }

      var owner = req.user;
      var data = req.body;

      model.Owner.findOne({ email: data.newEmail }, function(err, otherOwner) {

        if (otherOwner) { res.status(409).json(error("40901")); return; }

        model.Owner.findOne({ email: owner.email }, function(err, owner) {

          if (!owner) { res.status(400).json(error("40001")); return; }

          owner.save(function (err) {
            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            // confirmation Code
            var randomString = require('random-string');
            owner.emailResetCode = randomString({length: 30});

            // TODO confirmation email reset via email

            res.json("ok");
          });

        });

      });

    },
    delete: function(req, res) {
      req.checkBody('password').notEmpty().len(8, 50);
      if (req.validationErrors()) {
        res.status(400).json(error("40099"));
        return;
      }

      var owner = req.user;
      var data = req.body;
      var reason = data.reason; // 1. No coubr, 2. other

      // check password
      var password = data.password;
      var bcrypt = require('bcrypt');
      if (!bcrypt.compareSync(password, owner.password)) {
        res.status(400).json(error("40002")); return;
      }

      model.Coupon.remove({ 'owner': owner._id }, function (err) {

        if (err) { console.log(err); res.status(500).json(error("50000")); return; }

        model.Store.remove({ 'owner': owner._id }, function (err) {

          if (err) { console.log(err); res.status(500).json(error("50000")); return; }

          model.Owner.remove({ '_id': owner._id }, function (err) {

            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            // TODO log reason

            req.logout();
            res.redirect('/');

          });

        });

      });

    }

  };

};
