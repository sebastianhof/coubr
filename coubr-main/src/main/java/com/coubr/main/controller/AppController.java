package com.coubr.main.controller;

import com.coubr.app.exceptions.AppCouponNotFoundException;
import com.coubr.app.exceptions.AppStoreCodeNotFoundException;
import com.coubr.app.exceptions.AppStoreNotFoundException;
import com.coubr.app.json.*;
import com.coubr.app.services.ExploreService;
import com.coubr.app.services.RedeemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

/**
 * Created by sebastian on 28.09.14.
 */
@Controller
public class AppController {

    @Autowired
    ExploreService exploreService;

    @Autowired
    RedeemService redeemService;

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String index() {
        return "redirect:/app";
    }

    @RequestMapping(value = "/app", method = RequestMethod.GET)
    public String app() {
        return "app";
    }

    /*
     * Explore
     */

    @RequestMapping(value = "/a/explore", method = RequestMethod.POST)
    public @ResponseBody
    Explore explore(@Valid @RequestBody ExploreRequest exploreRequest, HttpServletRequest request) {

        return exploreService.handleRequest(exploreRequest);

    }

    /*
     * Store
     */

    @RequestMapping(value = "/a/store/{storeId}", method = RequestMethod.GET)
    public @ResponseBody
    Store store(@PathVariable(value = "storeId") String storeId, HttpServletRequest request) throws AppStoreNotFoundException {

        return exploreService.getStore(storeId);

    }

    /*
     * Redeem
     */

    @RequestMapping(value = "/a/coupon/{couponId}/redeem", method = RequestMethod.POST)
    public @ResponseBody Success redeemCoupon(@PathVariable(value = "couponId") String couponId, @RequestBody RedeemCoupon redeemCoupon, HttpServletRequest request) throws AppStoreCodeNotFoundException, AppCouponNotFoundException, AppStoreNotFoundException {

        redeemService.redeemCoupon(couponId, redeemCoupon);
        return new Success();
    }

    @RequestMapping(value = "/a/test", method = RequestMethod.GET)
    public @ResponseBody String test() {

        return "Hello World";

    }

}
