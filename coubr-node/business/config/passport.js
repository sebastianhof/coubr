'use strict'

module.exports = function(passport, db) {

  var LocalStrategy = require('passport-local').Strategy;

  passport.use(new LocalStrategy({
      usernameField: 'email',
      passwordField: 'password',
    }, function(username, password, done) {

      // retrieve user
      db.model.Owner.findOne( { 'email': username }, function (err, owner) {

        if (err) { return done(err); }
        if (!owner) { return done(null, false); }

        // check password
        var bcrypt = require('bcrypt');
        if (bcrypt.compareSync(password, owner.password)) {
          return done(null, owner);
        } else {
          return done(null, false);
        }

      });

    }));

  passport.serializeUser(function(owner, done) {

    var base64url = require('base64-url');
    var encodedId = base64url.encode(owner.email);

    done(null, encodedId);

  });

  passport.deserializeUser(function(encodedId, done) {

    var base64url = require('base64-url');
    var id = base64url.decode(encodedId)

    db.model.Owner.findOne( { 'email': id }, function (err, owner) {

      if (err) { return done(err); }
      if (!owner) { return done(null, false); }

      done(null, owner);

    });

  });

};
