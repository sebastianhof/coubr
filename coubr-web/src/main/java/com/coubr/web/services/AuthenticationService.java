package com.coubr.web.services;

import com.coubr.data.entities.BusinessOwnerEntity;
import com.coubr.data.repositories.BusinessOwnerRepository;
import com.coubr.web.json.auth.*;
import com.coubr.web.services.exception.*;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.util.UriComponentsBuilder;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.spring4.context.SpringWebContext;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * Created by sebastian on 02.10.14.
 */
@Service("authenticationService")
@Transactional
public class AuthenticationService implements UserDetailsService {

    private static int CONFIRM_CODE_TOKEN_LENGTH = 20;
    private static int CONFIRM_CODE_EXPIRATION_DAYS = 30;
    private static int PASSWORD_RESET_CODE_TOKEN_LENGTH = 24;
    private static int PASSWORD_RESET_EXPIRATION_DAYS = 7;
    private static String ENCODING = "UTF-8";

    @Autowired
    BCryptPasswordEncoder bcryptEncoder;

    @Autowired
    MailService mailService;

    @Autowired
    BusinessOwnerRepository repository;

    @Autowired
    TemplateEngine templateEngine;

    @Autowired
    ApplicationContext applicationContext;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        return repository.findByEmail(email);
    }

    public void login(Login data) throws EmailNotFoundException, PasswordNotFoundException, NotConfirmedException {
        BusinessOwnerEntity entity = repository.findByEmail(data.getEmail());
        if (entity == null) {
            throw new EmailNotFoundException();
        }

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

    public void resetPassword(ResetPassword data, HttpServletRequest request, HttpServletResponse response) throws EmailNotFoundException, MessagingException {

        BusinessOwnerEntity entity = repository.findByEmail(data.getEmail());
        if (entity == null) {
            throw new EmailNotFoundException();
        }

        entity.setPasswordResetCode(RandomStringUtils.randomAlphanumeric(PASSWORD_RESET_CODE_TOKEN_LENGTH));

        Calendar calendar = new GregorianCalendar();
        calendar.setTime(new Date());
        calendar.add(Calendar.DAY_OF_YEAR, PASSWORD_RESET_EXPIRATION_DAYS);

        entity.setPasswordResetExpirationDate(calendar.getTime());

        repository.save(entity);

        sendPasswordResetLetter(entity, request, response);

    }

    public void resetPasswordConfirm(ResetPasswordConfirm data) throws EmailNotFoundException, CodeNotFoundException, ExpirationException {

        BusinessOwnerEntity entity = repository.findByEmail(data.getEmail());
        if (entity == null) {
            throw new EmailNotFoundException();
        }

        if (entity.getPasswordResetCode() == null && entity.getPasswordResetExpirationDate() == null) {
            throw new CodeNotFoundException();
        }


        if (!entity.getPasswordResetCode().equals(data.getCode())) {
            throw new CodeNotFoundException();
        }

        if (entity.getPasswordResetExpirationDate().compareTo(new Date()) < 0) {
            throw new ExpirationException();
        }

        entity.setPasswordResetCode(null);
        entity.setPasswordResetExpirationDate(null);
        entity.setPassword(bcryptEncoder.encode(data.getPassword()));

        repository.save(entity);

    }

    public void register(Register data, HttpServletRequest request, HttpServletResponse response) throws EmailFoundException, MessagingException {

        BusinessOwnerEntity entity = repository.findByEmail(data.getEmail());
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

        repository.save(entity);

        sendConfirmLetter(entity, request, response);

    }

    public void confirmRegistration(ConfirmRegistration data) throws EmailNotFoundException, CodeNotFoundException, ExpirationException, ConfirmedException {

        BusinessOwnerEntity entity = repository.findByEmail(data.getEmail());
        if (entity == null) {
            throw new EmailNotFoundException();
        }

        if (entity.getConfirmationCode() == null && entity.getConfirmExpirationDate() == null) {
            throw new ConfirmedException();
        }

        if (!entity.getConfirmationCode().equals(data.getCode())) {
            throw new CodeNotFoundException();
        }

        if (entity.getConfirmExpirationDate().compareTo(new Date()) < 0) {
            throw new ExpirationException();
        }

        entity.setConfirmationCode(null);
        entity.setConfirmExpirationDate(null);

        repository.save(entity);
    }


    public void resendConfirmation(ResendConfirmation data, HttpServletRequest request, HttpServletResponse response) throws EmailNotFoundException, MessagingException, ConfirmedException {

        BusinessOwnerEntity entity = repository.findByEmail(data.getEmail());
        if (entity == null) {
            throw new EmailNotFoundException();
        }

        if (entity.getConfirmationCode() == null) {
            throw new ConfirmedException();
        }

        entity.setConfirmationCode(RandomStringUtils.randomAlphanumeric(CONFIRM_CODE_EXPIRATION_DAYS));

        Calendar calendar = new GregorianCalendar();
        calendar.setTime(new Date());
        calendar.add(Calendar.DAY_OF_YEAR, CONFIRM_CODE_EXPIRATION_DAYS);

        entity.setConfirmExpirationDate(calendar.getTime());

        repository.save(entity);

        sendConfirmLetter(entity, request, response);
    }

    private void sendConfirmLetter(BusinessOwnerEntity entity, HttpServletRequest request, HttpServletResponse response) throws MessagingException {
        mailService.sendEmail(entity.getEmail(), "coubr: Confirm your registration", createPlainConfirmLetter(entity, request), createHTMLConfirmLetter(entity, request, response));
    }

    private void sendPasswordResetLetter(BusinessOwnerEntity entity, HttpServletRequest request, HttpServletResponse response) throws MessagingException {
        mailService.sendEmail(entity.getEmail(), "coubr: You're password request", createPlainPasswordResetLetter(entity, request), createHTMLPasswordResetLetter(entity, request, response));
    }

    private String createHTMLConfirmLetter(BusinessOwnerEntity entity, HttpServletRequest request, HttpServletResponse response) {

        UriComponentsBuilder builder = UriComponentsBuilder.newInstance();
        builder.scheme(request.getScheme());
        builder.host(request.getServerName());
        builder.port(request.getServerPort());
        builder.path(request.getContextPath() + "/business#/confirmRegistration");
        MultiValueMap<String, String> queryParams = new LinkedMultiValueMap<String, String>();
        queryParams.put("email", Collections.singletonList(entity.getEmail()));
        queryParams.put("code", Collections.singletonList(entity.getConfirmationCode()));
        builder.queryParams(queryParams);

        String link = builder.build().toUriString();

        SpringWebContext ctx = new SpringWebContext(request, response, request.getServletContext(), Locale.ENGLISH, null, applicationContext);
        ctx.setVariable("code", entity.getConfirmationCode());
        ctx.setVariable("link", link);
        return templateEngine.process("confirmEmail.html", ctx);
    }

    private String createPlainConfirmLetter(BusinessOwnerEntity entity, HttpServletRequest request) {

        UriComponentsBuilder builder = UriComponentsBuilder.newInstance();
        builder.scheme(request.getScheme());
        builder.host(request.getServerName());
        builder.port(request.getServerPort());
        builder.path(request.getContextPath() + "/business#/confirmRegistration");
        MultiValueMap<String, String> queryParams = new LinkedMultiValueMap<String, String>();
        queryParams.put("email", Collections.singletonList(entity.getEmail()));
        queryParams.put("code", Collections.singletonList(entity.getConfirmationCode()));
        builder.queryParams(queryParams);

        String link = builder.build().toUriString();

        StringBuilder plainContentBuilder = new StringBuilder();
        plainContentBuilder.append("Please confirm your coubr account\n\n");
        plainContentBuilder.append("Hi there,\n\n" +
                "You recently registered on coubr. Please confirm your registration by following the link below:\n\n");
        plainContentBuilder.append(link + "\n\n");
        plainContentBuilder.append("You're password reset code: " + entity.getConfirmationCode() + "\n\n");
        plainContentBuilder.append("You have 30 days to confirm your registration.\n\n" +
                "Thanks,\n\n" +
                "coubr Team");

        return plainContentBuilder.toString();
    }


    private String createHTMLPasswordResetLetter(BusinessOwnerEntity entity, HttpServletRequest request, HttpServletResponse response) {

        UriComponentsBuilder builder = UriComponentsBuilder.newInstance();
        builder.scheme(request.getScheme());
        builder.host(request.getServerName());
        builder.port(request.getServerPort());
        builder.path(request.getContextPath() + "/business#/resetPasswordConfirm");
        MultiValueMap<String, String> queryParams = new LinkedMultiValueMap<String, String>();
        queryParams.put("email", Collections.singletonList(entity.getEmail()));
        queryParams.put("code", Collections.singletonList(entity.getPasswordResetCode()));
        builder.queryParams(queryParams);

        String link = builder.build().toUriString();

        SpringWebContext ctx = new SpringWebContext(request, response, request.getServletContext(), Locale.ENGLISH, null, applicationContext);
        ctx.setVariable("code", entity.getPasswordResetCode());
        ctx.setVariable("link", link);
        return templateEngine.process("resetPasswordEmail.html", ctx);
    }

    private String createPlainPasswordResetLetter(BusinessOwnerEntity entity, HttpServletRequest request) {

        UriComponentsBuilder builder = UriComponentsBuilder.newInstance();
        builder.scheme(request.getScheme());
        builder.host(request.getServerName());
        builder.port(request.getServerPort());
        builder.path(request.getContextPath() + "/business#/resetPasswordConfirm");
        MultiValueMap<String, String> queryParams = new LinkedMultiValueMap<String, String>();
        queryParams.put("email", Collections.singletonList(entity.getEmail()));
        queryParams.put("code", Collections.singletonList(entity.getPasswordResetCode()));
        builder.queryParams(queryParams);

        String link = builder.build().toUriString();

        StringBuilder plainContentBuilder = new StringBuilder();
        plainContentBuilder.append("You have requested a password reset\n\n");
        plainContentBuilder.append("Hi there,\n\n" +
                "You recently requested a link to reset your coubr password. Please set a new password by following the link below:\n\n");
        plainContentBuilder.append(link + "\n\n");
        plainContentBuilder.append("You're confirmation code: " + entity.getPasswordResetCode() + "\n\n");
        plainContentBuilder.append("You can ignore this mail when you did not requested a link. Your code will expire in 7 days.\n\n" +
                "Thanks,\n\n" +
                "coubr Team");

        return plainContentBuilder.toString();
    }


}
