package com.coubr.web.json.store;

import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.web.services.ObfuscationService;
import com.google.common.io.BaseEncoding;
import com.google.common.primitives.Longs;

/**
 * Created by sebastian on 09.10.14.
 */
public class StoreLocation {

    private String storeId;
    private double latitude;
    private double longitude;

    public StoreLocation(LocalBusinessEntity entity) {
        this.storeId = ObfuscationService.encode(entity.getLocalBusinessId(), ObfuscationService.SALT_LOCAL_BUSINESS);
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
