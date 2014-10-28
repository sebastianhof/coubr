package com.coubr.test;

import com.coubr.data.utils.ObfuscationUtil;
import org.junit.Assert;
import org.junit.Test;

/**
 * Created by sebastian on 09.10.14.
 */
public class ObfuscationTest {

    @Test
    public void obfuscateTest() {

        long testId = 1;
        String encodedId = ObfuscationUtil.encode(testId, ObfuscationUtil.SALT_3);
        System.out.println("Obfuscated String: " + encodedId);
        Assert.assertEquals(testId, ObfuscationUtil.decode(encodedId, ObfuscationUtil.SALT_3));

        testId = 0;
        encodedId = ObfuscationUtil.encode(testId, ObfuscationUtil.SALT_3);
        System.out.println("Obfuscated String: " + encodedId);
        Assert.assertEquals(testId, ObfuscationUtil.decode(encodedId, ObfuscationUtil.SALT_3));

        testId = 1000;
        encodedId = ObfuscationUtil.encode(testId, ObfuscationUtil.SALT_3);
        System.out.println("Obfuscated String: " + encodedId);
        Assert.assertEquals(testId, ObfuscationUtil.decode(encodedId, ObfuscationUtil.SALT_3));

        testId = 1000000000;
        encodedId = ObfuscationUtil.encode(testId, ObfuscationUtil.SALT_3);
        System.out.println("Obfuscated String: " + encodedId);
        Assert.assertEquals(testId, ObfuscationUtil.decode(encodedId, ObfuscationUtil.SALT_3));

        testId = 325346344;
        encodedId = ObfuscationUtil.encode(testId, ObfuscationUtil.SALT_3);
        System.out.println("Obfuscated String: " + encodedId);
        Assert.assertEquals(testId, ObfuscationUtil.decode(encodedId, ObfuscationUtil.SALT_3));

    }

}
