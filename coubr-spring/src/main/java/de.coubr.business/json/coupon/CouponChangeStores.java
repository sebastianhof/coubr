package com.coubr.business.json.coupon;

import javax.validation.constraints.NotNull;
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
