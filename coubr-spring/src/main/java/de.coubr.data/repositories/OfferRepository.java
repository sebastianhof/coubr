package com.coubr.data.repositories;

import com.coubr.data.entities.BusinessOwnerEntity;
import com.coubr.data.entities.OfferEntity;
import com.coubr.data.entities.LocalBusinessEntity;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by sebastian on 28.09.14.
 */
@Repository("offerRepository")
public interface OfferRepository extends CrudRepository<OfferEntity, Long> {

    List<OfferEntity> findByBusinessOwner(BusinessOwnerEntity businessOwner);

    List<OfferEntity> findByBusinessOwnerAndType(BusinessOwnerEntity businessOwnerEntity, String type);
}
