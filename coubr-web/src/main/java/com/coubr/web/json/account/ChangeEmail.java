package com.coubr.web.json.account;

import com.coubr.web.validation.Match;
import org.hibernate.validator.constraints.Email;

import javax.validation.constraints.NotNull;

/**
 * Created by sebastian on 04.10.14.
 */
@Match(a = "newEmail", b = "newEmailRepeat")
public class ChangeEmail {

    @Email
    @NotNull
    private String newEmail;

    @Email
    @NotNull
    private String newEmailRepeat;

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
