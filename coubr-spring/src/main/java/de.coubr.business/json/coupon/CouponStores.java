package com.coubr.business.json.coupon;

import com.coubr.business.json.store.Store;
import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.data.entities.OfferEntity;
import com.coubr.data.utils.ObfuscationUtil;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by sebastian on 10.10.14.
 */
public class CouponStores {

    private String couponId;

    private List<Store> stores;

    public CouponStores(OfferEntity entity) {
        this.couponId = ObfuscationUtil.encode(entity.getOfferId(), ObfuscationUtil.SALT_COUPON);

        this.stores = new LinkedList<Store>();
        for (LocalBusinessEntity localBusinessEntity : entity.getLocalBusinesses()) {
            stores.add(new Store(localBusinessEntity));
        }

    }

    public String getCouponId() {
        return couponId;
    }

    public void setCouponId(String couponId) {
        this.couponId = couponId;
    }

    public List<Store> getStores() {
        return stores;
    }

    public void setStores(List<Store> stores) {
        this.stores = stores;
    }
}
