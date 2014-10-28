package com.coubr.business;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;

import java.util.Properties;

/**
 * Created by sebastian on 15.10.14.
 */
@Configuration
public class MailConfiguration {

    @Bean
    public JavaMailSender mailSender() {

        JavaMailSenderImpl sender = new JavaMailSenderImpl();

        sender.setHost("smtp.zoho.com");
        sender.setPort(587);
        sender.setProtocol("smtp");
        sender.setUsername("daemon@sebastianhof.com");
        sender.setPassword("zBjt[7cjLtag=7#E4XP4aDmXzuMrg*");

        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        sender.setJavaMailProperties(properties);

        return sender;
    }

}