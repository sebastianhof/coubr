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

module.exports = function(model) {

    var isValid = function (specialoffer) {
        // TODO
        return true;
    };

    var specialOfferJSON = function (specialoffer) {

        return {
            specialOfferId: base64url.encode(specialoffer._id.toString()),
            title: specialoffer.title,
            description: specialoffer.description,
            category: specialoffer.category,
            validOnWeekday: specialoffer.validOnWeekday,
            validOnDate: specialoffer.validOnDate,
            validFromDate: specialoffer.validFromDate,
            validToDate: specialoffer.validToDate,
            validFromTime: specialoffer.validFromTime,
            validToTime: specialoffer.validToDate,
            isValid: isValid(specialoffer)
        };

    };

    return {

        add: function (req, res) {
            var data = req.body;

            // validation
            req.checkBody('title').notEmpty();
            req.checkBody('category').notEmpty().isSpecialOfferCategory();

            if (data.validOnWeekday) req.checkBody('validOnWeekday').isInt();
            if (data.validOnDate) req.checkBody('validOnDate').isDate();
            if (data.validFromDate) req.checkBody('validFromDate').isDate();
            if (data.validToDate) req.checkBody('validToDate').isDate();
            if (data.validFromTime) req.checkBody('validFromTime').isDate();
            if (data.validToTime) req.checkBody('validToTime').isDate()
            if (data.validFromDate && data.validToDate) req.checkBody('validToDate').isAfter(data.validFromDate);
            if (data.validFromTime && data.validToTime) req.checkBody('validToTime').isAfter(data.validFromTime);

            if (req.validationErrors()) return errorHelper.validationError(res);

            // sanitize
            req.sanitize('title').trim();
            req.sanitize('title').escape();
            req.sanitize('description').trim();
            req.sanitize('description').escape();

            var specialoffer = new model.SpecialOffer();
            specialoffer.owner = req.user._id;
            specialoffer.title = data.title;
            specialoffer.description = data.description;
            specialoffer.category = data.category;

            require('datejs');
            specialoffer.validOnWeekday = data.validOnWeekday;
            specialoffer.validOnDate = data.validOnDate;
            specialoffer.validFromDate = data.validFromDate;
            specialoffer.validToDate = data.validToDate;
            specialoffer.validFromTime = data.validFromTime;
            specialoffer.validToTime = data.validToTime;

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
                specialoffer.stores = [];
                stores.forEach(function (entry) {
                    specialoffer.stores.push(entry._id);
                });

                // save specialoffer
                specialoffer.save(function (err) {
                    if (err) return errorHelper.serverError(res, err);

                    // update store
                    model.Store.update({'_id': {$in: storeIds}}, {$addToSet: {'specialoffers': specialoffer._id}}, {multi: true}, function (err) {

                        // return
                        res.json(specialOfferJSON(specialoffer));

                    });

                });

            });

        },
        getAll: function (req, res) {
            var storeId = base64url.decode(req.params.id);

            model.SpecialOffer.find({'owner': req.user._id, 'stores': storeId }, function (err, specialoffers) {

                if (err) return errorHelper.serverError(res, err);

                var data = {};
                data.specialoffers = [];

                specialoffers.forEach(function (specialoffer) {
                    data.specialoffers.push(specialOfferJSON(specialoffer));
                });

                res.json(data);
            });

        },
        get: function (req, res) {
            var id = base64url.decode(req.params.id);

            model.SpecialOffer.findOne({'_id': id, 'owner': req.user._id}, function (err, specialoffer) {

                if (err) return errorHelper.serverError(res, err);
                if (!specialoffer) return errorHelper.specialofferNotFound(res);

                res.json(specialOfferJSON(specialoffer));

            });

        }


    };

};