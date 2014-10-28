package com.coubr.business.services;

import com.coubr.business.exceptions.PostalCodeNotFoundException;
import com.coubr.data.entities.PlaceEntity;
import com.coubr.data.repositories.PlaceRepository;
import com.google.code.geocoder.Geocoder;
import com.google.code.geocoder.GeocoderRequestBuilder;
import com.google.code.geocoder.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;

/**
 * Created by sebastian on 07.10.14.
 */
@Service("locationService")
public class LocationService {

    public static String LANGUAGE = "de";

    @Autowired
    private PlaceRepository placeRepository;

    @Bean
    LocationService locationService() {
        return new LocationService();
    }

    public void validatePostalCode(String postalCode) throws PostalCodeNotFoundException {

        List<PlaceEntity> placeEntities = placeRepository.findByPostalCode(postalCode);
        if (placeEntities == null || placeEntities.size() == 0) {
            throw new PostalCodeNotFoundException();
        }

    }

    public Location getLocation(String streetAddress, String postalCode, String city) {
        Location location = new Location();

        List<PlaceEntity> placeEntities = placeRepository.findByPostalCode(postalCode);
        PlaceEntity place = placeEntities.get(0);
        location.setAddressRegion(place.getRegion());
        location.setAddressCountry(place.getCountry());
        location.setGeoLatitude(place.getLatitude());
        location.setGeoLongitude(place.getLongitude());

        /*
         * Get exact latitude and longitude from Google GeoCoder
         */
        final Geocoder geocoder = new Geocoder();
        GeocoderRequest geocoderRequest = new GeocoderRequestBuilder().setAddress(streetAddress + ", " + postalCode + " " + city).setLanguage(LANGUAGE).getGeocoderRequest();
        try {
            GeocodeResponse geocoderResponse = geocoder.geocode(geocoderRequest);


            if (geocoderResponse.getStatus() == GeocoderStatus.OK) {

                List<GeocoderResult> results = geocoderResponse.getResults();

                for (GeocoderResult result : results) {

                    GeocoderGeometry geo = result.getGeometry();
                    LatLng latLng = geo.getLocation();

                    location.setGeoLatitude(latLng.getLat().doubleValue());
                    location.setGeoLongitude(latLng.getLng().doubleValue());
                    break;

                }

            }
        } catch (IOException ex) {
            ex.printStackTrace();
        }

        return location;

    }

    class Location {

        private String addressRegion;
        private String addressCountry;
        private double geoLatitude;
        private double geoLongitude;

        public String getAddressRegion() {
            return addressRegion;
        }

        public void setAddressRegion(String addressRegion) {
            this.addressRegion = addressRegion;
        }

        public String getAddressCountry() {
            return addressCountry;
        }

        public void setAddressCountry(String addressCountry) {
            this.addressCountry = addressCountry;
        }

        public double getGeoLatitude() {
            return geoLatitude;
        }

        public void setGeoLatitude(double geoLatitude) {
            this.geoLatitude = geoLatitude;
        }

        public double getGeoLongitude() {
            return geoLongitude;
        }

        public void setGeoLongitude(double geoLongitude) {
            this.geoLongitude = geoLongitude;
        }

    }


}
