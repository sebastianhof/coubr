package com.coubr.data.entities;

import com.coubr.data.types.LocalBusinessSpecificType;

import javax.persistence.*;
import java.util.List;

/**
 * Created by sebastian on 27.09.14.
 */

@Entity
@Table(name = "LocalBusinessEntity")
public class LocalBusinessEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long localBusinessId;

    @Column(nullable = false)
    private String name;


    private String description;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private LocalBusinessSpecificType type;


    private String labels;

    /*
     * Contact point
     */

    @Column(nullable = false)
    private String telephone;

    @Column(nullable = false)
    private String email;

    //private Set<LocalBusinessOpeningHour> openingHours;

    /*
     * Postal Address
     */

    @Column(nullable = false)
    private String addressCountry;

    @Column(nullable = false)
    private String addressLocality;

    private String addressRegion;

    @Column(nullable = false)
    private String postalCode;

    @Column(nullable = false)
    private String streetAddress;

    /*
     * Geo Location
     */

    private double geoLongitude;

    private double geoLatitude;

    // Owner
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "businessOwnerId")
    private BusinessOwnerEntity businessOwner;

    // Coupon
    @OneToMany(mappedBy = "store")
    private List<CouponEntity> coupons;

    /*
     Getter and Setter
      */

    public long getLocalBusinessId() {
        return localBusinessId;
    }

    public void setLocalBusinessId(long localBusinessId) {
        this.localBusinessId = localBusinessId;
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

    public LocalBusinessSpecificType getType() {
        return type;
    }

    public void setType(LocalBusinessSpecificType type) {
        this.type = type;
    }

    public String getLabels() {
        return labels;
    }

    public void setLabels(String labels) {
        this.labels = labels;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

//    public Set<LocalBusinessOpeningHour> getOpeningHours() {
//        return openingHours;
//    }
//
//    public void setOpeningHours(Set<LocalBusinessOpeningHour> openingHours) {
//        this.openingHours = openingHours;
//    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getAddressCountry() {
        return addressCountry;
    }

    public void setAddressCountry(String addressCountry) {
        this.addressCountry = addressCountry;
    }

    public String getAddressRegion() {
        return addressRegion;
    }

    public void setAddressRegion(String addressRegion) {
        this.addressRegion = addressRegion;
    }

    public String getStreetAddress() {
        return streetAddress;
    }

    public void setStreetAddress(String streetAddress) {
        this.streetAddress = streetAddress;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public String getAddressLocality() {
        return addressLocality;
    }

    public void setAddressLocality(String addressLocality) {
        this.addressLocality = addressLocality;
    }

    public double getGeoLongitude() {
        return geoLongitude;
    }

    public void setGeoLongitude(double geoLongitude) {
        this.geoLongitude = geoLongitude;
    }

    public double getGeoLatitude() {
        return geoLatitude;
    }

    public void setGeoLatitude(double geoLatitude) {
        this.geoLatitude = geoLatitude;
    }

    public BusinessOwnerEntity getBusinessOwner() {
        return businessOwner;
    }

    public void setBusinessOwner(BusinessOwnerEntity businessOwner) {
        this.businessOwner = businessOwner;
    }

    public List<CouponEntity> getCoupons() {
        return coupons;
    }

    public void setCoupons(List<CouponEntity> coupons) {
        this.coupons = coupons;
    }

}
