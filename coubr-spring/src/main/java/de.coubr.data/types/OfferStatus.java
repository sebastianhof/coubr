package com.coubr.data.types;

/**
 * Created by sebastian on 10.10.14.
 */
public enum OfferStatus {

    ACTIVE("active"), INACTIVE("inactive"), INVALID("invalid");

    private String status;

    private OfferStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return status;
    }

}
