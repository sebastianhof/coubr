package com.coubr.business.json.store;

import com.coubr.data.GlobalDataLengthConstants;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 * Created by sebastian on 07.10.14.
 */
public class AddStore {

    @NotNull
    @Size(max = GlobalDataLengthConstants.NAME_LENGTH)
    private String name;

    @Size(max = GlobalDataLengthConstants.DESCRIPTION_LENGTH)
    private String description;

    @NotNull
    @Size(max = GlobalDataLengthConstants.NAME_LENGTH)
    private String street;

    @NotNull
    @Size(max = GlobalDataLengthConstants.POSTAL_CODE_LENGTH)
    private String postalCode;

    @NotNull
    @Size(max = GlobalDataLengthConstants.NAME_LENGTH)
    private String city;

    @Size(max = GlobalDataLengthConstants.TELEPHONE_LENGTH)
    private String phone;

    @Size(max = GlobalDataLengthConstants.EMAIL_LENGTH)
    private String email;

    @NotNull
    @Size(max = GlobalDataLengthConstants.ID_LENGTH)
    private String type;

    @Size(max = GlobalDataLengthConstants.ID_LENGTH)
    private String category;

    @Size(max = GlobalDataLengthConstants.ID_LENGTH)
    private String subcategory;

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
