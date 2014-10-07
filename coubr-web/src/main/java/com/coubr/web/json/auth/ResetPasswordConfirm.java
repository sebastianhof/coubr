package com.coubr.web.json.auth;

import com.coubr.web.validation.Match;
import org.hibernate.validator.constraints.Email;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 * Created by sebastian on 02.10.14.
 */

public class ResetPasswordConfirm {

    @Email
    @NotNull
    private String email;

    @Size(min = 16, max = 32)
    @NotNull
    private String code;

    @Size(min = 8, max = 50)
    @NotNull
    private String password;

    @Size(min = 8, max = 50)
    @NotNull
    private String passwordRepeat;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPasswordRepeat() {
        return passwordRepeat;
    }

    public void setPasswordRepeat(String passwordRepeat) {
        this.passwordRepeat = passwordRepeat;
    }

}
