package com.coubr.web.json.coupon;

import com.coubr.data.GlobalDataLengthConstants;
import com.coubr.web.validation.DateSerializer;
import com.coubr.web.validation.ValidToDateDeserializer;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.util.Date;
import java.util.List;

/**
 * Created by sebastian on 08.10.14.
 */
public class AddCoupon {

    @NotNull
    @Size(max = GlobalDataLengthConstants.NAME_LENGTH)
    private String title;

    @Size(max = GlobalDataLengthConstants.DESCRIPTION_LENGTH)
    private String description;

    @Size(max = GlobalDataLengthConstants.ID_LENGTH)
    private String category;

    @JsonDeserialize(using = ValidToDateDeserializer.class)
    private Date validTo;

    @NotNull
    private boolean activated;

    @NotNull
    @Min(0) // 0 means unlimited
    private long amountToIssue;

    @NotNull
    private List<String> stores;

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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    @JsonDeserialize(using = ValidToDateDeserializer.class)
    public Date getValidTo() {
        return validTo;
    }

    @JsonSerialize(using = DateSerializer.class)
    public void setValidTo(Date validTo) {
        this.validTo = validTo;
    }

    public long getAmountToIssue() {
        return amountToIssue;
    }

    public void setAmountToIssue(long amountToIssue) {
        this.amountToIssue = amountToIssue;
    }

    public List<String> getStores() {
        return stores;
    }

    public void setStores(List<String> stores) {
        this.stores = stores;
    }

    public boolean isActivated() {
        return activated;
    }

    public void setActivated(boolean activated) {
        this.activated = activated;
    }

}
