package com.coubr.data.repositories;

import com.coubr.data.entities.BusinessOwnerEntity;
import com.coubr.data.entities.LocalBusinessEntity;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by sebastian on 28.09.14.
 */
@Repository("storeRepository")
public interface LocalBusinessRepository extends CrudRepository<LocalBusinessEntity, Long>, LocalBusinessQuery {

    List<LocalBusinessEntity> findByBusinessOwner(BusinessOwnerEntity businessOwner);

}
