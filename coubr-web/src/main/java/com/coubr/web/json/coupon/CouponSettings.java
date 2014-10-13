package com.coubr.web.json.coupon;

import com.coubr.data.entities.OfferEntity;
import com.coubr.web.services.ObfuscationService;
import com.coubr.web.validation.DateSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.util.Date;

/**
 * Created by sebastian on 10.10.14.
 */
public class CouponSettings {

    private String title;

    private String couponId;

    private String description;

    private String category;

    @JsonSerialize(using = DateSerializer.class)
    private Date validTo;

    private long amountToIssue;

    private long amountIssued;

    private String status;

    public CouponSettings(OfferEntity entity) {
        this.title = entity.getTitle();
        this.couponId = ObfuscationService.encode(entity.getOfferId(), ObfuscationService.SALT_COUPON);
        this.description = entity.getDescription();
        this.category = entity.getCategory();
        this.validTo = entity.getValidTo();
        this.amountToIssue = entity.getAmountToIssue();
        this.amountIssued = entity.getAmountIssued();
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Date getValidTo() {
        return validTo;
    }

    public void setValidTo(Date validTo) {
        this.validTo = validTo;
    }

    public long getAmountToIssue() {
        return amountToIssue;
    }

    public void setAmountToIssue(long amountToIssue) {
        this.amountToIssue = amountToIssue;
    }

    public long getAmountIssued() {
        return amountIssued;
    }

    public void setAmountIssued(long amountIssued) {
        this.amountIssued = amountIssued;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
