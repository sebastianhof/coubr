package com.coubr.web.json.store;

import com.coubr.data.GlobalDataLengthConstants;
import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.web.services.ObfuscationService;

import javax.validation.constraints.Size;

/**
 * Created by sebastian on 09.10.14.
 */
public class StoreContact {

    private String storeId;

    @Size(max = GlobalDataLengthConstants.TELEPHONE_LENGTH)
    private String phone;

    @Size(max = GlobalDataLengthConstants.EMAIL_LENGTH)
    private String email;

    public StoreContact(LocalBusinessEntity entity) {
        this.storeId = ObfuscationService.encode(entity.getLocalBusinessId(), ObfuscationService.SALT_LOCAL_BUSINESS);
        this.phone = entity.getTelephone();
        this.email = entity.getEmail();
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }
}
