'use strict'

module.exports = function(mongoose) {

  var Schema = mongoose.Schema;

  // store
  var store = new Schema({
      id : { type: Schema.ObjectId, index: true },
      name : { type: String },
      description : { type: String, default: '' },
      type : { type: String, lowercase: true },
      category : { type: String, lowercase: true },
      subcategory : { type: String, lowercase: true },
      phone : { type: String },
      email : { type: String, lowercase: true },
      website : { type: String, lowercase: true },
      country : { type: String },
      region : { type: String },
      place : { type: String },
      postalCode : { type: String },
      street : { type: String },
      location: { 'type': {type: String, enum: ['Point'], default: 'Point'},
                  coordinates: { type: [Number] },
      },
      code : { type: String },
  });

  store.index({location: '2dsphere'});

  // coupon
  var coupon = new Schema({
      id : { type: Schema.ObjectId, index: true },
      title : { type: String },
      description : { type: String, default: '' },
      category : { type: String, lowercase: true },
      validTo: { type: Date },
      amount: { type: Number, min: 1 },
      amountIssued: { type: Number, min: 0 },
      activated: { type: Boolean, default: true },
      code : { type: String },
      stores: [ store ],
  });

  // store objects
  var storeOffers = new Schema({
      store: { type: Schema.ObjectId, ref: 'Store', index: true },
      coupons: [ coupon ],
  });

  return {

    Store: mongoose.model('Store', store),
    Coupon: mongoose.model('Coupon', coupon),
    StoreOffers: mongoose.model('StoreOffers', storeOffers),

  }


};
