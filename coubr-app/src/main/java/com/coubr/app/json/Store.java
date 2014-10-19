package com.coubr.app.json;

import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.data.entities.OfferEntity;
import com.coubr.data.utils.ObfuscationUtil;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by sebastian on 19/10/14.
 */
public class Store {

    // id
    private String i;

    // name
    private String n;

    // description
    private String d;

    // type
    private String t;

    // category
    private String c;

    // subcategory
    private String s;

    // latitude
    private double lt;

    // longitude
    private double lg;

    // street
    private String as;

    // postal code
    private String ap;

    // city
    private String ac;

    // telephone
    private String ct;

    // email
    private String ce;

    // coupons
    private List<Coupon> co;

    public Store(LocalBusinessEntity entity) {
        this.i = ObfuscationUtil.encode(entity.getLocalBusinessId(), ObfuscationUtil.SALT_APP_LOCAL_BUSINESS);
        this.n = entity.getName();
        this.d = entity.getDescription();
        this.t = entity.getType();
        this.c = entity.getCategory();
        this.s = entity.getSubcategory();

        this.lt = entity.getGeoLatitude();
        this.lg = entity.getGeoLongitude();

        this.as = entity.getStreetAddress();
        this.ap = entity.getPostalCode();
        this.ac = entity.getAddressLocality();

        this.ct = entity.getTelephone();
        this.ce = entity.getEmail();

        co = new LinkedList<Coupon>();
        for (OfferEntity offerEntity: entity.getOffers()) {
            co.add(new Coupon(offerEntity));
        }
    }

    public String getI() {
        return i;
    }

    public void setI(String i) {
        this.i = i;
    }

    public String getN() {
        return n;
    }

    public void setN(String n) {
        this.n = n;
    }

    public String getD() {
        return d;
    }

    public void setD(String d) {
        this.d = d;
    }

    public String getT() {
        return t;
    }

    public void setT(String t) {
        this.t = t;
    }

    public String getC() {
        return c;
    }

    public void setC(String c) {
        this.c = c;
    }

    public String getS() {
        return s;
    }

    public void setS(String s) {
        this.s = s;
    }

    public double getLt() {
        return lt;
    }

    public void setLt(double lt) {
        this.lt = lt;
    }

    public double getLg() {
        return lg;
    }

    public void setLg(double lg) {
        this.lg = lg;
    }

    public String getAs() {
        return as;
    }

    public void setAs(String as) {
        this.as = as;
    }

    public String getAp() {
        return ap;
    }

    public void setAp(String ap) {
        this.ap = ap;
    }

    public String getAc() {
        return ac;
    }

    public void setAc(String ac) {
        this.ac = ac;
    }

    public String getCt() {
        return ct;
    }

    public void setCt(String ct) {
        this.ct = ct;
    }

    public String getCe() {
        return ce;
    }

    public void setCe(String ce) {
        this.ce = ce;
    }

    public List<Coupon> getCo() {
        return co;
    }

    public void setCo(List<Coupon> co) {
        this.co = co;
    }
}
