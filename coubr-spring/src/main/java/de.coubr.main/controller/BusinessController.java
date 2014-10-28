package com.coubr.main.controller;

import com.coubr.business.exceptions.*;
import com.coubr.business.json.Feedback;
import com.coubr.business.json.account.*;
import com.coubr.business.json.auth.*;
import com.coubr.business.json.coupon.*;
import com.coubr.business.json.store.*;
import com.coubr.business.services.*;
import com.coubr.data.entities.BusinessOwnerEntity;
import com.coubr.main.exceptions.UserNotLoggedInException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.spring4.context.SpringWebContext;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.Collections;
import java.util.Locale;

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
    private TemplateEngine templateEngine;

    @Autowired
    private MailService mailService;

    @Autowired
    private ApplicationContext applicationContext;

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

        BusinessOwnerEntity entity = authenticationService.resetPassword(data);
        sendPasswordResetLetter(entity, request, response);
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

        BusinessOwnerEntity entity = authenticationService.register(data);
        sendConfirmLetter(entity, request, response);
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

        BusinessOwnerEntity entity = authenticationService.resendConfirmation(data);
        sendConfirmLetter(entity, request, response);
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

    @RequestMapping(value = "b/account/delete", method = RequestMethod.POST)
    public
    @ResponseBody
    String accountDelete(@RequestBody @Valid AccountDelete data, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException {

        accountService.delete(getEmailOfLoggedinUser(response), data);
        return "success";

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

    @RequestMapping(value = "/b/store/{storeId}/location", method = RequestMethod.POST)
    public
    @ResponseBody
    String changeStoreLocation(@PathVariable(value = "storeId") String storeId, @Valid @RequestBody StoreLocation data, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, StoreNotFoundException {

        storeService.changeStoreLocation(getEmailOfLoggedinUser(response), storeId, data);
        return "success";

    }

    @RequestMapping(value = "/b/store/{storeId}/code", method = RequestMethod.GET)
    public
    @ResponseBody
    StoreCode storeCode(@PathVariable(value = "storeId") String storeId, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, StoreNotFoundException {

        return storeService.getStoreCode(getEmailOfLoggedinUser(response), storeId);

    }

    @RequestMapping(value = "/b/store/{storeId}/code/qr-{dimension}.png", method = RequestMethod.GET, produces = MediaType.IMAGE_PNG_VALUE)
    public
    @ResponseBody
    byte[] storeQRCode(@PathVariable(value = "storeId") String storeId, @PathVariable(value = "dimension") int dimension, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, StoreNotFoundException, QRCodeGenerationException {

        return storeService.getStoreQRCode(getEmailOfLoggedinUser(response), storeId, dimension);

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

    @RequestMapping(value = "/b/coupon/{couponId}/activate", method = RequestMethod.POST)
    public
    @ResponseBody
    String couponActivate(@PathVariable(value = "couponId") String couponId, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CouponNotFoundException {

        couponService.activateCoupon(getEmailOfLoggedinUser(response), couponId);
        return "success";

    }

    @RequestMapping(value = "/b/coupon/{couponId}/deactivate", method = RequestMethod.POST)
    public
    @ResponseBody
    String couponDeactivate(@PathVariable(value = "couponId") String couponId, HttpServletRequest
            request, HttpServletResponse response) throws UserNotLoggedInException, EmailNotFoundException, CouponNotFoundException {

        couponService.deactivateCoupon(getEmailOfLoggedinUser(response), couponId);
        return "success";

    }

    @RequestMapping(value = "/b/coupon/{couponId}/delete", method = RequestMethod.POST)
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

        String email = getEmailOfLoggedinUser(response);

        Context ctx = new Context(Locale.ENGLISH);
        ctx.setVariable("feedback", data.getFeedback());
        ctx.setVariable("location", data.getLocation());
        ctx.setVariable("userAgent", data.getUserAgent());
        ctx.setVariable("email", email);
        String htmlMail = templateEngine.process("feedbackEmail.html", ctx);

        StringBuilder plainMailBuilder = new StringBuilder();
        plainMailBuilder.append("You got following feedback from " + email + "with user agent " + data.getUserAgent() + "for the location " + data.getLocation() + ":\n\n");
        plainMailBuilder.append(data.getFeedback());

        mailService.sendEmail("mail@sebastianhof.com", "Feedback from " + email, plainMailBuilder.toString(), htmlMail);

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

    private void sendConfirmLetter(BusinessOwnerEntity entity, HttpServletRequest request, HttpServletResponse response) throws SendMessageException {
        mailService.sendEmail(entity.getEmail(), "coubr: Confirm your registration", createPlainConfirmLetter(entity, request), createHTMLConfirmLetter(entity, request, response));
    }

    private void sendPasswordResetLetter(BusinessOwnerEntity entity, HttpServletRequest request, HttpServletResponse response) throws SendMessageException {
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
