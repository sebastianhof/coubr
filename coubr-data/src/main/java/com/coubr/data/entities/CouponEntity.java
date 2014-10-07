package com.coubr.data.entities;

import javax.persistence.*;

/**
 * Created by sebastian on 28.09.14.
 */
@Entity
@Table(name = "CouponEntity")
public class CouponEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long couponId;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "storeId")
    private LocalBusinessEntity store;

    /*
     Getter and Setter
      */

    public long getCouponId() {
        return couponId;
    }

    public void setCouponId(long couponId) {
        this.couponId = couponId;
    }


    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalBusinessEntity getStore() {
        return store;
    }

    public void setStore(LocalBusinessEntity store) {
        this.store = store;
    }
}
