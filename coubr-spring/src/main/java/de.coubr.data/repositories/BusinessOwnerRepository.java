package com.coubr.data.repositories;

import com.coubr.data.entities.BusinessOwnerEntity;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

/**
 * Created by sebastian on 27.09.14.
 */
@Repository("businessOwnerRepository")
public interface BusinessOwnerRepository extends CrudRepository<BusinessOwnerEntity, Long> {

    BusinessOwnerEntity findByEmailAndPassword(String email, String password);

    BusinessOwnerEntity findByEmail(String email);

}
