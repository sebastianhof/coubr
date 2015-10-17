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

var error = function (code) {
    return {
        code: code
    };
};

module.exports = {

    // not found
    notLoggedIn: function (res) {
        res.status(400).json(error("40000"));
    },
    emailNotFound: function (res) {
        res.status(400).json(error("40001"));
    },
    passwordNotFound: function (res) {
        res.status(400).json(error("40002"));
    },
    codeNotFound: function (res) {
        res.status(400).json(error("40003"));
    },
    confirmed: function (res) {
        res.status(400).json(error("40005"));
    },
    expired: function (res) {
        res.status(400).json(error("40006"));
    },
    storeNotFound: function (res) {
        res.status(400).json(error("40007"));
    },
    locationNotFound: function (res) {
        res.status(400).json(error("40008"));
    },
    categoryNotFound: function (res) {
        res.status(400).json(error("40009"));
    },
    couponNotFound: function (res) {
        res.status(400).json(error("40010"));
    },
    invalidAmount: function (res) {
        res.status(400).json(error("40011"));
    },
    stampcardNotFound: function (res) {
        res.status(400).json(error("40012"));
    },
    specialofferNotFound: function (res) {
        res.status(400).json(error("40013"));
    },
    validationError: function (res) {
        res.status(400).json(error("40099"));
    },
    // conflict
    emailConflict: function (res) {
        res.status(409).json(error("40901"));
    },
    beaconConflict: function (res) {
        res.status(409).json(error("40902"));
    },
    // server errors
    serverError: function (res, err) {
        console.log(err);
        res.status(500).json(error("50000"));
    },
    messageError: function (res, err) {
        console.log(err);
        res.status(500).json(error("50001"));
    }


};
