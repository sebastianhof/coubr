package com.coubr.app.json;

import com.coubr.data.entities.OfferEntity;
import com.coubr.data.utils.ObfuscationUtil;

import java.util.Date;

/**
 * Created by sebastian on 19/10/14.
 */
public class Coupon {

    // id
    private String i;

    // title
    private String t;

    // description
    private String d;

    // category
    private String c;

    // valid to
    private Date v;

    // amount
    private Long a;

    // amount issues
    private Long ai;

    // status
    private String s;

    public Coupon(OfferEntity offerEntity) {
        this.i = ObfuscationUtil.encode(offerEntity.getOfferId(), ObfuscationUtil.SALT_APP_COUPON);
        this.t = offerEntity.getTitle();
        this.d = offerEntity.getDescription();
        this.c = offerEntity.getCategory();
        this.v = offerEntity.getValidTo();
        this.a = offerEntity.getAmountToIssue();
        this.ai = offerEntity.getAmountIssued();
        this.s = offerEntity.getStatus().toString();
    }

    public String getI() {
        return i;
    }

    public void setI(String i) {
        this.i = i;
    }

    public String getT() {
        return t;
    }

    public void setT(String t) {
        this.t = t;
    }

    public String getD() {
        return d;
    }

    public void setD(String d) {
        this.d = d;
    }

    public String getC() {
        return c;
    }

    public void setC(String c) {
        this.c = c;
    }

    public Date getV() {
        return v;
    }

    public void setV(Date v) {
        this.v = v;
    }

    public Long getA() {
        return a;
    }

    public void setA(Long a) {
        this.a = a;
    }

    public Long getAi() {
        return ai;
    }

    public void setAi(Long ai) {
        this.ai = ai;
    }

    public String getS() {
        return s;
    }

    public void setS(String s) {
        this.s = s;
    }
}
