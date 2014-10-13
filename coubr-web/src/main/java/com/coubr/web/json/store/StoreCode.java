package com.coubr.web.json.store;

import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.web.services.ObfuscationService;
import com.google.common.io.BaseEncoding;
import com.google.common.primitives.Longs;

/**
 * Created by sebastian on 09.10.14.
 */
public class StoreCode {

    private String storeId;

    public StoreCode(LocalBusinessEntity entity) {
        this.storeId = ObfuscationService.encode(entity.getLocalBusinessId(), ObfuscationService.SALT_LOCAL_BUSINESS);
    }

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }

}
