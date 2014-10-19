package com.coubr.data.entities;

import com.coubr.data.GlobalDataLengthConstants;
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

    @Column(nullable = false, length = GlobalDataLengthConstants.EMAIL_LENGTH, unique = true)
    private String email;

    @Column(nullable = false, length = GlobalDataLengthConstants.PASSWORD_ENCODED_LENGTH)
    private String password;

    @Column(nullable = true, length = GlobalDataLengthConstants.NAME_LENGTH)
    private String firstName;

    @Column(nullable = true, length = GlobalDataLengthConstants.NAME_LENGTH)
    private String lastName;

    /*
     * Account state
     */

    @Temporal(TemporalType.TIMESTAMP)
    @Column(nullable = true)
    private Date confirmExpirationDate;

    @Column(nullable = true, length = GlobalDataLengthConstants.CODE_LENGTH)
    private String confirmationCode;

    @Column(nullable = true, length = GlobalDataLengthConstants.CODE_LENGTH)
    private String unlockCode;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(nullable = true)
    private Date passwordResetExpirationDate;

    @Column(nullable = true, length = GlobalDataLengthConstants.CODE_LENGTH)
    private String passwordResetCode;

    @OneToMany(mappedBy = "businessOwner")
    private List<LocalBusinessEntity> stores = new ArrayList<LocalBusinessEntity>();

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

    public List<LocalBusinessEntity> getLocalBusinesses() {
        return stores;
    }

    public void setLocalBusinesses(List<LocalBusinessEntity> stores) {
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

    @Override
    public boolean equals(Object obj) {

        if (obj instanceof BusinessOwnerEntity) {

            BusinessOwnerEntity businessOwnerEntity = (BusinessOwnerEntity) obj;

            if (businessOwnerEntity.getBusinessOwnerId() == businessOwnerId) {
                return true;
            }

        }

        return false;
    }

    @Override
    public int hashCode() {
        return new Long(businessOwnerId).hashCode();
    }

}
