package com.coubr.business.json.account;

import com.coubr.data.GlobalDataLengthConstants;
import com.coubr.business.validation.Match;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 * Created by sebastian on 04.10.14.
 */
@Match(a = "newPassword", b = "newPasswordRepeat")
public class AccountChangePassword {

    @Size(min = GlobalDataLengthConstants.PASSWORD_MIN_LENGTH, max = GlobalDataLengthConstants.PASSWORD_MAX_LENGTH)
    @NotNull
    private String password;

    @Size(min = GlobalDataLengthConstants.PASSWORD_MIN_LENGTH, max = GlobalDataLengthConstants.PASSWORD_MAX_LENGTH)
    @NotNull
    private String newPassword;

    @Size(min = GlobalDataLengthConstants.PASSWORD_MIN_LENGTH, max = GlobalDataLengthConstants.PASSWORD_MAX_LENGTH)
    @NotNull
    private String newPasswordRepeat;

    public AccountChangePassword() {
        // empty constructor
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }

    public String getNewPasswordRepeat() {
        return newPasswordRepeat;
    }

    public void setNewPasswordRepeat(String newPasswordRepeat) {
        this.newPasswordRepeat = newPasswordRepeat;
    }

}
