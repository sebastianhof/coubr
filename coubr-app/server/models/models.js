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
      coupons: [ { type : Schema.ObjectId, ref: 'Coupon' } ],
  });

  store.index({location: '2dsphere'});

  var storeVisit = new Schema({
    storeId: { type : Schema.ObjectId, ref: 'Store' },
    date: { type: Date },
    userId: { type: String },
  });

  // coupon
  var coupon = new Schema({
      id : { type: Schema.ObjectId, index: true },
      title : { type: String },
      description : { type: String, default: '' },
      category : { type: String, lowercase: true },
      validTo: { type: Date },
      amount: { type: Number, min: 1 },
      amountRedeemed: { type: Number, min: 0, default: 0 },
      activated: { type: Boolean, default: true },
      stores: [ { type : Schema.ObjectId, ref: 'Store' } ],
  });

  var couponRedemption = new Schema({
      couponId: { type : Schema.ObjectId, ref: 'Coupon' },
      storeId: { type : Schema.ObjectId, ref: 'Store' },
      date: { type: Date },
      userId: { type: String },
  });

  return {

    Store: mongoose.model('Store', store),
    StoreVisit: mongoose.model('StoreVisit', storeVisit),
    Coupon: mongoose.model('Coupon', coupon),
    CouponRedemption: mongoose.model('CouponRedemption', couponRedemption),

  }


};
