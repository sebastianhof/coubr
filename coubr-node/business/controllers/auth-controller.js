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
  var error = function(code) {

    return {
      code: code
    };

  };

  // functions
  return {
      resetPassword: function(req, res) {
        // validation
        req.checkBody('email').notEmpty().isEmail();

        if (req.validationErrors()) {
          res.status(400).json(error("40099"));
          return;
        }

        var data = req.body;

        // query
        model.Owner.findOne({ email: data.email }, function(err, owner) {

          if (!owner) { res.status(400).json(error("40001")); return; }

          // confirmation Code
          var randomString = require('random-string');
          owner.passwordResetCode = randomString({length: 30});

          require('datejs');
          owner.passwordResetExpirationDate = Date.today().add(7).days();

          owner.save(function (err) {
            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            var link = 'https://business.coubr.de/#/resetPasswordConfirm?email=' + owner.email + '&code=' + owner.passwordResetCode;
            var text = 'Hi there,\n\n' +
            'You recently requested a link to reset your coubr password. ' +
            'Please set a new password by following the link below:\n\n' + link + '\n\n ' +
            'Password reset code: ' + owner.passwordResetCode + '\n\n' +
            'You can ignore this mail when you did not requested a link. Your code will expire in 7 days.\n\n' +
            'Thanks\n\n' +
            'coubr Team';

            var mailConfig = require('../config/mail');
            var sendgrid = require('sendgrid')(mailConfig.user, mailConfig.key);
            var email= new sendgrid.Email({

              to: owner.email,
              from: 'mail@coubr.de',
              subject: 'Your password reset request',
              text: text,

            }); // TODO html email
            sendgrid.send(email, function(err, json) {
              if (err) { console.log(err); res.status(500).json(error("50001")); return; }

              res.json("ok");

            });


          });

        });

      },
      resetPasswordConfirm: function(req, res) {
        // validation
        req.checkBody('email').notEmpty().isEmail();
        req.checkBody('code').notEmpty().len(16, 32);
        req.checkBody('password').notEmpty().len(8, 50);
        req.checkBody('passwordRepeat').notEmpty().len(8, 50).match(req.body.password);

        if (req.validationErrors()) {
          res.status(400).json(error("40099"));
          return;
        }

        var data = req.body;

        // query
        model.Owner.findOne({ email: data.email }, function(err, owner) {
          if (!owner) { res.status(400).json(error("40001")); return; }

          if (owner.passwordResetCode != data.code) { res.status(400).json(error("40003")); return; }

          var bcrypt = require('bcrypt');
          bcrypt.genSalt(10, function(err, salt) {

            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            bcrypt.hash(data.password, salt, function(err, hash) {

              if (err) { console.log(err); res.status(500).json(error("50000")); return; }

              owner.password = hash;
              owner.passwordResetExpirationDate = null;
              owner.passwordResetCode = null;

              owner.save(function (err) {
                if (err) { console.log(err); res.status(500).json(error("50000")); return; }

                res.json("ok");
              });

            });

          });

        });

      },
      register: function(req, res) {
        // validation
        req.checkBody('email').notEmpty().isEmail();
        req.checkBody('password').notEmpty().len(8, 50);
        req.checkBody('passwordRepeat').notEmpty().len(8, 50).match(req.body.password);

        if (req.validationErrors()) {
          res.status(400).json(error("40099"));
          return;
        }

        var data = req.body;

        // query
        model.Owner.findOne({ email: data.email }, function(err, owner) {

          if (owner) { res.status(409).json(error("40901")); return; }

          owner = new model.Owner();
          owner.email = data.email;

          var bcrypt = require('bcrypt');
          bcrypt.genSalt(10, function(err, salt) {

            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            bcrypt.hash(data.password, salt, function(err, hash) {

              if (err) { console.log(err); res.status(500).json(error("50000")); return; }

              owner.password = hash;

              // confirmation Code
              var randomString = require('random-string');
              owner.confirmCode = randomString({length: 30});

              require('datejs');
              owner.confirmExpirationDate = Date.today().add(7).days();

              owner.save(function (err) {
                if (err) { console.log(err); res.status(500).json(error("50000")); return; }

                var link = 'https://business.coubr.de/#/confirmRegistration?email=' + owner.email + '&code=' + owner.confirmCode;
                var text = 'Hi there,\n\n' +
                'You recently registered on coubr. ' +
                'Please confirm your registration by following the link below:\n\n' + link + '\n\n' +
                'Confirmation code: ' + owner.confirmCode + '\n\n' +
                'You have 7 days to confirm your registration.\n\n' +
                'Thanks\n\n' +
                'coubr Team';

                // BETA: change to owner email on production
                var mailConfig = require('../config/mail');
                var sendgrid = require('sendgrid')(mailConfig.user, mailConfig.key);
                var email= new sendgrid.Email({

                  to: 'mail@coubr.de',
                  from: 'mail@coubr.de',
                  subject: 'Confirm your registration',
                  text: text

                }); // TODO html email
                sendgrid.send(email, function(err, json) {
                  if (err) { console.log(err); res.status(500).json(error("50001")); return; }

                  res.json("ok");

                });

              });

            });

          });

        });

      },
      confirmRegistration: function(req, res) {
        // validation
        req.checkBody('email').notEmpty().isEmail();
        req.checkBody('code').notEmpty().len(16, 32);

        if (req.validationErrors()) {
          res.status(400).json(error("40099"));
          return;
        }

        var data = req.body;

        // query
        model.Owner.findOne({ email: data.email }, function(err, owner) {

          if (!owner) { res.status(400).json(error("40001")); return; }

          if (!owner.confirmCode) { res.status(400).json(error("40005")); return; }

          if (owner.confirmCode != data.code) { res.status(400).json(error("40003") ); return; }

          owner.confirmExpirationDate = null;
          owner.confirmCode = null;

          owner.save(function (err) {
            if (err) { console.log(err); res.status(500).json(error("50000")); return; }
            res.json("ok");
          });

        });

      },
      resendConfirmation: function(req, res) {
        // validation
        req.checkBody('email').notEmpty().isEmail();

        if (req.validationErrors()) {
          res.status(400).json(error("40099"));
          return;
        }

        var data = req.body;

        // query
        model.Owner.findOne({ email: data.email }, function(err, owner) {

          if (!owner) { res.status(400).json(error("40001")); return; }

          if (!owner.confirmCode) { res.status(400).json(error("40005")); return; }

          var randomString = require('random-string');
          owner.confirmCode = randomString({length: 30});

          require('datejs');
          owner.confirmExpirationDate = Date.today().add(7).days();

          owner.save(function (err) {
            if (err) { console.log(err); res.status(500).json(error("50000")); return; }

            var link = 'https://business.coubr.de/#/confirmRegistration?email=' + owner.email + '&code=' + owner.confirmCode;
            var text = 'Hi there,\n\n' +
            'You recently registered on coubr. ' +
            'Please confirm your registration by following the link below:\n\n' + link + '\n\n' +
            'Confirmation code: ' + owner.confirmCode + '\n\n' +
            'You have 7 days to confirm your registration.\n\n' +
            'Thanks\n\n' +
            'coubr Team';

            // BETA: change to owner email on production
            var mailConfig = require('../config/mail');
            var sendgrid = require('sendgrid')(mailConfig.user, mailConfig.key);
            var email = new sendgrid.Email({

              to: 'mail@coubr.de',
              from: 'mail@coubr.de',
              subject: 'Confirm your registration',
              text: text,

            }); // TODO html email
            sendgrid.send(email, function(err, json) {
              if (err) { console.log(err); res.status(500).json(error("50001")); return; }

              res.json("ok");

            });

          });

        });

      },
  };

};
