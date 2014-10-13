package com.coubr.web.json.coupon;

import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.data.entities.OfferEntity;
import com.coubr.web.json.store.Store;
import com.coubr.web.services.ObfuscationService;

import javax.validation.constraints.NotNull;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by sebastian on 10.10.14.
 */
public class CouponChangeStores {

    @NotNull
    private List<String> stores;

    public List<String> getStores() {
        return stores;
    }

    public void setStores(List<String> stores) {
        this.stores = stores;
    }
}
