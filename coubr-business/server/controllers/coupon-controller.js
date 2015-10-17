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

var base64url = require('base64-url');
var errorHelper = require('../helper/error-helper.js');

module.exports = function (model) {

    // helper
    var isValid = function (coupon) {
        if ((coupon.amount - coupon.amountRedeemed > 0) && coupon.validTo > new Date()) return true;
        return false;
    };

    var couponJSON = function (coupon) {
        return {
            couponId: base64url.encode(coupon._id.toString()),
            title: coupon.title,
            description: coupon.description,
            category: coupon.category,
            validTo: coupon.validTo, // convert to json date
            amount: coupon.amount,
            amountRedeemed: coupon.amountRedeemed,
            isValid: isValid(coupon)
        };

    };

    var error = function (code) {
        return {
            code: code
        };
    };

    return {
        add: function (req, res) {
            // validation
            req.checkBody('title').notEmpty();
            req.checkBody('category').isCouponCategory();
            req.checkBody('validTo').notEmpty().isDate().isAfter(new Date());
            req.checkBody('amount').notEmpty().isInt();

            if (req.validationErrors()) return errorHelper.validationError(res);

            // sanitize
            req.sanitize('title').trim();
            req.sanitize('title').escape();
            req.sanitize('description').trim();
            req.sanitize('description').escape();
            req.sanitize('validTo').toDate();
            req.sanitize('amount').toInt();

            var data = req.body;

            var coupon = new model.Coupon();
            coupon.owner = req.user._id;
            coupon.title = data.title;
            coupon.description = data.description;
            coupon.category = data.category;

            require('datejs');
            coupon.validTo = data.validTo.set({hour: 23, minute: 59, second: 59});
            coupon.amount = data.amount;

            // stores
            var storeIds = [];
            // convert encoded ids to mongo id
            data.stores.forEach(function (entry) {
                storeIds.push(base64url.decode(entry));
            });

            // find stores
            model.Store.find({'_id': {$in: storeIds}, 'owner': req.user._id}, function (err, stores) {

                if (err) return errorHelper.serverError(res, err);

                // set stores
                coupon.stores = [];
                stores.forEach(function (entry) {
                    coupon.stores.push(entry._id);
                });

                // save coupon
                coupon.save(function (err) {

                    if (err) return errorHelper.serverError(res, err);

                    // update store
                    model.Store.update({'_id': {$in: storeIds}}, {$addToSet: {'coupons': coupon._id}}, {multi: true}, function (err) {

                        // return
                        res.json(couponJSON(coupon));

                    });

                });

            });

        },
        getAll: function (req, res) {
            var storeId = base64url.decode(req.params.id);

            model.Coupon.find({'owner': req.user._id, 'stores': storeId }, function (err, coupons) {

                if (err) return errorHelper.serverError(res, err);

                var data = {};
                data.coupons = [];

                coupons.forEach(function (coupon) {
                    data.coupons.push(couponJSON(coupon));
                });

                res.json(data);
            });

        },
        get: function (req, res) {
            var id = base64url.decode(req.params.id);

            model.Coupon.findOne({'_id': id, 'owner': req.user._id}, function (err, coupon) {

                if (err) return errorHelper.serverError(res, err);
                if (!coupon) return errorHelper.couponNotFound(res);

                res.json(couponJSON(coupon));

            });

        },
        edit: function (req, res) {
            var id = base64url.decode(req.params.id);

            req.checkBody('title').notEmpty();
            req.checkBody('category').notEmpty().isCouponCategory();
            req.checkBody('validTo').notEmpty().isDate().isAfter(new Date());
            req.checkBody('amount').notEmpty().isInt();

            if (req.validationErrors()) return errorHelper.validationError(res);

            // sanitize
            req.sanitize('title').trim();
            req.sanitize('title').escape();
            req.sanitize('description').trim();
            req.sanitize('description').escape();
            req.sanitize('validTo').toDate();
            req.sanitize('amount').toInt();

            model.Coupon.findOne({'_id': id, 'owner': req.user._id}, function (err, coupon) {

                if (err) return errorHelper.serverError(res, err);
                if (!coupon) return errorHelper.couponNotFound(res);

                var data = req.body;
                coupon.title = data.title;
                coupon.description = data.description;
                coupon.category = data.category;

                require('datejs');
                coupon.validTo = data.validTo.set({hour: 23, minute: 59, second: 59});
                coupon.amount = data.amount;


                coupon.save(function (err) {
                    if (err) return errorHelper.serverError(res, err);

                    res.json("ok");
                });

            });

        },
        //stores: function (req, res) {
        //    var id = base64url.decode(req.params.id);
        //
        //    model.Coupon.findOne({'_id': id, 'owner': req.user._id}, function (err, coupon) {
        //
        //        if (err) return errorHelper.serverError(err);
        //
        //        if (!coupon) return errorHelper.couponNotFound();
        //
        //        if (req.body && req.method == 'POST') {
        //
        //            // stores
        //            var data = req.body;
        //
        //            var storeIds = [];
        //            // convert encoded ids to mongo id
        //            data.stores.forEach(function (entry) {
        //                storeIds.push(base64url.decode(entry));
        //            });
        //
        //            // find stores
        //            model.Store.find({'_id': {$in: storeIds}, 'owner': req.user._id}, function (err, stores) {
        //
        //                if (err) return errorHelper.serverError(err);

        //                // set stores
        //                coupon.stores = [];
        //                stores.forEach(function (entry) {
        //                    coupon.stores.push(entry._id);
        //                });
        //
        //                // save coupon
        //                coupon.save(function (err) {
        //                    if (err) return errorHelper.serverError(err);
        //
        //                    // remove from all stores
        //                    model.Store.update({'owner': req.user._id}, {$pull: {'coupons': coupon._id}}, {multi: true}, function (err) {
        //                        if (err) return errorHelper.serverError(err);
        //
        //                        // update store
        //                        model.Store.update({
        //                            '_id': {$in: storeIds},
        //                            'owner': req.user._id
        //                        }, {$addToSet: {'coupons': coupon._id}}, {multi: true}, function (err) {
        //                            if (err) return errorHelper.serverError(err);
        //
        //                            // return
        //                            res.json(couponJSON(coupon));
        //
        //                        });
        //
        //                    });
        //
        //                });
        //
        //            });
        //
        //        } else {
        //
        //            model.Store.find({'_id': {$in: coupon.stores}, 'owner': req.user._id}, function (err, stores) {
        //
        //                if (err) return errorHelper.serverError(err);
        //
        //                res.json(couponStores(coupon, stores));
        //
        //            });
        //
        //        }
        //
        //
        //    });
        //
        //},
        delete: function (req, res) {
            var id = base64url.decode(req.params.id);

            model.Coupon.findOne({'_id': id, 'owner': req.user._id}, function (err, coupon) {

                if (err) return errorHelper.serverError(res, err);

                if (!coupon) return errorHelper.couponNotFound(res);

                // remove from all stores
                model.Store.update({'owner': req.user._id}, {$pull: {'coupons': coupon._id}}, {multi: true}, function (err) {

                    if (err) return errorHelper.serverError(res, err);

                    // remove coupon
                    model.Coupon.remove({'_id': id, 'owner': req.user._id}, function (err) {

                        if (err) return errorHelper.serverError(res, err);

                        res.json("ok");

                    });

                });

            });

        }

    };

};
