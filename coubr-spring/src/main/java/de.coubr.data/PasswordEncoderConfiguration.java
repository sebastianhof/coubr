package com.coubr.data;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * Created by sebastian on 05.10.14.
 */
@Configuration
public class PasswordEncoderConfiguration {

    @Bean
    public BCryptPasswordEncoder bcryptEncoder() {
        return new BCryptPasswordEncoder();
    }


}
