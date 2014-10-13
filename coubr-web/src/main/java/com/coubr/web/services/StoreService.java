package com.coubr.web.services;

import com.coubr.data.entities.BusinessOwnerEntity;
import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.data.entities.OfferEntity;
import com.coubr.data.repositories.BusinessOwnerRepository;
import com.coubr.data.repositories.LocalBusinessRepository;
import com.coubr.data.repositories.OfferRepository;
import com.coubr.data.types.LocalBusinessCategory;
import com.coubr.data.types.LocalBusinessSubcategory;
import com.coubr.data.types.LocalBusinessType;
import com.coubr.web.exceptions.*;
import com.coubr.web.json.store.*;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by sebastian on 05.10.14.
 */
@Service("storeService")
public class StoreService {

    private static int STORE_CODE_TOKEN_LENGTH = 128;

    @Autowired
    private BusinessOwnerRepository businessOwnerRepository;

    @Autowired
    private LocalBusinessRepository localBusinessRepository;

    @Autowired
    private LocationService locationService;

    @Autowired
    private OfferRepository offerRepository;

    public Stores getStores(String email) throws EmailNotFoundException {
        BusinessOwnerEntity businessOwnerEntity = getBusinessOwnerEntity(email);
        return new Stores(localBusinessRepository.findByBusinessOwner(businessOwnerEntity));
    }

    public StoresDetails getStoresWithDetails(String email) throws EmailNotFoundException {
        BusinessOwnerEntity businessOwnerEntity = getBusinessOwnerEntity(email);
        return new StoresDetails(localBusinessRepository.findByBusinessOwner(businessOwnerEntity));
    }

    public StoreName getStoreName(String email, String storeId) throws StoreNotFoundException, EmailNotFoundException {
        LocalBusinessEntity entity = getLocalBusinessEntity(email, storeId);
        return new StoreName(entity);
    }

    public StoreAddress getStoreAddress(String email, String storeId) throws StoreNotFoundException, EmailNotFoundException {
        LocalBusinessEntity entity = getLocalBusinessEntity(email, storeId);
        return new StoreAddress(entity);
    }

    public StoreContact getStoreContact(String email, String storeId) throws StoreNotFoundException, EmailNotFoundException {
        LocalBusinessEntity entity = getLocalBusinessEntity(email, storeId);
        return new StoreContact(entity);
    }

    public StoreType getStoreType(String email, String storeId) throws StoreNotFoundException, EmailNotFoundException {
        LocalBusinessEntity entity = getLocalBusinessEntity(email, storeId);
        return new StoreType(entity);
    }

    /*
     * Setter
     */

    public Store addStore(String email, AddStore data) throws EmailNotFoundException, PostalCodeNotFoundException, TypeNotFoundException, CategoryNotFoundException, SubcategoryNotFoundException {

        /*
         * Validate
         */

        BusinessOwnerEntity businessOwnerEntity = getBusinessOwnerEntity(email);
        locationService.validatePostalCode(data.getPostalCode());
        if (!LocalBusinessType.isValid(data.getType())) throw new TypeNotFoundException();
        if (!LocalBusinessCategory.isValid(data.getType(), data.getCategory())) throw new CategoryNotFoundException();
        if (!LocalBusinessSubcategory.isValid(data.getCategory(), data.getSubcategory()))
            throw new SubcategoryNotFoundException();

        /*
         * Create
         */

        LocalBusinessEntity entity = new LocalBusinessEntity();
        entity.setBusinessOwner(businessOwnerEntity);
        entity.setName(data.getName());
        entity.setDescription(data.getDescription());

        // Location
        entity.setStreetAddress(data.getStreet());
        entity.setAddressLocality(data.getCity());
        entity.setPostalCode(data.getPostalCode());

        LocationService.Location location = locationService.getLocation(data.getStreet(), data.getPostalCode(), data.getCity());
        entity.setAddressRegion(location.getAddressRegion());
        entity.setAddressCountry(location.getAddressCountry());
        entity.setGeoLatitude(location.getGeoLatitude());
        entity.setGeoLongitude(location.getGeoLongitude());

        // Contact
        entity.setTelephone(data.getPhone());
        entity.setEmail(data.getEmail());

        // Type
        entity.setType(data.getType());
        entity.setCategory(data.getCategory());
        entity.setSubcategory(data.getSubcategory());

        // Code
        entity.setStoreCode(RandomStringUtils.randomAlphanumeric(STORE_CODE_TOKEN_LENGTH));

        localBusinessRepository.save(entity);

        return new Store(entity);

    }

    public StoreDetails getStore(String email, String storeId) throws EmailNotFoundException, StoreNotFoundException {

        LocalBusinessEntity entity = getLocalBusinessEntity(email, storeId);
        return new StoreDetails(entity);
    }

