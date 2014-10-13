package com.coubr.web.json.coupon;

import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.data.entities.OfferEntity;
import com.coubr.web.json.store.StoreDetails;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by sebastian on 13.10.14.
 */
public class CouponsDetails {

    private List<CouponDetails> coupons;

    public CouponsDetails(List<OfferEntity> entities) {
        this.coupons = new LinkedList<CouponDetails>();

        for (OfferEntity entity : entities) {
            coupons.add(new CouponDetails(entity));
        }
    }

    public List<CouponDetails> getCoupons() {
        return coupons;
    }

    public void setCoupons(List<CouponDetails> coupons) {
        this.coupons = coupons;
    }

}
