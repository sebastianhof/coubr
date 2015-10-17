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

    var isValid = function (stampcard) {
        if (stampcard.validTo > new Date()) return true;
        return false;
    };

    var stampcardJSON = function (stampcard) {

        return {
            stampCardId: base64url.encode(stampcard._id.toString()),
            title: stampcard.title,
            description: stampcard.description,
            category: stampcard.category,
            validTo: stampcard.validTo, // convert to json date
            stamps: stampcard.stamps,
            isValid: isValid(stampcard)
        };

    };

    return {
        add: function (req, res) {
            // validation
            req.checkBody('title').notEmpty();
            req.checkBody('category').notEmpty().isStampCardCategory();
            req.checkBody('validTo').notEmpty().isDate().isAfter(new Date());
            req.checkBody('stamps').notEmpty().isInt();

            if (req.validationErrors()) return errorHelper.validationError(res);

            // sanitize
            req.sanitize('title').trim();
            req.sanitize('title').escape();
            req.sanitize('description').trim();
            req.sanitize('description').escape();
            req.sanitize('validTo').toDate();
            req.sanitize('stamps').toInt();

            var data = req.body;

            var stampcard = new model.StampCard();
            stampcard.owner = req.user._id;
            stampcard.title = data.title;
            stampcard.description = data.description;
            stampcard.category = data.category;

            require('datejs');
            stampcard.validTo = data.validTo.set({hour: 23, minute: 59, second: 59});
            stampcard.stamps = data.stamps;

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
                stampcard.stores = [];
                stores.forEach(function (entry) {
                    stampcard.stores.push(entry._id);
                });

                // save stampcard
                stampcard.save(function (err) {
                    if (err) return errorHelper.serverError(res, err);

                    // update store
                    model.Store.update({'_id': {$in: storeIds}}, {$addToSet: {'stampcards': stampcard._id}}, {multi: true}, function (err) {

                        // return
                        res.json(stampcardJSON(stampcard));

                    });

                });

            });

        },
        getAll: function (req, res) {
            var storeId = base64url.decode(req.params.id);

            model.StampCard.find({'owner': req.user._id, 'stores': storeId }, function (err, stampcards) {

                if (err) return errorHelper.serverError(res, err);

                var data = {};
                data.stampcards = [];

                stampcards.forEach(function (stampcard) {
                    data.stampcards.push(stampcardJSON(stampcard));
                });

                res.json(data);
            });

        },
        get: function (req, res) {
            var id = base64url.decode(req.params.id);

            model.StampCard.findOne({'_id': id, 'owner': req.user._id}, function (err, stampcard) {

                if (err) return errorHelper.serverError(res, err);
                if (!stampcard) return errorHelper.stampcardNotFound(res);

                res.json(stampcardJSON(stampcard));

            });

        }

    };

};