    public StorePictures getStorePictures(String email, String storeId) throws EmailNotFoundException, StoreNotFoundException {

        LocalBusinessEntity entity = getLocalBusinessEntity(email, storeId);
        return new StorePictures(entity);

    }


    public StoreLocation getStoreLocation(String email, String storeId) throws EmailNotFoundException, StoreNotFoundException {

        LocalBusinessEntity entity = getLocalBusinessEntity(email, storeId);
        return new StoreLocation(entity);

    }

    public StoreCode getStoreCode(String email, String storeId) throws EmailNotFoundException, StoreNotFoundException {

        LocalBusinessEntity entity = getLocalBusinessEntity(email, storeId);
        return new StoreCode(entity);

    }

    public StoreSettings getStoreSettings(String email, String storeId) throws EmailNotFoundException, StoreNotFoundException {

        LocalBusinessEntity entity = getLocalBusinessEntity(email, storeId);
        return new StoreSettings(entity);

    }

    public void changeStoreName(String email, String storeId, StoreName data) throws EmailNotFoundException, StoreNotFoundException {

        LocalBusinessEntity entity = getLocalBusinessEntity(email, storeId);
        entity.setName(data.getName());
        entity.setDescription(data.getDescription());
        localBusinessRepository.save(entity);

    }


    public void changeStoreAddress(String email, String storeId, StoreAddress data) throws EmailNotFoundException, StoreNotFoundException, PostalCodeNotFoundException {

        LocalBusinessEntity entity = getLocalBusinessEntity(email, storeId);
        locationService.validatePostalCode(data.getPostalCode());

        entity.setStreetAddress(data.getStreet());
        entity.setPostalCode(data.getPostalCode());
        entity.setAddressLocality(data.getCity());

        LocationService.Location location = locationService.getLocation(data.getStreet(), data.getPostalCode(), data.getCity());
        entity.setAddressRegion(location.getAddressRegion());
        entity.setAddressCountry(location.getAddressCountry());
        entity.setGeoLatitude(location.getGeoLatitude());
        entity.setGeoLongitude(location.getGeoLongitude());
        localBusinessRepository.save(entity);

    }

    public void changeStoreContact(String email, String storeId, StoreContact data) throws EmailNotFoundException, StoreNotFoundException {

        LocalBusinessEntity entity = getLocalBusinessEntity(email, storeId);

        entity.setTelephone(data.getPhone());
        entity.setEmail(data.getEmail());
        localBusinessRepository.save(entity);

    }

    public void changeStoreType(String email, String storeId, StoreType data) throws EmailNotFoundException, StoreNotFoundException, TypeNotFoundException, CategoryNotFoundException, SubcategoryNotFoundException {

        LocalBusinessEntity entity = getLocalBusinessEntity(email, storeId);
        if (!LocalBusinessType.isValid(data.getType())) throw new TypeNotFoundException();
        if (!LocalBusinessCategory.isValid(data.getType(), data.getCategory())) throw new CategoryNotFoundException();
        if (!LocalBusinessSubcategory.isValid(data.getCategory(), data.getSubcategory()))
            throw new SubcategoryNotFoundException();

        // Type
        entity.setType(data.getType());
        entity.setCategory(data.getCategory());
        entity.setSubcategory(data.getSubcategory());
        localBusinessRepository.save(entity);

    }

    public void close(String email, String storeId, StoreClose data) throws EmailNotFoundException, StoreNotFoundException {

        LocalBusinessEntity entity = getLocalBusinessEntity(email, storeId);

        // TODO
        // Log reason
        // Inform customers

        List<OfferEntity> offerEntities = entity.getOffers();
        for (OfferEntity offerEntity : offerEntities) {
            offerEntity.removeLocalBusiness(entity);
            offerRepository.save(offerEntity);
        }

        localBusinessRepository.delete(entity);

    }

    /*
     * Private
     */

    private BusinessOwnerEntity getBusinessOwnerEntity(String email) throws EmailNotFoundException {
        BusinessOwnerEntity businessOwnerEntity = businessOwnerRepository.findByEmail(email);
        if (businessOwnerEntity == null) {
            throw new EmailNotFoundException();
        }
        return businessOwnerEntity;
    }

    private LocalBusinessEntity getLocalBusinessEntity(String email, String storeId) throws StoreNotFoundException, EmailNotFoundException {
        BusinessOwnerEntity businessOwnerEntity = getBusinessOwnerEntity(email);
        LocalBusinessEntity entity = localBusinessRepository.findOne(ObfuscationService.decode(storeId, ObfuscationService.SALT_LOCAL_BUSINESS));
        if (entity == null || entity.getBusinessOwner().getBusinessOwnerId() != businessOwnerEntity.getBusinessOwnerId()) {
            throw new StoreNotFoundException();
        }
        return entity;
    }



}
