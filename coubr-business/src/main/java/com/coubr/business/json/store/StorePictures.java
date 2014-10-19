package com.coubr.business.json.store;

import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.data.utils.ObfuscationUtil;

/**
 * Created by sebastian on 09.10.14.
 */
public class StorePictures {

    private String storeId;

    public StorePictures(LocalBusinessEntity entity) {
        this.storeId = ObfuscationUtil.encode(entity.getLocalBusinessId(), ObfuscationUtil.SALT_LOCAL_BUSINESS);
    }

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }
}
