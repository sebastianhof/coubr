package com.coubr.web.controller;

import com.coubr.web.exceptions.*;
import com.coubr.web.json.Feedback;
import com.coubr.web.json.account.Account;
import com.coubr.web.json.account.AccountChangeEmail;
import com.coubr.web.json.account.AccountChangePassword;
import com.coubr.web.json.account.AccountName;
import com.coubr.web.json.auth.*;
import com.coubr.web.json.coupon.*;
import com.coubr.web.json.store.*;
import com.coubr.web.services.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

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
    private StoreService storeService;

    @Autowired
    private CouponService couponService;

    @Autowired
    private FeedbackService feedbackService;

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
    @RequestMapping(value = "/business/login", method = RequestMethod.POST)
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
    @RequestMapping(value = "/b/logout", method = RequestMethod.POST)
    public
    @ResponseBody
    String logout(HttpServletRequest request, HttpServletResponse response) throws UserNotLoggedInException {

        getEmailOfLoggedinUser(response);
        new SecurityContextLogoutHandler().logout(request, response, SecurityContextHolder.getContext().getAuthentication());
        return "business";

    }

    /**
     * Reset password
     *
     * @param data
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/business/resetPassword", method = RequestMethod.POST)
    public
    @ResponseBody
    String resetPassword(@RequestBody @Valid ResetPassword data, HttpServletRequest request, HttpServletResponse
            response) throws EmailNotFoundException, SendMessageException {

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
    @RequestMapping(value = "/business/resetPasswordConfirm", method = RequestMethod.POST)
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
    @RequestMapping(value = "/business/register", method = RequestMethod.POST)
    public
    @ResponseBody
    String register(@RequestBody @Valid Register data, HttpServletRequest request, HttpServletResponse response) throws SendMessageException, EmailFoundException {

        authenticationService.register(data, request, response);
        return "success";

    }

    /**
     * Confirm registration
     *
     * @param data
     * @return
     */
    @RequestMapping(value = "/business/confirmRegistration", method = RequestMethod.POST)
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

    @RequestMapping(value = "/business/resendConfirmation", method = RequestMethod.POST)
    public
    @ResponseBody
    String resendConfirmation(@RequestBody @Valid ResendConfirmation data, HttpServletRequest
            request, HttpServletResponse response) throws SendMessageException, EmailNotFoundException, ConfirmedException {

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

        return accountService.getAccount(getEmailOfLoggedinUser(response));

    }


    @RequestMapping(value = "b/account/password", method = RequestMethod.POST)
    public
    @ResponseBody
    String accountChangePassword(@RequestBody @Valid AccountChangePassword data, HttpServletResponse response) throws UserNotLoggedInException, PasswordNotFoundException, EmailNotFoundException {

        accountService.changePassword(getEmailOfLoggedinUser(response), data);
        return "success";

    }

    @RequestMapping(value = "b/account/email", method = RequestMethod.POST)
    public
    @ResponseBody
    String accountChangePassword(@RequestBody @Valid AccountChangeEmail data, HttpServletRequest request, HttpServletResponse
            response) throws UserNotLoggedInException, EmailNotFoundException, EmailFoundException {

        accountService.changeEmail(getEmailOfLoggedinUser(response), data);
        return "success";

    }

    @RequestMapping(value = "b/account/name", method = RequestMethod.POST)
    public
    @ResponseBody
    String accountChangeName(@RequestBody @Valid AccountName data, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException {

        accountService.changeName(getEmailOfLoggedinUser(response), data);
        return "success";

    }

    @RequestMapping(value = "b/account/name", method = RequestMethod.GET)
    public
    @ResponseBody
    AccountName accountName(HttpServletRequest request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException {

        return accountService.getName(getEmailOfLoggedinUser(response));

    }

    /**
     * ******************************
     * <p/>
     * Store (LocalBusiness)
     * <p/>
     * ******************************
     */

    @RequestMapping(value = "/b/stores", method = RequestMethod.GET)
    public
    @ResponseBody
    Stores stores(HttpServletRequest request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException {

        return storeService.getStores(getEmailOfLoggedinUser(response));

    }

    @RequestMapping(value = "/b/stores/details", method = RequestMethod.GET)
    public
    @ResponseBody
    StoresDetails storesDetails(HttpServletRequest request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException {

        return storeService.getStoresWithDetails(getEmailOfLoggedinUser(response));

    }

    @RequestMapping(value = "/b/store", method = RequestMethod.POST)
    public
    @ResponseBody
    Store addStore(@RequestBody @Valid AddStore data, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, PostalCodeNotFoundException, SubcategoryNotFoundException, TypeNotFoundException, CategoryNotFoundException {

        return storeService.addStore(getEmailOfLoggedinUser(response), data);

    }

    @RequestMapping(value = "/b/store/{storeId}", method = RequestMethod.GET)
    public
    @ResponseBody
    StoreDetails store(@PathVariable(value = "storeId") String storeId, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, StoreNotFoundException {

        return storeService.getStore(getEmailOfLoggedinUser(response), storeId);

    }

    @RequestMapping(value = "/b/store/{storeId}/pictures", method = RequestMethod.GET)
    public
    @ResponseBody
    StorePictures storePictures(@PathVariable(value = "storeId") String storeId, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, StoreNotFoundException {

        return storeService.getStorePictures(getEmailOfLoggedinUser(response), storeId);

    }

    @RequestMapping(value = "/b/store/{storeId}/location", method = RequestMethod.GET)
    public
    @ResponseBody
    StoreLocation storeLocation(@PathVariable(value = "storeId") String storeId, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, StoreNotFoundException {

        return storeService.getStoreLocation(getEmailOfLoggedinUser(response), storeId);

    }

    @RequestMapping(value = "/b/store/{storeId}/code", method = RequestMethod.GET)
    public
    @ResponseBody
    StoreCode storeCode(@PathVariable(value = "storeId") String storeId, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, StoreNotFoundException {

        return storeService.getStoreCode(getEmailOfLoggedinUser(response), storeId);

    }

    @RequestMapping(value = "/b/store/{storeId}/settings", method = RequestMethod.GET)
    public
    @ResponseBody
    StoreSettings storeSettings(@PathVariable(value = "storeId") String storeId, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, StoreNotFoundException {

        return storeService.getStoreSettings(getEmailOfLoggedinUser(response), storeId);

    }

    @RequestMapping(value = "/b/store/{storeId}/name", method = RequestMethod.POST)
    public
    @ResponseBody
    String storeChangeName(@PathVariable(value = "storeId") String storeId, @Valid @RequestBody StoreName data, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, StoreNotFoundException {

        storeService.changeStoreName(getEmailOfLoggedinUser(response), storeId, data);
        return "success";

    }

    @RequestMapping(value = "/b/store/{storeId}/name", method = RequestMethod.GET)
    public
    @ResponseBody
    StoreName storeName(@PathVariable(value = "storeId") String storeId, HttpServletResponse response) throws UserNotLoggedInException, StoreNotFoundException, EmailNotFoundException {

        return storeService.getStoreName(getEmailOfLoggedinUser(response), storeId);

    }

    @RequestMapping(value = "/b/store/{storeId}/address", method = RequestMethod.POST)
    public
    @ResponseBody
    String storeChangeAddress(@PathVariable(value = "storeId") String storeId, @Valid @RequestBody StoreAddress data, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, StoreNotFoundException, PostalCodeNotFoundException {

        storeService.changeStoreAddress(getEmailOfLoggedinUser(response), storeId, data);
        return "success";

    }

    @RequestMapping(value = "/b/store/{storeId}/address", method = RequestMethod.GET)
    public
    @ResponseBody
    StoreAddress storeAddress(@PathVariable(value = "storeId") String storeId, HttpServletResponse response) throws UserNotLoggedInException, StoreNotFoundException, EmailNotFoundException {

        return storeService.getStoreAddress(getEmailOfLoggedinUser(response), storeId);

    }

    @RequestMapping(value = "/b/store/{storeId}/contact", method = RequestMethod.POST)
    public
    @ResponseBody
    String storeChangeContact(@PathVariable(value = "storeId") String storeId, @Valid @RequestBody StoreContact data, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, StoreNotFoundException {

        storeService.changeStoreContact(getEmailOfLoggedinUser(response), storeId, data);
        return "success";

    }

    @RequestMapping(value = "/b/store/{storeId}/contact", method = RequestMethod.GET)
    public
    @ResponseBody
    StoreContact storeContact(@PathVariable(value = "storeId") String storeId, HttpServletResponse response) throws UserNotLoggedInException, StoreNotFoundException, EmailNotFoundException {

        return storeService.getStoreContact(getEmailOfLoggedinUser(response), storeId);

    }

    @RequestMapping(value = "/b/store/{storeId}/type", method = RequestMethod.POST)
    public
    @ResponseBody
    String storeChangeType(@PathVariable(value = "storeId") String storeId, @Valid @RequestBody StoreType data, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, StoreNotFoundException, SubcategoryNotFoundException, TypeNotFoundException, CategoryNotFoundException {

        storeService.changeStoreType(getEmailOfLoggedinUser(response), storeId, data);
        return "success";

    }

    @RequestMapping(value = "/b/store/{storeId}/type", method = RequestMethod.GET)
    public
    @ResponseBody
    StoreType storeType(@PathVariable(value = "storeId") String storeId, HttpServletResponse response) throws UserNotLoggedInException, StoreNotFoundException, EmailNotFoundException {

        return storeService.getStoreType(getEmailOfLoggedinUser(response), storeId);

    }

    @RequestMapping(value = "/b/store/{storeId}/close", method = RequestMethod.POST)
    public
    @ResponseBody
    String storeClose(@PathVariable(value = "storeId") String storeId, @Valid @RequestBody StoreClose data, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, StoreNotFoundException {

        storeService.close(getEmailOfLoggedinUser(response), storeId, data);
        return "success";

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
    Coupons coupons(HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException {

        return couponService.getCoupons(getEmailOfLoggedinUser(response));

    }

    @RequestMapping(value = "/b/coupons/active", method = RequestMethod.GET)
    public
    @ResponseBody
    CouponsDetails activeCoupons(HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException {

        return couponService.getActiveCoupons(getEmailOfLoggedinUser(response));

    }

    @RequestMapping(value = "/b/coupons/inactive", method = RequestMethod.GET)
    public
    @ResponseBody
    CouponsDetails inactiveCoupons(HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException {

        return couponService.getInactiveCoupons(getEmailOfLoggedinUser(response));

    }

    @RequestMapping(value = "/b/coupons/invalid", method = RequestMethod.GET)
    public
    @ResponseBody
    CouponsDetails invalidCoupons(HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException {

        return couponService.getInvalidCoupons(getEmailOfLoggedinUser(response));

    }

    @RequestMapping(value = "/b/coupon", method = RequestMethod.POST)
    public
    @ResponseBody
    Coupon addCoupon(@RequestBody @Valid AddCoupon data, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CategoryNotFoundException, StoreNotFoundException {

        return couponService.addCoupon(getEmailOfLoggedinUser(response), data);

    }

    @RequestMapping(value = "/b/coupon/{couponId}", method = RequestMethod.GET)
    public
    @ResponseBody
    CouponDetails coupon(@PathVariable(value = "couponId") String couponId, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CouponNotFoundException {

        return couponService.getCoupon(getEmailOfLoggedinUser(response), couponId);

    }

    @RequestMapping(value = "/b/coupon/{couponId}/stores", method = RequestMethod.GET)
    public
    @ResponseBody
    CouponStores couponStores(@PathVariable(value = "couponId") String couponId, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CouponNotFoundException {

        return couponService.getCouponStores(getEmailOfLoggedinUser(response), couponId);

    }

    @RequestMapping(value = "/b/coupon/{couponId}/stores", method = RequestMethod.POST)
    public
    @ResponseBody
    String couponChangeStores(@PathVariable(value = "couponId") String couponId, @Valid @RequestBody CouponChangeStores data, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CouponNotFoundException, StoreNotFoundException {

        couponService.changeCouponStores(getEmailOfLoggedinUser(response), couponId, data);
        return "success";

    }

    @RequestMapping(value = "/b/coupon/{couponId}/settings", method = RequestMethod.GET)
    public
    @ResponseBody
    CouponSettings couponSettings(@PathVariable(value = "couponId") String couponId, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CouponNotFoundException {

        return couponService.getCouponSettings(getEmailOfLoggedinUser(response), couponId);

    }

    @RequestMapping(value = "/b/coupon/{couponId}/title", method = RequestMethod.POST)
    public
    @ResponseBody
    String couponChangeTitle(@PathVariable(value = "couponId") String couponId, @Valid @RequestBody CouponTitle data, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CouponNotFoundException {

        couponService.changeCouponTitle(getEmailOfLoggedinUser(response), couponId, data);
        return "success";

    }

    @RequestMapping(value = "/b/coupon/{couponId}/title", method = RequestMethod.GET)
    public
    @ResponseBody
    CouponTitle couponTitle(@PathVariable(value = "couponId") String couponId, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CouponNotFoundException {

        return couponService.getCouponTitle(getEmailOfLoggedinUser(response), couponId);

    }

    @RequestMapping(value = "/b/coupon/{couponId}/validTo", method = RequestMethod.POST)
    public
    @ResponseBody
    String couponChangeValidTo(@PathVariable(value = "couponId") String couponId, @Valid @RequestBody CouponValidTo data, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CouponNotFoundException {

        couponService.changeCouponValidTo(getEmailOfLoggedinUser(response), couponId, data);
        return "success";

    }

    @RequestMapping(value = "/b/coupon/{couponId}/validTo", method = RequestMethod.GET)
    public
    @ResponseBody
    CouponValidTo couponValiTo(@PathVariable(value = "couponId") String couponId, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CouponNotFoundException {

        return couponService.getCouponValidTo(getEmailOfLoggedinUser(response), couponId);

    }

    @RequestMapping(value = "/b/coupon/{couponId}/amount", method = RequestMethod.POST)
    public
    @ResponseBody
    String couponChangeAmount(@PathVariable(value = "couponId") String couponId, @Valid @RequestBody CouponAmount data, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CouponNotFoundException, InvalidAmountException {

        couponService.changeCouponAmount(getEmailOfLoggedinUser(response), couponId, data);
        return "success";

    }

    @RequestMapping(value = "/b/coupon/{couponId}/amount", method = RequestMethod.GET)
    public
    @ResponseBody
    CouponAmount couponAmount(@PathVariable(value = "couponId") String couponId, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CouponNotFoundException {

        return couponService.getCouponAmount(getEmailOfLoggedinUser(response), couponId);

    }

    @RequestMapping(value = "/b/coupon/{couponId}/category", method = RequestMethod.POST)
    public
    @ResponseBody
    String couponChangeCategory(@PathVariable(value = "couponId") String couponId, @Valid @RequestBody CouponCategory data, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CouponNotFoundException, CategoryNotFoundException {

        couponService.changeCouponCategory(getEmailOfLoggedinUser(response), couponId, data);
        return "success";

    }

    @RequestMapping(value = "/b/coupon/{couponId}/category", method = RequestMethod.GET)
    public
    @ResponseBody
    CouponCategory couponCategory(@PathVariable(value = "couponId") String couponId, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CouponNotFoundException {

        return couponService.getCouponCategory(getEmailOfLoggedinUser(response), couponId);

    }

    @RequestMapping(value = "/b/coupon/activate", method = RequestMethod.POST)
    public
    @ResponseBody
    String couponActivate(@PathVariable(value = "couponId") String couponId, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CouponNotFoundException {

        couponService.activateCoupon(getEmailOfLoggedinUser(response), couponId);
        return "success";

    }

    @RequestMapping(value = "/b/coupon/deactivate", method = RequestMethod.POST)
    public
    @ResponseBody
    String couponDeactivate(@PathVariable(value = "couponId") String couponId, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CouponNotFoundException {

        couponService.deactivateCoupon(getEmailOfLoggedinUser(response), couponId);
        return "success";

    }

    @RequestMapping(value = "/b/coupon/delete", method = RequestMethod.POST)
    public
    @ResponseBody
    String couponDelete(@PathVariable(value = "couponId") String couponId, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CouponNotFoundException {

        couponService.deleteCoupon(getEmailOfLoggedinUser(response), couponId);
        return "success";

    }


    /**
     * ******************************
     * <p/>
     * Feedback (coubr beta)
     * <p/>
     * ******************************
     */

    @RequestMapping(value = "/b/feedback", method = RequestMethod.POST)
    public
    @ResponseBody
    String sendFeedback(@Valid @RequestBody Feedback data, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, SendMessageException {

        feedbackService.sendFeedback(getEmailOfLoggedinUser(response), data);
        return "success";

    }

    /*
     * Private methods
     */

    private String getEmailOfLoggedinUser(HttpServletResponse response) throws UserNotLoggedInException {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        UserDetails user = authenticationService.loadUserByUsername(auth.getName());

        if (user != null) {
            return user.getUsername();
        } else {
            throw new UserNotLoggedInException();
        }

    }

}
