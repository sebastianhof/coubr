package com.coubr.data.repositories;

import com.coubr.data.entities.LocalBusinessEntity;
import org.apache.commons.lang3.math.NumberUtils;
import org.geotools.referencing.GeodeticCalculator;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.awt.geom.Point2D;
import java.util.List;

/**
 * Created by sebastian on 28.09.14.
 */
@Repository
public class LocalBusinessRepositoryImpl implements LocalBusinessQuery {

    @PersistenceContext
    private EntityManager em;

    @Override
    public List<LocalBusinessEntity> findAroundLocation(double latitude, double longitude, double distance) {

        GeodeticCalculator gc = new GeodeticCalculator();
        gc.setStartingGeographicPoint(longitude, latitude);
        gc.setDirection(0, distance);

        Point2D dest0 = gc.getDestinationGeographicPoint();

        gc.setDirection(90, distance);
        Point2D dest90 = gc.getDestinationGeographicPoint();

        gc.setDirection(180, distance);
        Point2D dest180 = gc.getDestinationGeographicPoint();

        gc.setDirection(270, distance);
        Point2D dest270 = gc.getDestinationGeographicPoint();

        double lat[] = {dest0.getY(), dest90.getY(), dest180.getY(), dest270.getY()};
        double lon[] = {dest0.getX(), dest90.getX(), dest180.getX(), dest270.getX()};

        double minLat = NumberUtils.min(lat);
        double maxLat = NumberUtils.max(lat);

        double minLon = NumberUtils.min(lon);
        double maxLon = NumberUtils.max(lon);

        TypedQuery<LocalBusinessEntity> query = em.createQuery("SELECT l FROM LocalBusinessEntity l WHERE " +
                "l.latitude > :minLat AND l.latitude < :maxLat " +
                "AND l.longitude > :minLon AND l.longitude < :maxLon", LocalBusinessEntity.class);
        query.setParameter("minLat", minLat).setParameter("maxLat", maxLat).
                setParameter("minLon", minLon).setParameter("maxLon", maxLon);

        List<LocalBusinessEntity> results = query.getResultList();

        return results;
    }
}
