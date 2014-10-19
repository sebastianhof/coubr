package com.coubr.app.json;

import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.data.entities.OfferEntity;
import com.coubr.data.utils.ObfuscationUtil;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by sebastian on 15.10.14.
 */
public class ExploreStore {

    // id
    private String si;

    // name
    private String sn;

    // type
    private String st;

    // category
    private String sc;

    // subcategory
    private String ss;

    // latitude
    private double lt;

    // longitude
    private double lg;

    // coupons
    private List<ExploreCoupon> c;

    public ExploreStore(LocalBusinessEntity entity) {
        si = ObfuscationUtil.encode(entity.getLocalBusinessId(), ObfuscationUtil.SALT_APP_LOCAL_BUSINESS);
        sn = entity.getName();
        st = entity.getType();
        sc = entity.getCategory();
        ss = entity.getSubcategory();
        lt = entity.getGeoLatitude();
        lg = entity.getGeoLongitude();

        c = new LinkedList<ExploreCoupon>();
        for (OfferEntity offerEntity: entity.getOffers()) {
            c.add(new ExploreCoupon(offerEntity));
        }
    }

    public String getSi() {
        return si;
    }

    public void setSi(String si) {
        this.si = si;
    }

    public String getSn() {
        return sn;
    }

    public void setSn(String sn) {
        this.sn = sn;
    }

    public String getSt() {
        return st;
    }

    public void setSt(String st) {
        this.st = st;
    }

    public String getSc() {
        return sc;
    }

    public void setSc(String sc) {
        this.sc = sc;
    }

    public String getSs() {
        return ss;
    }

    public void setSs(String ss) {
        this.ss = ss;
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

    public List<ExploreCoupon> getC() {
        return c;
    }

    public void setC(List<ExploreCoupon> c) {
        this.c = c;
    }
}
