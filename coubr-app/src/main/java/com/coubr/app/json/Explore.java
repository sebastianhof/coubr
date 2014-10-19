package com.coubr.app.json;

import com.coubr.data.entities.LocalBusinessEntity;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by sebastian on 15.10.14.
 */
public class Explore {

    // stores
    List<ExploreStore> s;

    public Explore(List<LocalBusinessEntity> entities) {

        s = new LinkedList<ExploreStore>();
        for (LocalBusinessEntity entity: entities) {
            s.add(new ExploreStore(entity));
        }

    }

    public List<ExploreStore> getS() {
        return s;
    }

    public void setS(List<ExploreStore> s) {
        this.s = s;
    }
}
