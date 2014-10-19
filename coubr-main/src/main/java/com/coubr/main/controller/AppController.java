package com.coubr.main.controller;

import com.coubr.app.exceptions.AppStoreNotFoundException;
import com.coubr.app.json.Coupon;
import com.coubr.app.json.Explore;
import com.coubr.app.json.ExploreRequest;
import com.coubr.app.json.Store;
import com.coubr.app.services.ExploreService;
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

    @RequestMapping(value = "/a/store/{storeId}")
    public @ResponseBody
    Store store(@PathVariable(value = "storeId") String storeId, HttpServletRequest request) throws AppStoreNotFoundException {

        return exploreService.getStore(storeId);

    }

//    @RequestMapping(value = "/a/coupon/{couponId}")
//    public @ResponseBody
//    Coupon coupon(@PathVariable(value = "couponId") String couponId, HttpServletRequest request) {
//
//        return exploreService.getCoupon(couponId);
//
//    }

    @RequestMapping(value = "/a/test", method = RequestMethod.GET)
    public @ResponseBody String test() {

        return "Hello World";

    }

}
