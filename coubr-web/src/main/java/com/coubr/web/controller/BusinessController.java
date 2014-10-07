package com.coubr.web.controller;

import com.coubr.web.json.CoubrWebError;
import com.coubr.web.json.account.Account;
import com.coubr.web.json.account.ChangeEmail;
import com.coubr.web.json.account.ChangeName;
import com.coubr.web.json.account.ChangePassword;
import com.coubr.web.json.auth.*;
import com.coubr.web.json.coupon.Coupon;
import com.coubr.web.json.coupon.CouponDetails;
import com.coubr.web.json.localbusiness.LocalBusiness;
import com.coubr.web.json.localbusiness.LocalBusinessDetails;
import com.coubr.web.services.AccountService;
import com.coubr.web.services.AuthenticationService;
import com.coubr.web.services.CouponService;
import com.coubr.web.services.LocalBusinessService;
import com.coubr.web.services.exception.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.List;

/**
 * Created by sebastian on 28.09.14.
 */
@Controller
public class BusinessController {

    @Autowired
    private AuthenticationService authenticationService;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private AccountService accountService;

    @Autowired
    private LocalBusinessService localBusinessService;

    @Autowired
    private CouponService couponService;

    /*
     * Single-page HTML
     */

    @RequestMapping(value = "/business", method = RequestMethod.GET)
    public String business() {
        return "business";
    }

    @RequestMapping(value = "/b", method = RequestMethod.GET)
    public String businessAuth() {
        return "b";
    }

    /*
     * Authorization
     */

    /**
     * Login
     *
     * @param data
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/business/login.do", method = RequestMethod.POST)
    public
    @ResponseBody
    String login(@RequestBody @Valid Login data, HttpServletRequest request, HttpServletResponse response) throws EmailNotFoundException, NotConfirmedException, PasswordNotFoundException {

        String email = data.getEmail();
        String password = data.getPassword();

        authenticationService.login(data);

        Authentication authenticationToken = new UsernamePasswordAuthenticationToken(email, password);

        Authentication authentication = authenticationManager.authenticate(authenticationToken);

        SecurityContext securityContext = SecurityContextHolder.getContext();
        securityContext.setAuthentication(authentication);

        HttpSession session = request.getSession(true);
        session.setAttribute("SPRING_SECURITY_CONTEXT", securityContext);

        return "success";

    }

    /**
     * Logout
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/b/logout.do", method = RequestMethod.POST)
    public
    @ResponseBody
    String logout(HttpServletRequest request, HttpServletResponse response) throws UserNotLoggedInException {

        UserDetails user = getUserFromSecurityContext(response);

        if (user != null) {
            new SecurityContextLogoutHandler().logout(request, response, SecurityContextHolder.getContext().getAuthentication());
            return "business";
        } else {
            throw new UserNotLoggedInException();
        }

    }

    /**
     * Reset password
     *
     * @param data
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/business/resetPassword.do", method = RequestMethod.POST)
    public
    @ResponseBody
    String resetPassword(@RequestBody @Valid ResetPassword data, HttpServletRequest request, HttpServletResponse
            response) throws EmailNotFoundException, MessagingException {

        authenticationService.resetPassword(data, request, response);

        return "success";
    }

    /**
     * Reset password confirm
     *
     * @param data
     * @param response
     * @return
     */
    @RequestMapping(value = "/business/resetPasswordConfirm.do", method = RequestMethod.POST)
    public
    @ResponseBody
    String resetPasswordConfirm(@RequestBody @Valid ResetPasswordConfirm data, HttpServletResponse response) throws CodeNotFoundException, ExpirationException, EmailNotFoundException {

        authenticationService.resetPasswordConfirm(data);

        return "success";
    }

    /**
     * register
     *
     * @param data
     * @return
     */
    @RequestMapping(value = "/business/register.do", method = RequestMethod.POST)
    public
    @ResponseBody
    String register(@RequestBody @Valid Register data, HttpServletRequest request, HttpServletResponse response) throws MessagingException, EmailFoundException {

        authenticationService.register(data, request, response);

        return "success";
    }

