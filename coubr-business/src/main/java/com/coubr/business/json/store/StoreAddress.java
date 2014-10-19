package com.coubr.business.json.store;

import com.coubr.data.GlobalDataLengthConstants;
import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.data.utils.ObfuscationUtil;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 * Created by sebastian on 09.10.14.
 */
public class StoreAddress {

    private String storeId;

    @NotNull
    @Size(max = GlobalDataLengthConstants.NAME_LENGTH)
    private String street;

    @NotNull
    @Size(max = GlobalDataLengthConstants.POSTAL_CODE_LENGTH)
    private String postalCode;

    @NotNull
    @Size(max = GlobalDataLengthConstants.NAME_LENGTH)
    private String city;

    public StoreAddress() {
        // empty constructor
    }

    public StoreAddress(LocalBusinessEntity entity) {
        this.storeId = ObfuscationUtil.encode(entity.getLocalBusinessId(), ObfuscationUtil.SALT_LOCAL_BUSINESS);
        this.street = entity.getStreetAddress();
        this.postalCode = entity.getPostalCode();
        this.city = entity.getAddressLocality();
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }
}
