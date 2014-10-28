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

        gc.setDirection(-180, distance);
        Point2D dest_180 = gc.getDestinationGeographicPoint();

        gc.setDirection(-90, distance);
        Point2D dest_90 = gc.getDestinationGeographicPoint();

        gc.setDirection(0, distance);
        Point2D dest0 = gc.getDestinationGeographicPoint();

        gc.setDirection(90, distance);
        Point2D dest90 = gc.getDestinationGeographicPoint();

        gc.setDirection(180, distance);
        Point2D dest180 = gc.getDestinationGeographicPoint();

        double lat[] = {dest_180.getY(), dest_90.getY(), dest0.getY(), dest90.getY(), dest180.getY()};
        double lon[] = {dest_180.getX(), dest_90.getX(), dest0.getX(), dest90.getX(), dest180.getX()};

        double minLat = NumberUtils.min(lat);
        double maxLat = NumberUtils.max(lat);

        double minLon = NumberUtils.min(lon);
        double maxLon = NumberUtils.max(lon);

        TypedQuery<LocalBusinessEntity> query = em.createQuery("SELECT l FROM LocalBusinessEntity l WHERE " +
                "l.geoLatitude > :minLat AND l.geoLatitude < :maxLat " +
                "AND l.geoLongitude > :minLon AND l.geoLongitude < :maxLon", LocalBusinessEntity.class);
        query.setParameter("minLat", minLat).setParameter("maxLat", maxLat).
                setParameter("minLon", minLon).setParameter("maxLon", maxLon);

        List<LocalBusinessEntity> results = query.getResultList();

        return results;
    }
}
