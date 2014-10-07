package com.coubr.data.entities;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;
import java.util.*;

/**
 * Created by sebastian on 28.09.14.
 */
@Entity
@Table(name = "BusinessOwnerEntity")
public class BusinessOwnerEntity implements UserDetails {

    public static final String ROLE_NAME = "ROLE_BUSINESS_OWNER";

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long businessOwnerId;

    @Column(unique = true, nullable = false)
    private String email;

    @Column(nullable = false)
    private String password;

    private String firstName;

    private String lastName;

    /*
     * Account state
     */

    @Temporal(TemporalType.TIMESTAMP)
    private Date confirmExpirationDate;

    private String confirmationCode;

    private String unlockCode;

    @Temporal(TemporalType.TIMESTAMP)
    private Date passwordResetExpirationDate;

    private String passwordResetCode;

    @OneToMany(mappedBy = "businessOwner")
    private List<LocalBusinessEntity> stores;

    /*
     Getter and Setter
      */

    public long getBusinessOwnerId() {
        return businessOwnerId;
    }

    public void setBusinessOwnerId(long businessOwnerId) {
        this.businessOwnerId = businessOwnerId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public List<LocalBusinessEntity> getStores() {
        return stores;
    }

    public void setStores(List<LocalBusinessEntity> stores) {
        this.stores = stores;
    }

    /*
     * Account state - getter and setter
     */

    public String getConfirmationCode() {
        return confirmationCode;
    }

    public void setConfirmationCode(String confirmationCode) {
        this.confirmationCode = confirmationCode;
    }

    public Date getConfirmExpirationDate() {
        return confirmExpirationDate;
    }

    public void setConfirmExpirationDate(Date confirmExpirationDate) {
        this.confirmExpirationDate = confirmExpirationDate;
    }

    public String getUnlockCode() {
        return unlockCode;
    }

    public void setUnlockCode(String unlockCode) {
        this.unlockCode = unlockCode;
    }

    public String getPasswordResetCode() {
        return passwordResetCode;
    }

    public void setPasswordResetCode(String passwordResetCode) {
        this.passwordResetCode = passwordResetCode;
    }

    public Date getPasswordResetExpirationDate() {
        return passwordResetExpirationDate;
    }

    public void setPasswordResetExpirationDate(Date passwordResetExpirationDate) {
        this.passwordResetExpirationDate = passwordResetExpirationDate;
    }

    /*
     * UserDetails
     */

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        Set<GrantedAuthority> authorities = new HashSet<GrantedAuthority>();
        authorities.add(new SimpleGrantedAuthority(ROLE_NAME));
        return authorities;
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        // n.A.
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        // locked after many passwords attempts or upon request
        return unlockCode == null;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

}
