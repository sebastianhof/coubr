package com.coubr.data.types;

/**
 * Created by sebastian on 07.10.14.
 */
public class LocalBusinessSubcategory {

    public static final String[] restaurants = {
            "asian", "french", "german", "italian"
    };

    public static boolean isValid(String category, String subcategory) {
        if (subcategory == null || category == null) {
            // subcategory can be null -> this is ok
            return true;
        }


        if (category.equals("restaurant")) {

            for (String currentSubcategory: restaurants) {

                if (currentSubcategory.equals(subcategory)) {
                    return true;
                }

            }

        }

        return false;

    }

}

