package com.coubr.business.json.account;

import com.coubr.data.GlobalDataLengthConstants;
import com.coubr.business.validation.Match;
import org.hibernate.validator.constraints.Email;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 * Created by sebastian on 04.10.14.
 */
@Match(a = "newEmail", b = "newEmailRepeat")
public class AccountChangeEmail {

    @Email
    @NotNull
    @Size(max = GlobalDataLengthConstants.EMAIL_LENGTH)
    private String newEmail;

    @Email
    @NotNull
    @Size(max = GlobalDataLengthConstants.EMAIL_LENGTH)
    private String newEmailRepeat;

    public AccountChangeEmail() {
        // empty constructor
    }

    public String getNewEmail() {
        return newEmail;
    }

    public void setNewEmail(String newEmail) {
        this.newEmail = newEmail;
    }

    public String getNewEmailRepeat() {
        return newEmailRepeat;
    }

    public void setNewEmailRepeat(String newEmailRepeat) {
        this.newEmailRepeat = newEmailRepeat;
    }

}
