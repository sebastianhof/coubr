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

module.exports = function(db, mc) {

  return {
    // http
    http : {
      port: process.env.PORT || 8082
    },
    // controller
    controller: {
        api: require('../controllers/api-controller.js')(db.model)
    }

  };

}
