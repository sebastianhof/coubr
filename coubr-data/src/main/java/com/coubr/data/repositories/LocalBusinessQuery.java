package com.coubr.data.repositories;

import com.coubr.data.entities.LocalBusinessEntity;

import java.util.List;

/**
 * Created by sebastian on 28.09.14.
 */
public interface LocalBusinessQuery {

    List<LocalBusinessEntity> findAroundLocation(double latitude, double longitude, double distance);

}
