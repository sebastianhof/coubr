package com.coubr.app.json;

import com.coubr.data.entities.OfferEntity;
import com.coubr.data.utils.ObfuscationUtil;

/**
 * Created by sebastian on 19/10/14.
 */
public class ExploreCoupon {

    // id
    private String ci;

    // title
    private String ct;

    // status
    private String cs;

    public ExploreCoupon(OfferEntity offerEntity) {
        this.ci = ObfuscationUtil.encode(offerEntity.getOfferId(), ObfuscationUtil.SALT_APP_COUPON);
        this.ct = offerEntity.getTitle();
        this.cs = offerEntity.getStatus().toString();
    }

    public String getCi() {
        return ci;
    }

    public void setCi(String ci) {
        this.ci = ci;
    }

    public String getCt() {
        return ct;
    }

    public void setCt(String ct) {
        this.ct = ct;
    }

    public String getCs() {
        return cs;
    }

    public void setCs(String cs) {
        this.cs = cs;
    }
}
