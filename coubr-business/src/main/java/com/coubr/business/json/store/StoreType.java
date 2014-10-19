package com.coubr.business.json.store;

import com.coubr.data.GlobalDataLengthConstants;
import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.data.utils.ObfuscationUtil;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 * Created by sebastian on 09.10.14.
 */
public class StoreType {

    private String storeId;

    @NotNull
    @Size(max = GlobalDataLengthConstants.ID_LENGTH)
    private String type;

    @Size(max = GlobalDataLengthConstants.ID_LENGTH)
    private String category;

    @Size(max = GlobalDataLengthConstants.ID_LENGTH)
    private String subcategory;

    public StoreType() {
        // empty constructor
    }

    public StoreType(LocalBusinessEntity entity) {
        this.storeId = ObfuscationUtil.encode(entity.getLocalBusinessId(), ObfuscationUtil.SALT_LOCAL_BUSINESS);
        this.type = entity.getType();
        this.category = entity.getCategory();
        this.subcategory = entity.getSubcategory();
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getSubcategory() {
        return subcategory;
    }

    public void setSubcategory(String subcategory) {
        this.subcategory = subcategory;
    }

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }
}
