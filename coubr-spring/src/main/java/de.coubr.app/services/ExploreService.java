package com.coubr.app.services;

import com.coubr.app.exceptions.AppStoreNotFoundException;
import com.coubr.app.json.Explore;
import com.coubr.app.json.ExploreRequest;
import com.coubr.app.json.Store;
import com.coubr.data.entities.BusinessOwnerEntity;
import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.data.entities.OfferEntity;
import com.coubr.data.repositories.LocalBusinessRepository;
import com.coubr.data.repositories.OfferRepository;
import com.coubr.data.types.OfferCategory;
import com.coubr.data.utils.ObfuscationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by sebastian on 15.10.14.
 */
@Service("exploreService")
public class ExploreService {

    @Autowired
    private LocalBusinessRepository localBusinessRepository;

    @Autowired
    private OfferRepository offerRepository;

    public Explore handleRequest(ExploreRequest request) {
        List<LocalBusinessEntity> entities = localBusinessRepository.findAroundLocation(request.getLt(), request.getLg(), request.getD());
        return new Explore(entities);
    }

    public Store getStore(String storeId) throws AppStoreNotFoundException {
        LocalBusinessEntity entity = localBusinessRepository.findOne(ObfuscationUtil.decode(storeId, ObfuscationUtil.SALT_APP_LOCAL_BUSINESS));
        if (entity == null) {
            throw new AppStoreNotFoundException();
        }
        return new Store(entity);
    }

//    public Coupon getCoupon(String couponId) throws AppCouponNotFoundException {
//        OfferEntity entity = offerRepository.findOne(ObfuscationUtil.decode(couponId, ObfuscationUtil.SALT_APP_COUPON));
//        if (entity == null) {
//            throw new AppCouponNotFoundException();
//        }
//        return new Coupon(entity);
//    }
}
