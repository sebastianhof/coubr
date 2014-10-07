package com.coubr.web.json.localbusiness;

import com.coubr.web.json.coupon.Coupon;

import java.util.List;

/**
 * Created by sebastian on 04.10.14.
 */
public class LocalBusinessDetails {

    private String name;

    private String localBusinessId;

    private String street;

    private String zipCode;

    private String city;

    private String phone;

    private List<Coupon> coupons;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocalBusinessId() {
        return localBusinessId;
    }

    public void setLocalBusinessId(String localBusinessId) {
        this.localBusinessId = localBusinessId;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getZipCode() {
        return zipCode;
    }

    public void setZipCode(String zipCode) {
        this.zipCode = zipCode;
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

    public List<Coupon> getCoupons() {
        return coupons;
    }

    public void setCoupons(List<Coupon> coupons) {
        this.coupons = coupons;
    }
}
