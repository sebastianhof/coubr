package com.coubr.business.json.store;

import com.coubr.data.entities.LocalBusinessEntity;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by sebastian on 13.10.14.
 */
public class StoresDetails {

    private List<StoreDetails> stores;

    public StoresDetails(List<LocalBusinessEntity> entities) {
        this.stores = new LinkedList<StoreDetails>();

        for (LocalBusinessEntity entity : entities) {
            stores.add(new StoreDetails(entity));
        }
    }

    public List<StoreDetails> getStores() {
        return stores;
    }

    public void setStores(List<StoreDetails> stores) {
        this.stores = stores;
    }

}
