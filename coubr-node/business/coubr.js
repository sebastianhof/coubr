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

// import express
var express = require('express');
var app = express();
var passport = require('passport');
var mongoose = require('mongoose');

// import config
var db = require('./config/db.js')(mongoose);
var mail = require('./config/mail.js');
var all = require('./config/all.js')(db, mail);
var passportConfig = require('./config/passport.js')(passport, db);
var expressConfig = require('./config/express.js')(app, passport, all);

module.exports = {

  run: function() {

      console.log('----------------------------------------');
      console.log('');
      console.log('coubr for business application');
      console.log('');
      console.log('----------------------------------------');

      console.log('');

      app.listen(all.http.port);
      console.log('# coubr is listen on port ' + all.http.port);

  }

};
