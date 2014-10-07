package com.coubr.web.services;

import com.coubr.data.repositories.BusinessOwnerRepository;
import com.coubr.web.json.account.ChangePassword;
import com.coubr.web.services.exception.EmailNotFoundException;
import com.coubr.data.entities.BusinessOwnerEntity;
import com.coubr.data.repositories.BusinessOwnerRepository;
import com.coubr.web.json.account.Account;
import com.coubr.web.json.account.ChangeEmail;
import com.coubr.web.json.account.ChangeName;
import com.coubr.web.json.account.ChangePassword;
import com.coubr.web.services.exception.EmailFoundException;
import com.coubr.web.services.exception.EmailNotFoundException;
import com.coubr.web.services.exception.PasswordNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by sebastian on 04.10.14.
 */
@Service("accountService")
@Transactional
public class AccountService {

    @Autowired
    BusinessOwnerRepository repository;

    @Autowired
    BCryptPasswordEncoder bcryptEncoder;

    public Account getAccount(String email) throws EmailNotFoundException {

        BusinessOwnerEntity entity = repository.findByEmail(email);
        if (entity == null) {
            throw new EmailNotFoundException();
        }

        Account account = new Account();
        account.setEmail(entity.getEmail());
        account.setFirstName(entity.getFirstName());
        account.setLastName(entity.getLastName());

        return account;
    }

    public void changePassword(String email, ChangePassword data) throws EmailNotFoundException, PasswordNotFoundException {

        BusinessOwnerEntity entity = repository.findByEmail(email);
        if (entity == null) {
            throw new EmailNotFoundException();
        }

        if (!bcryptEncoder.matches(data.getPassword(), entity.getPassword())) {
            throw new PasswordNotFoundException();
        }

        entity.setPassword(bcryptEncoder.encode(data.getNewPassword()));
        repository.save(entity);

    }

    public void changeEmail(String email, ChangeEmail data) throws EmailNotFoundException, EmailFoundException {

        BusinessOwnerEntity entity = repository.findByEmail(email);
        if (entity == null) {
            throw new EmailNotFoundException();
        }


        if (repository.findByEmail(data.getNewEmail()) != null) {
            throw new EmailFoundException();
        }

        entity.setEmail(data.getNewEmail());
        repository.save(entity);

    }

    public void changeName(String email, ChangeName data) throws EmailNotFoundException {

        BusinessOwnerEntity entity = repository.findByEmail(email);
        if (entity == null) {
            throw new EmailNotFoundException();
        }

        entity.setFirstName(data.getFirstName());
        entity.setLastName(data.getLastName());
        repository.save(entity);

    }


}
