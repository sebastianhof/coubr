package com.coubr.business.services;

import com.coubr.business.exceptions.*;
import com.coubr.business.json.coupon.*;
import com.coubr.data.entities.BusinessOwnerEntity;
import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.data.entities.OfferEntity;
import com.coubr.data.repositories.BusinessOwnerRepository;
import com.coubr.data.repositories.LocalBusinessRepository;
import com.coubr.data.repositories.OfferRepository;
import com.coubr.data.types.OfferCategory;
import com.coubr.data.types.OfferStatus;
import com.coubr.data.utils.ObfuscationUtil;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by sebastian on 05.10.14.
 */
@Service(value = "couponService")
public class CouponService {

    private static final String TYPE = "coupon";
    private static int COUPON_CODE_TOKEN_LENGTH = 128;
    @Autowired
    private BusinessOwnerRepository businessOwnerRepository;

    @Autowired
    private LocalBusinessRepository localBusinessRepository;

    @Autowired
    private OfferRepository offerRepository;

    @Autowired
    private CodeService codeService;

    public Coupons getCoupons(String email) throws EmailNotFoundException {

        BusinessOwnerEntity businessOwnerEntity = getBusinessOwnerEntity(email);
        return new Coupons(offerRepository.findByBusinessOwnerAndType(businessOwnerEntity, TYPE));

    }

    public CouponsDetails getActiveCoupons(String email) throws EmailNotFoundException {
        BusinessOwnerEntity businessOwnerEntity = getBusinessOwnerEntity(email);

        List<OfferEntity> entities = offerRepository.findByBusinessOwnerAndType(businessOwnerEntity, TYPE);
        List<OfferEntity> activeEntities = new LinkedList<OfferEntity>();

        for (OfferEntity entity : entities) {

            if (entity.getStatus() == OfferStatus.ACTIVE) {
                activeEntities.add(entity);
            }

        }

        return new CouponsDetails(activeEntities);
    }

    public CouponsDetails getInactiveCoupons(String email) throws EmailNotFoundException {
        BusinessOwnerEntity businessOwnerEntity = getBusinessOwnerEntity(email);

        List<OfferEntity> entities = offerRepository.findByBusinessOwnerAndType(businessOwnerEntity, TYPE);
        List<OfferEntity> inactiveEntities = new LinkedList<OfferEntity>();

        for (OfferEntity entity : entities) {

            if (entity.getStatus() == OfferStatus.INACTIVE) {
                inactiveEntities.add(entity);
            }

        }

        return new CouponsDetails(inactiveEntities);
    }

    public CouponsDetails getInvalidCoupons(String email) throws EmailNotFoundException {
        BusinessOwnerEntity businessOwnerEntity = getBusinessOwnerEntity(email);

        List<OfferEntity> entities = offerRepository.findByBusinessOwnerAndType(businessOwnerEntity, TYPE);
        List<OfferEntity> invalidEntities = new LinkedList<OfferEntity>();


        for (OfferEntity entity : entities) {

            if (entity.getStatus() == OfferStatus.INVALID) {
                invalidEntities.add(entity);
            }

        }

        return new CouponsDetails(invalidEntities);
    }

    public CouponTitle getCouponTitle(String email, String couponId) throws EmailNotFoundException, CouponNotFoundException {
        OfferEntity entity = getOfferEntity(email, couponId);
        return new CouponTitle(entity);
    }

    public CouponValidTo getCouponValidTo(String email, String couponId) throws EmailNotFoundException, CouponNotFoundException {
        OfferEntity entity = getOfferEntity(email, couponId);
        return new CouponValidTo(entity);
    }

    public CouponAmount getCouponAmount(String email, String couponId) throws EmailNotFoundException, CouponNotFoundException {
        OfferEntity entity = getOfferEntity(email, couponId);
        return new CouponAmount(entity);
    }

    public CouponCategory getCouponCategory(String email, String couponId) throws EmailNotFoundException, CouponNotFoundException {
        OfferEntity entity = getOfferEntity(email, couponId);
        return new CouponCategory(entity);
    }

    public byte[] getCouponQRCode(String email, String couponId, int dimension) throws CouponNotFoundException, EmailNotFoundException, QRCodeGenerationException {
        OfferEntity entity = getOfferEntity(email, couponId);
        return codeService.generateQRCode(entity.getCouponCode(), CodeService.CodeType.COUPON, dimension);
    }

    /*
     * Setter
     */

    public Coupon addCoupon(String email, AddCoupon data) throws EmailNotFoundException, CategoryNotFoundException, StoreNotFoundException {

        /*
         * Validate
         */

        BusinessOwnerEntity businessOwnerEntity = getBusinessOwnerEntity(email);
        if (!OfferCategory.isValid(TYPE, data.getCategory())) throw new CategoryNotFoundException();

        /*
         * Create
         */

        OfferEntity entity = new OfferEntity();

        // Local businesses
        List<LocalBusinessEntity> localBusinessEntities = getLocalBusinessEntities(email, data.getStores());
        entity.setLocalBusinesses(getLocalBusinessEntities(email, data.getStores()));
        // do
        // General
        entity.setBusinessOwner(businessOwnerEntity);
        entity.setTitle(data.getTitle());
        entity.setDescription(data.getDescription());

        // Date
        entity.setValidTo(data.getValidTo());

        // Amount
        entity.setAmountToIssue(data.getAmountToIssue());

        // Type
        entity.setType(TYPE);
        entity.setCategory(data.getCategory());

        // Activate immediately
        entity.setActivated(data.isActivated());

        // Code
        entity.setCouponCode(RandomStringUtils.randomAlphanumeric(COUPON_CODE_TOKEN_LENGTH));

        offerRepository.save(entity);

        // set on local business entity
        for (LocalBusinessEntity localBusinessEntity : localBusinessEntities) {
            localBusinessEntity.addOffer(entity);
            localBusinessRepository.save(localBusinessEntity);
        }

        return new Coupon(entity);

    }

