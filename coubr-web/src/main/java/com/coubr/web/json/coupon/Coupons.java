package com.coubr.web.json.coupon;

import com.coubr.data.entities.OfferEntity;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by sebastian on 13.10.14.
 */
public class Coupons {

    private List<Coupon> coupons;

    public Coupons(List<OfferEntity> entities) {
        this.coupons = new LinkedList<Coupon>();

        for (OfferEntity entity : entities) {
            coupons.add(new Coupon(entity));
        }
    }

    public List<Coupon> getCoupons() {
        return coupons;
    }

    public void setCoupons(List<Coupon> coupons) {
        this.coupons = coupons;
    }
}
