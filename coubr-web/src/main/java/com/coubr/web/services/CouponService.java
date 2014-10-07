package com.coubr.web.services;

import com.coubr.web.json.coupon.Coupon;
import com.coubr.web.json.coupon.CouponDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by sebastian on 05.10.14.
 */
@Service(value = "couponService")
@Transactional
public class CouponService {

    public List<Coupon> getCoupons(String email) {

        return null;
    }

    public List<CouponDetails> getCouponsWithDetails(String email) {


        return null;
    }

    public CouponDetails getCoupon(String email, String coupon) {

        return null;
    }

}
