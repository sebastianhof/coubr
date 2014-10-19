package com.coubr.business.json.store;

import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.data.utils.ObfuscationUtil;

import javax.validation.constraints.NotNull;

/**
 * Created by sebastian on 09.10.14.
 */
public class StoreLocation {

    private String storeId;

    @NotNull
    private double latitude;

    @NotNull
    private double longitude;

    public StoreLocation() {
        // empty constructor
    }

    public StoreLocation(LocalBusinessEntity entity) {
        this.storeId = ObfuscationUtil.encode(entity.getLocalBusinessId(), ObfuscationUtil.SALT_LOCAL_BUSINESS);
        this.latitude = entity.getGeoLatitude();
        this.longitude = entity.getGeoLongitude();
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }
}
