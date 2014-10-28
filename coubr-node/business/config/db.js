'use strict';

module.exports = function(mongoose) {

  mongoose.connect('mongodb://localhost/coubr');
  // TODO username and password

  return {

    model: require('../models/models')(mongoose)

  };

};
