package com.coubr.test;

import com.coubr.web.services.ObfuscationService;
import org.junit.Assert;
import org.junit.Test;

/**
 * Created by sebastian on 09.10.14.
 */
public class ObfuscationTest {

    @Test
    public void obfuscateTest() {

        long testId = 1;
        String encodedId = ObfuscationService.encode(testId);
        System.out.println("Obfuscated String: " + encodedId);
        Assert.assertEquals(testId, ObfuscationService.decode(encodedId));

        testId = 0;
        encodedId = ObfuscationService.encode(testId);
        System.out.println("Obfuscated String: " + encodedId);
        Assert.assertEquals(testId, ObfuscationService.decode(encodedId));

        testId = 1000;
        encodedId = ObfuscationService.encode(testId);
        System.out.println("Obfuscated String: " + encodedId);
        Assert.assertEquals(testId, ObfuscationService.decode(encodedId));

        testId = 1000000000;
        encodedId = ObfuscationService.encode(testId);
        System.out.println("Obfuscated String: " + encodedId);
        Assert.assertEquals(testId, ObfuscationService.decode(encodedId));

        testId = 325346344;
        encodedId = ObfuscationService.encode(testId);
        System.out.println("Obfuscated String: " + encodedId);
        Assert.assertEquals(testId, ObfuscationService.decode(encodedId));

    }

}
