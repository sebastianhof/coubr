package com.coubr.business.json.store;

import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.data.utils.ObfuscationUtil;

/**
 * Created by sebastian on 04.10.14.
 */
public class Store {

    private String name;
    private String storeId;

    public Store(final LocalBusinessEntity entity) {
        this.storeId = ObfuscationUtil.encode(entity.getLocalBusinessId(), ObfuscationUtil.SALT_LOCAL_BUSINESS);
        this.name = entity.getName();
    }

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }


}
