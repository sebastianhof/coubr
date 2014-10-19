package com.coubr.business.json.auth;

import com.coubr.data.GlobalDataLengthConstants;
import org.hibernate.validator.constraints.Email;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 * Created by sebastian on 02.10.14.
 */
public class ConfirmRegistration {

    @Email
    @NotNull
    @Size(max = GlobalDataLengthConstants.EMAIL_LENGTH)
    private String email;

    @Size(max = GlobalDataLengthConstants.CODE_LENGTH)
    @NotNull
    private String code;

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

}
