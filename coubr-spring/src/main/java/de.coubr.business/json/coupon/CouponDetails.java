package com.coubr.business.json.coupon;

import com.coubr.business.json.store.Store;
import com.coubr.business.validation.DateSerializer;
import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.data.entities.OfferEntity;
import com.coubr.data.utils.ObfuscationUtil;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.util.Date;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by sebastian on 04.10.14.
 */
public class CouponDetails {

    private String title;

    private String couponId;

    private String description;

    private String category;

    @JsonSerialize(using = DateSerializer.class)
    private Date validTo;

    private long amountToIssue;

    private long amountIssued;

    private String status;

    private List<Store> stores;

    public CouponDetails(OfferEntity entity) {

        this.title = entity.getTitle();
        this.couponId = ObfuscationUtil.encode(entity.getOfferId(), ObfuscationUtil.SALT_COUPON);
        this.description = entity.getDescription();
        this.category = entity.getDescription();
        this.validTo = entity.getValidTo();
        this.amountToIssue = entity.getAmountToIssue();
        this.amountIssued = entity.getAmountIssued();
        this.status = entity.getStatus().toString();

        this.stores = new LinkedList<Store>();
        for (LocalBusinessEntity localBusinessEntity : entity.getLocalBusinesses()) {
            stores.add(new Store(localBusinessEntity));
        }

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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public List<Store> getStores() {
        return stores;
    }

    public void setStores(List<Store> stores) {
        this.stores = stores;
    }


}
