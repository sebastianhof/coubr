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

module.exports = function() {

  return {

    feedback: function(req, res) {
      req.checkBody('feedback').notEmpty();

      if (req.validationErrors()) {
        res.status(400).json(error("40099"));
        return;
      }

      var owner = req.user;
      var data = req.body;

      var text = 'Hi there,\n\n' +
      'You received feedback from: ' + owner.email + '\n\n' +
      'Location: ' + data.location + '\n' +
      'UserAgent: ' + data.userAgent + '\n\n' + data.feedback;

      var mailConfig = require('../config/mail');
      var sendgrid = require('sendgrid')(mailConfig.user, mailConfig.key);
      var email = new sendgrid.Email({

        to: 'feedback@coubr.de',
        from: owner.email,
        subject: 'You got feedback',
        text: text,

      });
      sendgrid.send(email, function(err, json) {
        if (err) { console.log(err); res.status(500).json(error("50001")); return; }

        res.json("ok");

      });

    },

  };


}
