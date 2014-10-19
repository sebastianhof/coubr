package com.coubr.business.json.store;

import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.data.utils.ObfuscationUtil;

/**
 * Created by sebastian on 09.10.14.
 */
public class StoreSettings {

    private String storeId;
    private String name;
    private String description;
    private String street;
    private String postalCode;
    private String city;
    private String phone;
    private String email;
    private String type;
    private String category;
    private String subcategory;

    public StoreSettings(LocalBusinessEntity entity) {
        this.storeId = ObfuscationUtil.encode(entity.getLocalBusinessId(), ObfuscationUtil.SALT_LOCAL_BUSINESS);
        this.name = entity.getName();
        this.description = entity.getDescription();
        this.city = entity.getAddressLocality();
        this.postalCode = entity.getPostalCode();
        this.street = entity.getStreetAddress();
        this.phone = entity.getTelephone();
        this.email = entity.getEmail();
        this.type = entity.getType();
        this.category = entity.getCategory();
        this.subcategory = entity.getSubcategory();
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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


}
