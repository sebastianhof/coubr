package com.coubr.web.json.coupon;

import com.coubr.web.json.localbusiness.LocalBusiness;

import java.util.Date;
import java.util.List;

/**
 * Created by sebastian on 04.10.14.
 */
public class CouponDetails {

    private String title;

    private String couponId;

    private String description;

    private Date fromDate;

    private Date toDate;

    private int remainingAmount;

    private int totalAmount;

    private List<LocalBusiness> localBusinesses;

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

    public Date getFromDate() {
        return fromDate;
    }

    public void setFromDate(Date fromDate) {
        this.fromDate = fromDate;
    }

    public Date getToDate() {
        return toDate;
    }

    public void setToDate(Date toDate) {
        this.toDate = toDate;
    }

    public int getRemainingAmount() {
        return remainingAmount;
    }

    public void setRemainingAmount(int remainingAmount) {
        this.remainingAmount = remainingAmount;
    }

    public int getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(int totalAmount) {
        this.totalAmount = totalAmount;
    }

    public List<LocalBusiness> getLocalBusinesses() {
        return localBusinesses;
    }

    public void setLocalBusinesses(List<LocalBusiness> localBusinesses) {
        this.localBusinesses = localBusinesses;
    }
}