    public CouponDetails getCoupon(String email, String couponId) throws EmailNotFoundException, CouponNotFoundException {

        OfferEntity entity = getOfferEntity(email, couponId);
        return new CouponDetails(entity);

    }


    public CouponStores getCouponStores(String email, String couponId) throws EmailNotFoundException, CouponNotFoundException {

        OfferEntity entity = getOfferEntity(email, couponId);
        return new CouponStores(entity);

    }

    public void changeCouponStores(String email, String couponId, CouponChangeStores data) throws EmailNotFoundException, CouponNotFoundException, StoreNotFoundException {

        OfferEntity entity = getOfferEntity(email, couponId);
        List<LocalBusinessEntity> localBusinessEntities = getLocalBusinessEntities(email, data.getStores());
        entity.setLocalBusinesses(localBusinessEntities);
        offerRepository.save(entity);


        // set on LocalBusinessEntity
        for (LocalBusinessEntity localBusinessEntity : localBusinessEntities) {
            localBusinessEntity.addOffer(entity);
            localBusinessRepository.save(localBusinessEntity);
        }

    }

    public CouponSettings getCouponSettings(String email, String couponId) throws EmailNotFoundException, CouponNotFoundException {

        OfferEntity entity = getOfferEntity(email, couponId);
        return new CouponSettings(entity);

    }

    public void changeCouponTitle(String email, String couponId, CouponTitle data) throws EmailNotFoundException, CouponNotFoundException {

        OfferEntity entity = getOfferEntity(email, couponId);
        entity.setTitle(data.getTitle());
        entity.setDescription(data.getDescription());
        offerRepository.save(entity);

    }

    public void changeCouponValidTo(String email, String couponId, CouponValidTo data) throws EmailNotFoundException, CouponNotFoundException {

        OfferEntity entity = getOfferEntity(email, couponId);
        entity.setValidTo(data.getValidTo());
        offerRepository.save(entity);

    }

    public void changeCouponAmount(String email, String couponId, CouponAmount data) throws EmailNotFoundException, CouponNotFoundException, InvalidAmountException {

        OfferEntity entity = getOfferEntity(email, couponId);
        if (data.getAmountToIssue() > 0 && entity.getAmountIssued() < data.getAmountToIssue()) {
            entity.setAmountToIssue(data.getAmountToIssue());
        } else {
            throw new InvalidAmountException();
        }

        entity.setAmountToIssue(data.getAmountToIssue());
        offerRepository.save(entity);

    }

    public void changeCouponCategory(String email, String couponId, CouponCategory data) throws EmailNotFoundException, CouponNotFoundException, CategoryNotFoundException {
        if (!OfferCategory.isValid(TYPE, data.getCategory())) throw new CategoryNotFoundException();

        OfferEntity entity = getOfferEntity(email, couponId);
        entity.setCategory(data.getCategory());
        offerRepository.save(entity);

    }

    public void activateCoupon(String email, String couponId) throws EmailNotFoundException, CouponNotFoundException {

        OfferEntity entity = getOfferEntity(email, couponId);
        entity.setActivated(true);
        offerRepository.save(entity);

    }

    public void deactivateCoupon(String email, String couponId) throws EmailNotFoundException, CouponNotFoundException {

        OfferEntity entity = getOfferEntity(email, couponId);
        entity.setActivated(false);
        offerRepository.save(entity);

    }

    public void deleteCoupon(String email, String couponId) throws EmailNotFoundException, CouponNotFoundException {
        OfferEntity entity = getOfferEntity(email, couponId);

        for (LocalBusinessEntity localBusinessEntity : entity.getLocalBusinesses()) {
            localBusinessEntity.removeOffer(entity);
            localBusinessRepository.save(localBusinessEntity);

        }

        offerRepository.delete(entity);
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

    private OfferEntity getOfferEntity(String email, String couponId) throws EmailNotFoundException, CouponNotFoundException {
        BusinessOwnerEntity businessOwnerEntity = getBusinessOwnerEntity(email);

        OfferEntity entity = offerRepository.findOne(ObfuscationUtil.decode(couponId, ObfuscationUtil.SALT_COUPON));
        if (entity == null || entity.getBusinessOwner().getBusinessOwnerId() != businessOwnerEntity.getBusinessOwnerId() || !entity.getType().equals("coupon")) {
            throw new CouponNotFoundException();
        }
        return entity;
    }

    private List<LocalBusinessEntity> getLocalBusinessEntities(String email, List<String> stores) throws StoreNotFoundException, EmailNotFoundException {
        List<LocalBusinessEntity> localBusinessEntities = new LinkedList<LocalBusinessEntity>();
        for (String storeId : stores) {
            BusinessOwnerEntity businessOwnerEntity = getBusinessOwnerEntity(email);

            LocalBusinessEntity localBusinessEntity = localBusinessRepository.findOne(ObfuscationUtil.decode(storeId, ObfuscationUtil.SALT_LOCAL_BUSINESS));
            if (localBusinessEntity == null || localBusinessEntity.getBusinessOwner().getBusinessOwnerId() != businessOwnerEntity.getBusinessOwnerId()) {
                throw new StoreNotFoundException();
            }
            localBusinessEntities.add(localBusinessEntity);
        }
        return localBusinessEntities;
    }


}
