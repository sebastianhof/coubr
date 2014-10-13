package com.coubr.web.services;

import com.coubr.data.repositories.BusinessOwnerRepository;
import com.coubr.web.json.account.*;
import com.coubr.web.exceptions.EmailNotFoundException;
import com.coubr.data.entities.BusinessOwnerEntity;
import com.coubr.web.json.account.AccountChangeEmail;
import com.coubr.web.json.account.AccountChangePassword;
import com.coubr.web.exceptions.EmailFoundException;
import com.coubr.web.exceptions.PasswordNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

/**
 * Created by sebastian on 04.10.14.
 */
@Service("accountService")
public class AccountService {

    @Autowired
    BusinessOwnerRepository repository;

    @Autowired
    BCryptPasswordEncoder bcryptEncoder;

    /*
     * Getter
     */

    public Account getAccount(String email) throws EmailNotFoundException {

        BusinessOwnerEntity entity = getBusinessOwnerEntity(email);

        Account account = new Account();
        account.setEmail(entity.getEmail());
        account.setFirstName(entity.getFirstName());
        account.setLastName(entity.getLastName());

        return account;
    }

    public AccountName getName(String email) throws EmailNotFoundException {
        BusinessOwnerEntity entity = getBusinessOwnerEntity(email);

        AccountName accountName = new AccountName();
        accountName.setFirstName(entity.getFirstName());
        accountName.setLastName((entity.getLastName()));

        return accountName;
    }

    /*
     * Setter
     */

    public void changePassword(String email, AccountChangePassword data) throws EmailNotFoundException, PasswordNotFoundException {

        BusinessOwnerEntity entity = getBusinessOwnerEntity(email);

        if (!bcryptEncoder.matches(data.getPassword(), entity.getPassword())) {
            throw new PasswordNotFoundException();
        }

        entity.setPassword(bcryptEncoder.encode(data.getNewPassword()));
        repository.save(entity);

    }

    public void changeEmail(String email, AccountChangeEmail data) throws EmailNotFoundException, EmailFoundException {

        BusinessOwnerEntity entity = getBusinessOwnerEntity(email);


        if (repository.findByEmail(data.getNewEmail()) != null) {
            throw new EmailFoundException();
        }

        entity.setEmail(data.getNewEmail());
        repository.save(entity);

    }

    public void changeName(String email, AccountName data) throws EmailNotFoundException {

        BusinessOwnerEntity entity = getBusinessOwnerEntity(email);

        entity.setFirstName(data.getFirstName());
        entity.setLastName(data.getLastName());
        repository.save(entity);

    }

    /*
     * Private
     */

    private BusinessOwnerEntity getBusinessOwnerEntity(String email) throws EmailNotFoundException {
        BusinessOwnerEntity entity = repository.findByEmail(email);
        if (entity == null) {
            throw new EmailNotFoundException();
        }
        return entity;
    }



}
