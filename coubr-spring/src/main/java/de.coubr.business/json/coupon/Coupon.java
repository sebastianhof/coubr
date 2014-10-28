package com.coubr.business.json.coupon;

import com.coubr.data.entities.OfferEntity;
import com.coubr.data.utils.ObfuscationUtil;

/**
 * Created by sebastian on 04.10.14.
 */
public class Coupon {

    private String title;

    private String couponId;

    private String status;

    public Coupon(OfferEntity entity) {
        this.title = entity.getTitle();
        this.couponId = ObfuscationUtil.encode(entity.getOfferId(), ObfuscationUtil.SALT_COUPON);
        this.status = entity.getStatus().toString();
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCouponId() {
        return couponId;
    }

    public void setCouponId(String couponId) {
        this.couponId = couponId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