    /**
     * Confirm registration
     *
     * @param data
     * @return
     */
    @RequestMapping(value = "/business/confirmRegistration.do", method = RequestMethod.POST)
    public
    @ResponseBody
    String confirmRegistration(@RequestBody @Valid ConfirmRegistration data) throws CodeNotFoundException, ExpirationException, EmailNotFoundException, ConfirmedException {

        authenticationService.confirmRegistration(data);

        return "success";
    }

    /**
     * Resend confirmation
     *
     * @param data
     * @return
     */

    @RequestMapping(value = "/business/resendConfirmation.do", method = RequestMethod.POST)
    public
    @ResponseBody
    String resendConfirmation(@RequestBody @Valid ResendConfirmation data, HttpServletRequest
            request, HttpServletResponse response) throws MessagingException, EmailNotFoundException, ConfirmedException {

        authenticationService.resendConfirmation(data, request, response);

        return "success";
    }

    /**
     * ******************************
     * <p/>
     * Account
     * <p/>
     * ******************************
     */

    @RequestMapping(value = "/b/account", method = RequestMethod.GET)
    public
    @ResponseBody
    Account account(HttpServletRequest request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException {

        UserDetails user = getUserFromSecurityContext(response);

        if (user != null) {
            return accountService.getAccount(user.getUsername());
        } else {
            throw new UserNotLoggedInException();
        }

    }


    @RequestMapping(value = "b/account/changePassword.do", method = RequestMethod.POST)
    public
    @ResponseBody
    String changePassword(@RequestBody @Valid ChangePassword data, HttpServletResponse response) throws UserNotLoggedInException, PasswordNotFoundException, EmailNotFoundException {

        UserDetails user = getUserFromSecurityContext(response);

        if (user != null) {
            accountService.changePassword(user.getUsername(), data);
        } else {
            throw new UserNotLoggedInException();
        }

        return "success";
    }

    @RequestMapping(value = "b/account/changeEmail.do", method = RequestMethod.POST)
    public
    @ResponseBody
    String changePassword(@RequestBody @Valid ChangeEmail data, HttpServletRequest request, HttpServletResponse
            response) throws UserNotLoggedInException, EmailNotFoundException, EmailFoundException {

        UserDetails user = getUserFromSecurityContext(response);

        if (user != null) {
            accountService.changeEmail(user.getUsername(), data);
        } else {
            throw new UserNotLoggedInException();
        }

        return "success";
    }

    @RequestMapping(value = "b/account/changeName.do", method = RequestMethod.POST)
    public
    @ResponseBody
    String changeName(@RequestBody @Valid ChangeName data, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException {

        UserDetails user = getUserFromSecurityContext(response);

        if (user != null) {
            accountService.changeName(user.getUsername(), data);
        } else {
            throw new UserNotLoggedInException();
        }

        return "success";
    }

    /**
     * ******************************
     * <p/>
     * Store
     * <p/>
     * ******************************
     */

    @RequestMapping(value = "/b/stores", method = RequestMethod.GET)
    public
    @ResponseBody
    List<LocalBusiness> localBusinesses(HttpServletRequest request, HttpServletResponse response) throws UserNotLoggedInException {

        UserDetails user = getUserFromSecurityContext(response);

        if (user != null) {
            return localBusinessService.getStores(user.getUsername());
        } else {
            throw new UserNotLoggedInException();
        }

    }

    @RequestMapping(value = "/b/storesWithDetails", method = RequestMethod.GET)
    public
    @ResponseBody
    List<LocalBusinessDetails> localBusinessesWithDetails(HttpServletRequest request, HttpServletResponse response) throws UserNotLoggedInException {

        UserDetails user = getUserFromSecurityContext(response);

        if (user != null) {
            return localBusinessService.getStoresWithDetails(user.getUsername());
        } else {
            throw new UserNotLoggedInException();
        }

    }

    @RequestMapping(value = "/b/store/{storeId}", method = RequestMethod.GET)
    public
    @ResponseBody
    LocalBusinessDetails localBusiness(@PathVariable(value = "storeId") String storeId, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException {

        UserDetails user = getUserFromSecurityContext(response);

        if (user != null) {
            return localBusinessService.getStore(user.getUsername(), storeId);
        } else {
            throw new UserNotLoggedInException();
        }

    }

    /**
     * ******************************
     * <p/>
     * Coupon
     * <p/>
     * ******************************
     */

    @RequestMapping(value = "/b/coupons", method = RequestMethod.GET)
    public
    @ResponseBody
    List<Coupon> coupons(HttpServletRequest request, HttpServletResponse response) throws UserNotLoggedInException {

        UserDetails user = getUserFromSecurityContext(response);

        if (user != null) {
            return couponService.getCoupons(user.getUsername());
        } else {
            throw new UserNotLoggedInException();
        }

    }

    @RequestMapping(value = "/b/couponsWithDetails", method = RequestMethod.GET)
    public
    @ResponseBody
    List<CouponDetails> couponsWithDetails(HttpServletRequest request, HttpServletResponse response) throws UserNotLoggedInException {

        UserDetails user = getUserFromSecurityContext(response);

        if (user != null) {
            return couponService.getCouponsWithDetails(user.getUsername());
        } else {
            throw new UserNotLoggedInException();
        }

    }

    @RequestMapping(value = "/b/coupon/{couponId}", method = RequestMethod.GET)
    public
    @ResponseBody
    CouponDetails coupon(@PathVariable(value = "couponId") String couponId, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException {

        UserDetails user = getUserFromSecurityContext(response);

        if (user != null) {
            return couponService.getCoupon(user.getUsername(), couponId);
        } else {
            throw new UserNotLoggedInException();
        }

    }

    /*
     * Exception Handler
     */

    @ExceptionHandler(UserNotLoggedInException.class)
    @ResponseStatus(value = HttpStatus.BAD_REQUEST, reason = "User not logged in")
    public
    @ResponseBody
    CoubrWebError userNotLoggedIn(HttpServletRequest request, Exception ex) {

        return new CoubrWebError(4000);

    }

    @ExceptionHandler({EmailNotFoundException.class, UsernameNotFoundException.class})
    @ResponseStatus(value = HttpStatus.BAD_REQUEST, reason = "Email not found")
    @ResponseBody
    CoubrWebError emailNotFound(HttpServletRequest request, Exception ex) {

        return new CoubrWebError(4001);

    }

    @ExceptionHandler(PasswordNotFoundException.class)
    @ResponseStatus(value = HttpStatus.BAD_REQUEST, reason = "Password not found")
    @ResponseBody
    CoubrWebError passwordNotFound(HttpServletRequest request, Exception ex) {

        return new CoubrWebError(4002);

    }

    @ExceptionHandler(CodeNotFoundException.class)
    @ResponseStatus(value = HttpStatus.BAD_REQUEST, reason = "Code not found")
    @ResponseBody
    CoubrWebError codeNotFound(HttpServletRequest request, Exception ex) {

        return new CoubrWebError(4003);

    }

    @ExceptionHandler(NotConfirmedException.class)
    @ResponseStatus(value = HttpStatus.BAD_REQUEST, reason = "Not confirmed")
    @ResponseBody
    CoubrWebError notConfirmed(HttpServletRequest request, Exception ex) {

        return new CoubrWebError(4004);

    }

    @ExceptionHandler(ConfirmedException.class)
    @ResponseStatus(value = HttpStatus.BAD_REQUEST, reason = "Confirmed")
    @ResponseBody
    CoubrWebError confirmed(HttpServletRequest request, Exception ex) {

        return new CoubrWebError(4005);

    }

    @ExceptionHandler(ExpirationException.class)
    @ResponseStatus(value = HttpStatus.BAD_REQUEST, reason = "Expired")
    @ResponseBody
    CoubrWebError expired(HttpServletRequest request, Exception ex) {

        return new CoubrWebError(4006);

    }


    @ExceptionHandler(EmailFoundException.class)
    @ResponseStatus(value = HttpStatus.CONFLICT, reason = "Email already available")
    @ResponseBody
    CoubrWebError emailFound(HttpServletRequest request, Exception ex) {

        return new CoubrWebError(4091);

    }

    @ExceptionHandler(MessagingException.class)
    @ResponseStatus(value = HttpStatus.INTERNAL_SERVER_ERROR, reason = "Could not send email")
    @ResponseBody
    CoubrWebError messagingError(HttpServletRequest request, Exception ex) {

        return new CoubrWebError(5001);

    }

    /*
     * Private methods
     */

    private UserDetails getUserFromSecurityContext(HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return authenticationService.loadUserByUsername(auth.getName());
    }

}
