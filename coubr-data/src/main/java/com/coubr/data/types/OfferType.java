package com.coubr.data.types;

/**
 * Created by sebastian on 08.10.14.
 */
public class OfferType {

    public static final String[] types = {
            "coupon"
    };

    public static boolean isValid(String type) {
        if (type == null) {
            // type mandatory
            return false;
        }

        for (String currentType : types) {

            if (currentType.equals(type)) {
                return true;
            }

        }

        return false;

    }

}
