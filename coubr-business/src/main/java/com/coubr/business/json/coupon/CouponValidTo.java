package com.coubr.business.json.coupon;

import com.coubr.business.validation.DateSerializer;
import com.coubr.business.validation.ValidToDateDeserializer;
import com.coubr.data.entities.OfferEntity;
import com.coubr.data.utils.ObfuscationUtil;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import javax.validation.constraints.NotNull;
import java.util.Date;

/**
 * Created by sebastian on 10.10.14.
 */
public class CouponValidTo {

    private String couponId;

    @NotNull
    @JsonSerialize(using = DateSerializer.class)
    @JsonDeserialize(using = ValidToDateDeserializer.class)
    private Date validTo;

    public CouponValidTo() {
        // empty constructor
    }

    public CouponValidTo(OfferEntity entity) {
        this.validTo = entity.getValidTo();
        this.couponId = ObfuscationUtil.encode(entity.getOfferId(), ObfuscationUtil.SALT_COUPON);
    }

    public Date getValidTo() {
        return validTo;
    }

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
