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

module.exports = function(mongoose) {

  var user = process.env.MONGO_USER || null;
  var password = process.env.MONGO_PASSWORD || null;
  var host = process.env.MONGO_HOST || 'localhost';
  var port = process.env.MONGO_PORT || 27017;
  var database = process.env.MONGO_DATABASE || 'coubr';

  if (user && password) {
    mongoose.connect('mongodb://' + user + ':' + password + '@' + host + ':' + port + '/' + database);
  } else {
    mongoose.connect('mongodb://' + host + ':' + port + '/' + database);
  }

  return {

    model: require('../models/models')(mongoose)

  };

};
