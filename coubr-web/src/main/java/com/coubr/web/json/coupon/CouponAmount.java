package com.coubr.web.json.coupon;

import com.coubr.data.entities.OfferEntity;
import com.coubr.web.services.ObfuscationService;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

/**
 * Created by sebastian on 10.10.14.
 */
public class CouponAmount {

    private String couponId;

    @NotNull
    @Min(0) // 0 means unlimited
    private long amountToIssue;

    private long amountIsseud;

    public CouponAmount(OfferEntity entity) {
        this.couponId = ObfuscationService.encode(entity.getOfferId(), ObfuscationService.SALT_COUPON);
        this.amountToIssue = entity.getAmountToIssue();
        this.amountIsseud = entity.getAmountIssued();
    }

    public String getCouponId() {
        return couponId;
    }

    public void setCouponId(String couponId) {
        this.couponId = couponId;
    }

    public long getAmountToIssue() {
        return amountToIssue;
    }

    public void setAmountToIssue(long amountToIssue) {
        this.amountToIssue = amountToIssue;
    }

    public long getAmountIsseud() {
        return amountIsseud;
    }

    public void setAmountIsseud(long amountIsseud) {
        this.amountIsseud = amountIsseud;
    }
}
