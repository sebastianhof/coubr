package com.coubr.business.services;

import com.coubr.business.exceptions.EmailFoundException;
import com.coubr.business.exceptions.EmailNotFoundException;
import com.coubr.business.exceptions.PasswordNotFoundException;
import com.coubr.business.json.account.*;
import com.coubr.data.entities.BusinessOwnerEntity;
import com.coubr.data.entities.LocalBusinessEntity;
import com.coubr.data.entities.OfferEntity;
import com.coubr.data.repositories.BusinessOwnerRepository;
import com.coubr.data.repositories.LocalBusinessRepository;
import com.coubr.data.repositories.OfferRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by sebastian on 04.10.14.
 */
@Service("accountService")
public class AccountService {

    @Autowired
    BusinessOwnerRepository repository;

    @Autowired
    OfferRepository offerRepository;

    @Autowired
    LocalBusinessRepository localBusinessRepository;

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

    public void delete(String email, AccountDelete data) throws EmailNotFoundException {

        BusinessOwnerEntity entity = getBusinessOwnerEntity(email);

        // TODO do something with reason

        // delete coupons
        List<OfferEntity> offerEntities = offerRepository.findByBusinessOwner(entity);
        for (OfferEntity offerEntity: offerEntities) {
            offerRepository.delete(offerEntity);
        }

        for (LocalBusinessEntity localBusinessEntity: entity.getLocalBusinesses()) {
            localBusinessRepository.delete(localBusinessEntity);
        }

        repository.delete(entity);
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
