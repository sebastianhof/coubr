package com.coubr.web.json.auth;

import com.coubr.data.GlobalDataLengthConstants;
import com.coubr.web.validation.Match;
import org.hibernate.validator.constraints.Email;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 * Created by sebastian on 02.10.14.
 */
@Match(a = "password", b = "passwordRepeat")
public class Register {

    @Email
    @NotNull
    @Size(max = GlobalDataLengthConstants.EMAIL_LENGTH)
    private String email;

    @Size(min = GlobalDataLengthConstants.PASSWORD_MIN_LENGTH, max = GlobalDataLengthConstants.PASSWORD_MAX_LENGTH)
    @NotNull
    private String password;

    @Size(min = GlobalDataLengthConstants.PASSWORD_MIN_LENGTH, max = GlobalDataLengthConstants.PASSWORD_MAX_LENGTH)
    @NotNull
    private String passwordRepeat;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
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
