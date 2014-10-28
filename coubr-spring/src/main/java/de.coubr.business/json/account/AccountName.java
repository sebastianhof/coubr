package com.coubr.business.json.account;

import com.coubr.data.GlobalDataLengthConstants;

import javax.validation.constraints.Size;

/**
 * Created by sebastian on 04.10.14.
 */
public class AccountName {

    @Size(max = GlobalDataLengthConstants.NAME_LENGTH)
    private String firstName;

    @Size(max = GlobalDataLengthConstants.NAME_LENGTH)
    private String lastName;

    public AccountName() {
        // empty constructor
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

}
