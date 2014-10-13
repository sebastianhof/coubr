package com.coubr.web.json.store;

import com.coubr.data.entities.LocalBusinessEntity;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by sebastian on 13.10.14.
 */
public class Stores {

    private List<Store> stores;

    public Stores(List<LocalBusinessEntity> entities) {
        this.stores = new LinkedList<Store>();

        for (LocalBusinessEntity entity : entities) {
            stores.add(new Store(entity));
        }
    }

    public List<Store> getStores() {
        return stores;
    }

    public void setStores(List<Store> stores) {
        this.stores = stores;
    }

}
