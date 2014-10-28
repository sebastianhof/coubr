package com.coubr.data.entities;

import com.coubr.data.GlobalDataLengthConstants;
import com.coubr.data.types.OfferStatus;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

/**
 * Created by sebastian on 28.09.14.
 */
@Entity
@Table(name = "OfferEntity")
public class OfferEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long offerId;

    @Column(nullable = false, length = GlobalDataLengthConstants.NAME_LENGTH)
    private String title;

    @Column(nullable = true, length = GlobalDataLengthConstants.DESCRIPTION_LENGTH)
    private String description;

    @Column(nullable = false, length = GlobalDataLengthConstants.ID_LENGTH)
    private String type;

    @Column(nullable = true, length = GlobalDataLengthConstants.ID_LENGTH)
    private String category;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(nullable = false)
    private Date validTo;

    @Column(nullable = false)
    private long amountToIssue = 100; // unlimited

    @Column(nullable = false)
    private long amountIssued = 0;

    @Column(nullable = false)
    private boolean activated = true;



    @Column(nullable = false, unique = true, length = GlobalDataLengthConstants.QR_CODE_LENGTH)
    private String couponCode;

    // Owner
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "businessOwnerId")
    private BusinessOwnerEntity businessOwner;

    // Local Businesses
    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
            name = "OfferLocalBusinessEntity",
            joinColumns = {@JoinColumn(name = "offerId", referencedColumnName = "offerId")},
            inverseJoinColumns = {@JoinColumn(name= "localBusinessId", referencedColumnName = "localBusinessId")}
    )
    private List<LocalBusinessEntity> localBusinesses;

    /*
     Getter and Setter
      */

    public long getOfferId() {
        return offerId;
    }

    public void setOfferId(long offerId) {
        this.offerId = offerId;
    }


    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public BusinessOwnerEntity getBusinessOwner() {
        return businessOwner;
    }

    public void setBusinessOwner(BusinessOwnerEntity businessOwner) {
        this.businessOwner = businessOwner;
    }

    public List<LocalBusinessEntity> getLocalBusinesses() {
        return localBusinesses;
    }

    public void setLocalBusinesses(List<LocalBusinessEntity> localBusinesses) {
        this.localBusinesses = localBusinesses;
    }

    public boolean containsLocalBusiness(LocalBusinessEntity entity) {
        return this.localBusinesses.contains(entity);
    }

    public void addLocalBusiness(LocalBusinessEntity entity) {
        if (!containsLocalBusiness(entity)) {
            this.localBusinesses.add(entity);
        }
    }

    public void removeLocalBusiness(LocalBusinessEntity entity) {
        if (containsLocalBusiness(entity)) {
            this.localBusinesses.remove(entity);
        }
    }

    public Date getValidTo() {
        return validTo;
    }

    public void setValidTo(Date validTo) {
        this.validTo = validTo;
    }

    public long getAmountToIssue() {
        return amountToIssue;
    }

    public void setAmountToIssue(long amountToIssue) {
        this.amountToIssue = amountToIssue;
    }

    public long getAmountIssued() {
        return amountIssued;
    }

    public void setAmountIssued(long amountIssued) {
        this.amountIssued = amountIssued;
    }

    public boolean isActivated() {
        return activated;
    }

    public void setActivated(boolean activated) {
        this.activated = activated;
    }

    public String getCouponCode() {
        return couponCode;
    }

    public void setCouponCode(String couponCode) {
        this.couponCode = couponCode;
    }

    /*
     * Custom function
     */

    public OfferStatus getStatus() {

        if (amountToIssue > 0 && amountToIssue - amountIssued == 0) {
            return OfferStatus.INVALID;
        }

        if (validTo != null && new Date().after(validTo)) {
            return OfferStatus.INVALID;
        }

        if (activated) {
            return OfferStatus.ACTIVE;
        } else {
            return OfferStatus.INACTIVE;
        }

    }

    @Override
    public boolean equals(Object obj) {

        if (obj instanceof OfferEntity) {

            OfferEntity offerEntity = (OfferEntity) obj;

            if (offerEntity.getOfferId() == offerId) {
                return true;
            }

        }

        return false;
    }

    @Override
    public int hashCode() {
        return new Long(offerId).hashCode();
    }


}
