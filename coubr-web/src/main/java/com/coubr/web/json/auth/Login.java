package com.coubr.web.json.auth;

import com.coubr.data.GlobalDataLengthConstants;
import org.hibernate.validator.constraints.Email;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 * Created by sebastian on 02.10.14.
 */
public class Login {

    @Email
    @NotNull
    @Size(max = GlobalDataLengthConstants.EMAIL_LENGTH)
    private String email;

    @Size(min = GlobalDataLengthConstants.PASSWORD_MIN_LENGTH, max = GlobalDataLengthConstants.PASSWORD_MAX_LENGTH)
    @NotNull
    private String password;

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

}
