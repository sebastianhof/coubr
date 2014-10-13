package com.coubr.test;

import com.google.code.geocoder.Geocoder;
import com.google.code.geocoder.GeocoderRequestBuilder;
import com.google.code.geocoder.model.GeocodeResponse;
import com.google.code.geocoder.model.GeocoderRequest;
import com.google.code.geocoder.model.GeocoderResult;
import org.junit.Assert;
import org.junit.Test;

import java.io.IOException;
import java.util.List;

/**
 * Created by sebastian on 07.10.14.
 */
public class GeoCoderTest {

    @Test
    public void geoCoderTest() throws IOException {


        final Geocoder geocoder = new Geocoder();
        GeocoderRequest geocoderRequest = new GeocoderRequestBuilder().setAddress("Hauptstraße 10, 91054 Erlangen").setLanguage("en").getGeocoderRequest();
        GeocodeResponse geocoderResponse = geocoder.geocode(geocoderRequest);
        Assert.assertNotNull(geocoderResponse);
        List<GeocoderResult> resultList = geocoderResponse.getResults();

        for (GeocoderResult result: resultList) {

            System.out.println(result.getFormattedAddress());

        }

    }
}
