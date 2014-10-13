package com.coubr.web.json.coupon;

import com.coubr.data.GlobalDataLengthConstants;
import com.coubr.data.entities.OfferEntity;
import com.coubr.web.services.ObfuscationService;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 * Created by sebastian on 10.10.14.
 */
public class CouponTitle {

    private String couponId;

    @NotNull
    @Size(max = GlobalDataLengthConstants.NAME_LENGTH)
    private String title;

    @Size(max = GlobalDataLengthConstants.DESCRIPTION_LENGTH)
    private String description;

    public CouponTitle(OfferEntity entity) {
        this.title = entity.getTitle();
        this.description = entity.getDescription();
        this.couponId = ObfuscationService.encode(entity.getOfferId(), ObfuscationService.SALT_COUPON);
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCouponId() {
        return couponId;
    }

    public void setCouponId(String couponId) {
        this.couponId = couponId;
    }
}
