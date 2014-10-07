package com.coubr.web.json.account;

import com.coubr.web.validation.Match;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 * Created by sebastian on 04.10.14.
 */
@Match(a = "newPassword", b = "newPasswordRepeat")
public class ChangePassword {

    @Size(min = 8, max = 50)
    @NotNull
    private String password;

    @Size(min = 8, max = 50)
    @NotNull
    private String newPassword;

    @Size(min = 8, max = 50)
    @NotNull
    private String newPasswordRepeat;

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
