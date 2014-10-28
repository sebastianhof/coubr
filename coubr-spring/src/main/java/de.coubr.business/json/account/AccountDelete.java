package com.coubr.business.json.account;

import org.hibernate.validator.constraints.Email;

import javax.validation.constraints.NotNull;

/**
 * Created by sebastian on 15.10.14.
 */
public class AccountDelete {

    @NotNull
    @Email
    private String email;

    @NotNull
    private String reason;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }
}
