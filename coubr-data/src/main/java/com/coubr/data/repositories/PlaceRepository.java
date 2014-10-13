package com.coubr.data.repositories;

import com.coubr.data.entities.PlaceEntity;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by sebastian on 07.10.14.
 */
@Repository("placeRepository")
public interface PlaceRepository extends CrudRepository<PlaceEntity, Long> {

    public List<PlaceEntity> findByPostalCode(String postalCode);



}
