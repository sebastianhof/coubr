/************************************
*
* Sebastian Hof CONFIDENTIAL
* __________________________
*
* Copyright 2014. Sebastian Hof
* All Rights Reserved.
*
************************************/

'use strict';

var express = require('express');
var bodyParser = require('body-parser');
var expressValidator = require('express-validator');

module.exports = function(app, all) {

  app.use(bodyParser.urlencoded({ extended: false }));
  app.use(bodyParser.json());
  app.use(expressValidator());

  // configure routes
  require('../routes/api-routes')(app, all.controller);

};
