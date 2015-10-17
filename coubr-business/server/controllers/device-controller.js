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

    var beaconJSONs = function (beacons) {
        var array = [];

        beacons.forEach(function (entry) {
            array.push({
                beaconId: base64url.encode(entry._id.toString()),
                name: entry.name,
                location: entry.location,
                uuid: entry.uuid
            });
        })

        return array;
    }

    var deviceJSON = function (store) {

        return {

            beacons: beaconJSONs(store.beacons)
        };

    };

    return {
        getAll: function (req, res) {
            var id = base64url.decode(req.params.id);

            model.Store.findOne({'_id': id, 'owner': req.user._id}, function (err, store) {

                if (err) return errorHelper.serverError(res, err);
                if (!store) return errorHelper.storeNotFound(res);

                res.json(deviceJSON(store));

            });

        },
        addBeacon: function (req, res) {
            req.checkBody('name').notEmpty();
            req.checkBody('uuid').notEmpty().matches(/[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}/);

            if (req.validationErrors()) return errorHelper.validationError(res);

            // sanitize
            req.sanitize('title').trim();
            req.sanitize('title').escape();
            req.sanitize('uuid').trim();

            var id = base64url.decode(req.params.id);
            var data = req.body;

            model.Store.findOne({'_id': id, 'owner': req.user._id}, function (err, store) {

                if (err) return errorHelper.serverError(res, err);
                if (!store) return errorHelper.storeNotFound(res);

                store.beacons.forEach(function (entry) {
                    if (entry.uuid == data.uuid) return errorHelper.beaconConflict(res);
                });

                store.beacons.push({
                    name: data.name,
                    location: data.location,
                    uuid: data.uuid
                });

                store.save(function (err) {
                    if (err) return errorHelper.serverError(res, err);

                    res.json("ok");
                });

            });

        },
        qrcode: function (req, res) {
            var id = base64url.decode(req.params.id);

            model.Store.findOne({'_id': id, 'owner': req.user._id}, function (err, store) {

                if (err) return errorHelper.serverError(res, err);

                if (!store) return errorHelper.storeNotFound(res);

                var qr = require('qr-image');
                var code = qr.image('coubrStore:' + store.code, {type: 'svg'});
                res.type('svg');
                code.pipe(res);
            });

        }

    }
};