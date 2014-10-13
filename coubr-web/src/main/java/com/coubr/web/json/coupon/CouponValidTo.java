package com.coubr.web.json.coupon;

import com.coubr.data.entities.OfferEntity;
import com.coubr.web.services.ObfuscationService;
import com.coubr.web.validation.DateSerializer;
import com.coubr.web.validation.ValidToDateDeserializer;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.util.Date;

/**
 * Created by sebastian on 10.10.14.
 */
public class CouponValidTo {

    private String couponId;
    private Date validTo;

    public CouponValidTo(OfferEntity entity) {
        this.validTo = entity.getValidTo();
        this.couponId = ObfuscationService.encode(entity.getOfferId(), ObfuscationService.SALT_COUPON);
    }

    @JsonDeserialize(using = ValidToDateDeserializer.class)
    public Date getValidTo() {
        return validTo;
    }

    @JsonSerialize(using = DateSerializer.class)
    public void setValidTo(Date validTo) {
        this.validTo = validTo;
    }

    public String getCouponId() {
        return couponId;
    }

    public void setCouponId(String couponId) {
        this.couponId = couponId;
    }
}
