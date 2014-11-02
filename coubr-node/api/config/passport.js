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

module.exports = function(passport) {

  // oauth 2.0 api

  passport.serializeUser(function(owner, done) {

    // var base64url = require('base64-url');
    // var encodedId = base64url.encode(owner.email);
    //
    // done(null, encodedId);

  });

  passport.deserializeUser(function(encodedId, done) {

    // var base64url = require('base64-url');
    // var id = base64url.decode(encodedId)
    //
    // db.model.Owner.findOne( { 'email': id }, function (err, owner) {
    //
    //   if (err) { return done(err); }
    //   if (!owner) { return done(null, false); }
    //
    //   done(null, owner);
    //
    // });

  });

};
