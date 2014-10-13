package com.coubr.data.entities;

import javax.persistence.*;

/**
 * Created by sebastian on 07.10.14.
 */
@Entity
public class PlaceEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long placeId;
    @Column(nullable = false)
    private String postalCode;
    @Column(nullable = false)
    private String place;
    @Column(nullable = false)
    private String region;
    @Column(nullable = false)
    private String country;
    @Column(nullable = false)
    private double longitude;
    @Column(nullable = false)
    private double latitude;

    public long getPlaceId() {
        return placeId;
    }

    public void setPlaceId(long placeId) {
        this.placeId = placeId;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public String getPlace() {
        return place;
    }

    public void setPlace(String place) {
        this.place = place;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

}
