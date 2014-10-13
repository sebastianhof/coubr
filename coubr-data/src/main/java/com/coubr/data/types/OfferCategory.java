package com.coubr.data.types;

/**
 * Created by sebastian on 08.10.14.
 */
public class OfferCategory {

    public static boolean isValid(String type, String category) {

        if (category == null || type == null) {
            // category can be null -> this is ok
            return true;
        }

        if (type.equals("coupon")) {

            // TODO: define categories

            return true;
        }

        return false;

    }

}
