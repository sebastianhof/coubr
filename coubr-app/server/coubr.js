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
var all = require('./config/all.js')(db);
var passportConfig = require('./config/passport.js')(passport);
var expressConfig = require('./config/express.js')(app, all);


module.exports = {

  run: function() {

      console.log('----------------------------------------');
      console.log('');
      console.log('coubr api application');
      console.log('');
      console.log('----------------------------------------');

      console.log('');

      app.listen(all.http.port);
      console.log('# coubr is listen on port ' + all.http.port);

  }

};
