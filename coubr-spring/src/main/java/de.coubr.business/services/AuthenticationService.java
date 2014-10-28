package com.coubr.business.services;

import com.coubr.business.exceptions.*;
import com.coubr.business.json.auth.*;
import com.coubr.data.entities.BusinessOwnerEntity;
import com.coubr.data.repositories.BusinessOwnerRepository;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

/**
 * Created by sebastian on 02.10.14.
 */
@Service("authenticationService")
public class AuthenticationService implements UserDetailsService {

    private static int CONFIRM_CODE_TOKEN_LENGTH = 20;
    private static int CONFIRM_CODE_EXPIRATION_DAYS = 30;
    private static int PASSWORD_RESET_CODE_TOKEN_LENGTH = 24;
    private static int PASSWORD_RESET_EXPIRATION_DAYS = 7;
    private static String ENCODING = "UTF-8";

    @Autowired
    private BCryptPasswordEncoder bcryptEncoder;

    @Autowired
    private MailService mailService;

    @Autowired
    private BusinessOwnerRepository businessOwnerRepository;


    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        return businessOwnerRepository.findByEmail(email);
    }

    public void login(Login data) throws EmailNotFoundException, PasswordNotFoundException, NotConfirmedException {

        BusinessOwnerEntity entity = getBusinessOwnerEntity(data.getEmail());

        if (entity.getConfirmationCode() != null) {
            throw new NotConfirmedException();
        }

//        if (entity.getUnlockCode() != null) {
//
//        }

        if (!bcryptEncoder.matches(data.getPassword(), entity.getPassword())) {
            throw new PasswordNotFoundException();
        }

    }

    public BusinessOwnerEntity resetPassword(ResetPassword data) throws EmailNotFoundException, SendMessageException {

        BusinessOwnerEntity entity = getBusinessOwnerEntity(data.getEmail());

        entity.setPasswordResetCode(RandomStringUtils.randomAlphanumeric(PASSWORD_RESET_CODE_TOKEN_LENGTH));

        Calendar calendar = new GregorianCalendar();
        calendar.setTime(new Date());
        calendar.add(Calendar.DAY_OF_YEAR, PASSWORD_RESET_EXPIRATION_DAYS);

        entity.setPasswordResetExpirationDate(calendar.getTime());

        businessOwnerRepository.save(entity);

        return entity;

    }

    public void resetPasswordConfirm(ResetPasswordConfirm data) throws EmailNotFoundException, CodeNotFoundException, ExpirationException {

        BusinessOwnerEntity entity = getBusinessOwnerEntity(data.getEmail());

        if (entity.getPasswordResetCode() == null && entity.getPasswordResetExpirationDate() == null) {
            throw new CodeNotFoundException();
        }


        if (!entity.getPasswordResetCode().equals(data.getCode())) {
            throw new CodeNotFoundException();
        }

        if (entity.getPasswordResetExpirationDate().before(new Date())) {
            throw new ExpirationException();
        }

        entity.setPasswordResetCode(null);
        entity.setPasswordResetExpirationDate(null);
        entity.setPassword(bcryptEncoder.encode(data.getPassword()));

        businessOwnerRepository.save(entity);

    }

    public BusinessOwnerEntity register(Register data) throws EmailFoundException, SendMessageException {

        BusinessOwnerEntity entity = businessOwnerRepository.findByEmail(data.getEmail());
        if (entity != null) {
            throw new EmailFoundException();
        }

        entity = new BusinessOwnerEntity();
        entity.setEmail(data.getEmail());
        entity.setPassword(bcryptEncoder.encode(data.getPassword()));

        entity.setConfirmationCode(RandomStringUtils.randomAlphanumeric(CONFIRM_CODE_EXPIRATION_DAYS));

        Calendar calendar = new GregorianCalendar();
        calendar.setTime(new Date());
        calendar.add(Calendar.DAY_OF_YEAR, CONFIRM_CODE_EXPIRATION_DAYS);

        entity.setConfirmExpirationDate(calendar.getTime());

        businessOwnerRepository.save(entity);

        return entity;

    }

    public void confirmRegistration(ConfirmRegistration data) throws EmailNotFoundException, CodeNotFoundException, ExpirationException, ConfirmedException {

        BusinessOwnerEntity entity = getBusinessOwnerEntity(data.getEmail());

        if (entity.getConfirmationCode() == null && entity.getConfirmExpirationDate() == null) {
            throw new ConfirmedException();
        }

        if (!entity.getConfirmationCode().equals(data.getCode())) {
            throw new CodeNotFoundException();
        }

        if (entity.getConfirmExpirationDate().before(new Date())) {
            throw new ExpirationException();
        }

        entity.setConfirmationCode(null);
        entity.setConfirmExpirationDate(null);

        businessOwnerRepository.save(entity);
    }




    public BusinessOwnerEntity resendConfirmation(ResendConfirmation data) throws EmailNotFoundException, SendMessageException, ConfirmedException {

        BusinessOwnerEntity entity = getBusinessOwnerEntity(data.getEmail());

        if (entity.getConfirmationCode() == null) {
            throw new ConfirmedException();
        }

        entity.setConfirmationCode(RandomStringUtils.randomAlphanumeric(CONFIRM_CODE_EXPIRATION_DAYS));

        Calendar calendar = new GregorianCalendar();
        calendar.setTime(new Date());
        calendar.add(Calendar.DAY_OF_YEAR, CONFIRM_CODE_EXPIRATION_DAYS);

        entity.setConfirmExpirationDate(calendar.getTime());

        businessOwnerRepository.save(entity);

        return entity;
    }

    /*
     * Private
     */

    private BusinessOwnerEntity getBusinessOwnerEntity(String email) throws EmailNotFoundException {
        BusinessOwnerEntity entity = businessOwnerRepository.findByEmail(email);
        if (entity == null) {
            throw new EmailNotFoundException();
        }
        return entity;
    }






}
