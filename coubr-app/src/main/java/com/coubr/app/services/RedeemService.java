package com.coubr.app.services;

import com.coubr.app.exceptions.AppCouponNotFoundException;
import com.coubr.app.exceptions.AppStoreCodeNotFoundException;
import com.coubr.app.exceptions.AppStoreNotFoundException;
import com.coubr.app.json.RedeemCoupon;
import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.data.entities.OfferEntity;
import com.coubr.data.repositories.LocalBusinessRepository;
import com.coubr.data.repositories.OfferRepository;
import com.coubr.data.utils.ObfuscationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by sebastian on 23/10/14.
 */
@Service("redeemService")
public class RedeemService {

    @Autowired
    OfferRepository offerRepository;

    @Autowired
    LocalBusinessRepository localBusinessRepository;


    public void redeemCoupon(String couponId, RedeemCoupon redeemCoupon) throws AppStoreNotFoundException, AppCouponNotFoundException, AppStoreCodeNotFoundException {
        LocalBusinessEntity entity = localBusinessRepository.findOne(ObfuscationUtil.decode(redeemCoupon.getSi(), ObfuscationUtil.SALT_APP_LOCAL_BUSINESS));
        if (entity == null) {
            throw new AppStoreNotFoundException();
        }

        OfferEntity offerEntity = null;
        for (OfferEntity offer: entity.getOffers()) {

            if (offer.getOfferId() == ObfuscationUtil.decode(couponId, ObfuscationUtil.SALT_APP_COUPON)) {
                offerEntity = offer;
            }

        }

        if (offerEntity == null) {
            throw new AppCouponNotFoundException();
        }

        if (!entity.getStoreCode().equals(redeemCoupon.getSc())) {
            throw new AppStoreCodeNotFoundException();
        }

        // TODO log time and vendor


        offerEntity.setAmountIssued(offerEntity.getAmountIssued() + 1);
        offerRepository.save(offerEntity);
    }
}
