'use strict';

var express = require('express');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var session = require('express-session');
var expressValidator = require('express-validator');

module.exports = function(app, passport, all) {

  app.use(cookieParser());
  app.use(bodyParser.urlencoded({ extended: false }));
  app.use(bodyParser.json());
  app.use(expressValidator({

    customValidators: {

      match: function(value, otherValue) {
        return value == otherValue;
      },
      isStoreType: function(value) {
        if (value == 'food') return true;
        return false;
      },
      isStoreCategory: function(value, type) {
        if (type == 'food') {
          if (value == 'bakery') return true;
          if (value == 'bar') return true;
          if (value == 'brewery') return true;
          if (value == 'cafe') return true;
          if (value == 'fastfood') return true;
          if (value == 'ice') return true;
          if (value == 'restaurant') return true;
          if (value == 'winery') return true;
        }
        return false;
      },
      isStoreSubcategory: function(value, category) {
        if (value == null || value == '') return true;
        if (category == 'bakery') return true;
        if (category == 'bar') return true;
        if (category == 'brewery') return true;
        if (category == 'cafe') return true;
        if (category == 'fastfood') return true;
        if (category == 'ice') return true;
        if (category == 'restaurant') {
          if (value == 'asian') return true;
          if (value == 'french') return true;
          if (value == 'german') return true;
          if (value == 'italian') return true;
        }
        if (category == 'winery') return true;
        return false;
      },
      isCouponCategory: function(value) {
        return true;
      },

    }

  }));
  app.use(session({
    secret: 'jurdopverw',
    resave: true,
    saveUninitialized: true
  }));

  var path = require("path");
  app.set('views', path.join(__dirname, '../', 'view'));
  app.engine('html', require('ejs').renderFile);

  // configure passport
  app.use(passport.initialize());
  app.use(passport.session());

  // configure routes
  require('../routes/business-routes')(app, passport, all.controller);

};
