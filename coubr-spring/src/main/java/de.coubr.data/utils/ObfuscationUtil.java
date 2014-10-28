package com.coubr.data.utils;

import com.google.common.io.BaseEncoding;
import com.google.common.primitives.Longs;

/**
 * Created by sebastian on 09.10.14.
 */
public class ObfuscationUtil {

    private static final String SOURCE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_=";
    public static final String SALT_LOCAL_BUSINESS = "y1CrM7OI3pAc98PVgGDZoYnK2J-4zTB0feqRNikWQvwlE=Ujsm6dhFuaXx5bL_HtS";
    public static final String SALT_COUPON = "pbeYs8gEV-ukvzr3ynwcl9KLWZqfFA1M=oS20m4TROIPh7NHCJidGjDa5XQt6xBU_";
    public static final String SALT_APP_LOCAL_BUSINESS = "7iIjSUo1wep0Ptrzfqm2VynG=9_EZ3Nc6XBFJOTRH4hLdMQ8DWa5vkYKulb-xgCAs";
    public static final String SALT_APP_COUPON = "9Uehnk12Qx0b87umFAtw5-JpSKsVgG3=Bl_OTyr4dZIaMcziCENfWvYoXHqPjR6DL";
    public static final String SALT_3 = "gnk2m13pCIJVhoBHy6Elfj5urUT-Yw0aF_XLGNWDxsQzi79MAedKbtcS=8ZqvPR4O";

    public static String encode(long id, String salt) {

        String encodedId = BaseEncoding.base64Url().encode(Longs.toByteArray(id));

        char[] result = new char[encodedId.length()];
        for (int i = 0; i < encodedId.length(); i++) {
            char c = encodedId.charAt(i);
            int index = SOURCE.indexOf(c);
            result[i] = salt.charAt(index);
        }

        return new String(result);
    }

    public static long decode(String encodedId, String salt) {
        char[] result = new char[encodedId.length()];
        for (int i = 0; i < encodedId.length(); i++) {
            char c = encodedId.charAt(i);
            int index = salt.indexOf(c);
            result[i] = SOURCE.charAt(index);
        }

        long decodedId = Longs.fromByteArray(BaseEncoding.base64Url().decode(new String(result)));

        return decodedId;

    }

}
