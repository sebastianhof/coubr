package com.coubr.web.json.store;

import com.coubr.data.GlobalDataLengthConstants;
import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.web.services.ObfuscationService;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 * Created by sebastian on 09.10.14.
 */
public class StoreName {

    private String storeId;

    @NotNull
    @Size(max = GlobalDataLengthConstants.NAME_LENGTH)
    private String name;

    @Size(max = GlobalDataLengthConstants.DESCRIPTION_LENGTH)
    private String description;

    public StoreName(LocalBusinessEntity entity) {
        this.storeId = ObfuscationService.encode(entity.getLocalBusinessId(), ObfuscationService.SALT_LOCAL_BUSINESS);
        this.name = entity.getName();
        this.description = entity.getDescription();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }
}
