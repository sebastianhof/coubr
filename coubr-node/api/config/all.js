'use strict'

module.exports = function(db, mail) {

  return {
    // http
    http : {
      port: process.env.PORT || 8082
    },
    // controller
    controller: {
        api: require('../controllers/api-controller.js')(db.model),
    }

  };

}
