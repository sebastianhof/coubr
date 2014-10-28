package com.coubr.data.types;

/**
 * Created by sebastian on 06.10.14.
 */
public class LocalBusinessType {

    public static final String[] types = {
            "automotive",
            "emergency",
            "entertainment",
            "financial",
            "food",
            "government",
            "health",
            "home",
            "lodging",
            "medical",
            "professional",
            "sport",
            "store",
            "other"
    };

    public static boolean isValid(String type)  {
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



