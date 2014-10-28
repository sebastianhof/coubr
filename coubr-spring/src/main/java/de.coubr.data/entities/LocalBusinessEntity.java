package com.coubr.data.entities;

import com.coubr.data.GlobalDataLengthConstants;

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

    @Column(nullable = true, length = GlobalDataLengthConstants.DESCRIPTION_LENGTH)
    private String description;

    @Column(nullable = false, length = GlobalDataLengthConstants.ID_LENGTH)
    private String type;

    @Column(nullable = true, length = GlobalDataLengthConstants.ID_LENGTH)
    private String category;

    @Column(nullable = true, length = GlobalDataLengthConstants.ID_LENGTH)
    private String subcategory;

    /*
     * Contact point
     */

    @Column(nullable = true, length = GlobalDataLengthConstants.TELEPHONE_LENGTH)
    private String telephone;

    @Column(nullable = true, length = GlobalDataLengthConstants.EMAIL_LENGTH)
    private String email;

    /*
     * Postal Address
     */

    @Column(nullable = false, length = GlobalDataLengthConstants.ISO_3166_2_LENGTH)
    private String addressCountry;

    @Column(nullable = false, length = GlobalDataLengthConstants.ISO_3166_2_LENGTH)
    private String addressRegion;

    @Column(nullable = false, length = GlobalDataLengthConstants.NAME_LENGTH)
    private String addressLocality;

    @Column(nullable = false, length = GlobalDataLengthConstants.POSTAL_CODE_LENGTH)
    private String postalCode;

    @Column(nullable = false, length = GlobalDataLengthConstants.NAME_LENGTH)
    private String streetAddress;

     /*
     * Geo Location
     */


    @Column(nullable = false)
    private double geoLongitude;

    @Column(nullable = false)
    private double geoLatitude;

    @Column(nullable = false, unique = true, length = GlobalDataLengthConstants.QR_CODE_LENGTH)
    private String storeCode;

    // Owner
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "businessOwnerId")
    private BusinessOwnerEntity businessOwner;

    // Coupons
    @ManyToMany(mappedBy="localBusinesses", fetch = FetchType.EAGER)
    private List<OfferEntity> offers;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getSubcategory() {
        return subcategory;
    }

    public void setSubcategory(String subcategory) {
        this.subcategory = subcategory;
    }

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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

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

    public String getStoreCode() {
        return storeCode;
    }

    public void setStoreCode(String storeCode) {
        this.storeCode = storeCode;
    }

    public BusinessOwnerEntity getBusinessOwner() {
        return businessOwner;
    }

    public void setBusinessOwner(BusinessOwnerEntity businessOwner) {
        this.businessOwner = businessOwner;
    }

    public List<OfferEntity> getOffers() {
        return offers;
    }

    public void setOffers(List<OfferEntity> offers) {
        this.offers = offers;
    }

    public boolean containsOffer(OfferEntity offerEntity) {
        return offers.contains(offerEntity);
    }

    public void addOffer(OfferEntity offerEntity) {
        if (!offers.contains(offerEntity)) {
            offers.add(offerEntity);
        }
    }

    public void removeOffer(OfferEntity offerEntity) {
        if (offers.contains(offerEntity)) {
            offers.remove(offerEntity);
        }
    }

    @Override
    public boolean equals(Object obj) {

        if (obj instanceof LocalBusinessEntity) {

            LocalBusinessEntity localBusinessEntity = (LocalBusinessEntity) obj;

            if (localBusinessEntity.getLocalBusinessId() == localBusinessId) {
                return true;
            }

        }

        return false;
    }

    @Override
    public int hashCode() {
        return new Long(localBusinessId).hashCode();
    }

}
