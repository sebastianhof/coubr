'use strict'

module.exports = function(db, mail) {

  return {
    // http
    http : {
      port: process.env.PORT || 8081
    },
    // controller
    controller: {
        account: require('../controllers/account-controller.js')(db.model),
        auth: require('../controllers/auth-controller.js')(db.model),
        coupon: require('../controllers/coupon-controller.js')(db.model),
        store: require('../controllers/store-controller.js')(db.model),
        service: require('../controllers/service-controller.js')(db.model)
    }

  };

}
