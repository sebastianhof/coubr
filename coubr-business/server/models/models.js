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

module.exports = function (mongoose) {

    var Schema = mongoose.Schema;

    // owner
    var owner = new Schema({
        id: {type: Schema.ObjectId, index: true},
        email: {type: String, index: true},
        password: {type: String},
        firstName: {type: String, default: ''},
        lastName: {type: String, default: ''},
        confirmExpirationDate: {type: Date},
        confirmCode: {type: String},
        passwordResetExpirationDate: {type: Date},
        passwordResetCode: {type: String},
        changeEmail: {type: String},
        changeEmailCode: {type: String},
        emailResetCode: {type: String}
    });

    // store
    var store = new Schema({
        owner: {type: Schema.ObjectId, ref: 'Owner', index: true},
        id: {type: Schema.ObjectId, index: true},
        name: {type: String},
        description: {type: String, default: ''},
        type: {type: String, lowercase: true, default: 'gastronomy'},
        category: {type: String, lowercase: true},
        subcategory: {type: String, lowercase: true},
        country: {type: String},
        region: {type: String},
        place: {type: String},
        postalCode: {type: String},
        street: {type: String},
        location: {
            'type': {type: String, enum: ['Point'], default: 'Point'},
            coordinates: {type: [Number]}
        },
        phone: {type: String},
        email: {type: String, lowercase: true},
        website: {type: String, lowercase: true},
        activated: {type: Boolean, default: false },
        // special offers, coupons, stamp cards
        specialoffers: [{type: Schema.ObjectId, ref: 'SpecialOffer'}],
        coupons: [{type: Schema.ObjectId, ref: 'Coupon'}],
        stampcards: [{type: Schema.ObjectId, ref: 'StampCard'}],
        // devices
        code: {type: String},
        beacons: [{
            name: { type: String },
            location: { type: String },
            uuid: { type: String }
        }]
    });

    store.index({location: '2dsphere'});

    // special offer

    var specialoffer = new Schema({
        owner: {type: Schema.ObjectId, ref: 'Owner', index: true},
        id: {type: Schema.ObjectId, index: true},
        title: {type: String},
        description: {type: String, default: ''},
        category: {type: String, lowercase: true},
        validOnWeekday: { type: Number, min: 1, max: 7 },
        validOnDate: {type: Date},
        validFromDate: {type: Date},
        validToDate: {type: Date},
        validFromTime: {type: Date},
        validToTime: {type: Date},
        stores: [{type: Schema.ObjectId, ref: 'Store'}]
    });

    // coupon
    var coupon = new Schema({
        owner: {type: Schema.ObjectId, ref: 'Owner', index: true},
        id: {type: Schema.ObjectId, index: true},
        title: {type: String},
        description: {type: String, default: ''},
        category: {type: String, lowercase: true},
        validTo: {type: Date},
        amount: {type: Number, min: 1},
        amountRedeemed: {type: Number, min: 0, default: 0},
        stores: [{type: Schema.ObjectId, ref: 'Store'}]
    });

    // stamp card

    var stampcard = new Schema({
        owner: {type: Schema.ObjectId, ref: 'Owner', index: true},
        id: {type: Schema.ObjectId, index: true},
        title: {type: String},
        description: {type: String, default: ''},
        category: {type: String, lowercase: true},
        validTo: {type: Date},
        stamps: {type: Number, min: 1},
        stores: [{type: Schema.ObjectId, ref: 'Store'}]
    });

    return {
        Owner: mongoose.model('Owner', owner),
        Store: mongoose.model('Store', store),
        SpecialOffer: mongoose.model('SpecialOffer', specialoffer),
        Coupon: mongoose.model('Coupon', coupon),
        StampCard: mongoose.model('StampCard', stampcard)
    }


};
