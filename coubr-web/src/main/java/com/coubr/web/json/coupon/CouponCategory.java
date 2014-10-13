package com.coubr.web.json.coupon;

import com.coubr.data.GlobalDataLengthConstants;
import com.coubr.data.entities.OfferEntity;
import com.coubr.web.services.ObfuscationService;

import javax.validation.constraints.Size;

/**
 * Created by sebastian on 10.10.14.
 */
public class CouponCategory {

    private String couponId;

    @Size(max = GlobalDataLengthConstants.ID_LENGTH)
    private String category;

    public CouponCategory(OfferEntity entity) {
        this.couponId = ObfuscationService.encode(entity.getOfferId(), ObfuscationService.SALT_COUPON);
        this.category = entity.getCategory();
    }

    public String getCouponId() {
        return couponId;
    }

    public void setCouponId(String couponId) {
        this.couponId = couponId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}
