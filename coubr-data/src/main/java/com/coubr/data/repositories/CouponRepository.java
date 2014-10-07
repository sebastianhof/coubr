package com.coubr.data.repositories;

import com.coubr.data.entities.CouponEntity;
import com.coubr.data.entities.LocalBusinessEntity;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by sebastian on 28.09.14.
 */
@Repository("couponRepository")
public interface CouponRepository extends CrudRepository<CouponEntity, Long> {

    List<CouponEntity> findByStore(LocalBusinessEntity localBusiness);

}
