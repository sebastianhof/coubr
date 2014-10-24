package com.coubr.main.controller;

import com.coubr.app.exceptions.AppCouponNotFoundException;
import com.coubr.app.exceptions.AppStoreCodeNotFoundException;
import com.coubr.app.exceptions.AppStoreNotFoundException;
import com.coubr.business.exceptions.*;
import com.coubr.main.exceptions.UserNotLoggedInException;
import com.google.common.collect.ImmutableMap;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import javax.servlet.http.HttpServletResponse;

/**
 * Created by sebastian on 10.10.14.
 */
@ControllerAdvice
public class ExceptionController {

    /*
     * Bad request
     */

    @ExceptionHandler(UserNotLoggedInException.class)
    ModelAndView userNotLoggedInException(HttpServletResponse response) {

        return badRequestError("40000", response);

    }

    @ExceptionHandler(EmailNotFoundException.class)
    ModelAndView emailNotFoundException(HttpServletResponse response) {

        return badRequestError("40001", response);

    }

    @ExceptionHandler(PasswordNotFoundException.class)
    ModelAndView passwordNotFoundException(HttpServletResponse response) {

        return badRequestError("40002", response);

    }

    @ExceptionHandler(CodeNotFoundException.class)
    ModelAndView codeNotFoundException(HttpServletResponse response) {

        return badRequestError("40003", response);

    }

    @ExceptionHandler(NotConfirmedException.class)
    ModelAndView notConfirmedException(HttpServletResponse response) {

        return badRequestError("40004", response);

    }

    @ExceptionHandler(ConfirmedException.class)
    ModelAndView confirmedException(HttpServletResponse response) {

        return badRequestError("40005", response);

    }

    @ExceptionHandler(ExpirationException.class)
    ModelAndView expirationException(HttpServletResponse response) {

        return badRequestError("40006", response);

    }

    @ExceptionHandler({StoreNotFoundException.class})
    ModelAndView storeNotFoundException(HttpServletResponse response) {

        return badRequestError("40007", response);

    }

    @ExceptionHandler(PostalCodeNotFoundException.class)
    ModelAndView postalCodeNotFoundException(HttpServletResponse response) {

        return badRequestError("40008", response);

    }

    @ExceptionHandler({TypeNotFoundException.class, CategoryNotFoundException.class, SubcategoryNotFoundException.class})
    ModelAndView typeNotFoundException(HttpServletResponse response) {

        return badRequestError("40009", response);

    }

    @ExceptionHandler({CouponNotFoundException.class})
    ModelAndView couponNotFoundException(HttpServletResponse response) {

        return badRequestError("40010", response);

    }

    @ExceptionHandler(InvalidAmountException.class)
    ModelAndView invalidAmountException(HttpServletResponse response) {

        return badRequestError("40011", response);

    }

    @ExceptionHandler(AppStoreNotFoundException.class)
    ModelAndView appStoreNotFoundException(HttpServletResponse response) {

        return badRequestError("10001", response);

    }

    @ExceptionHandler(AppCouponNotFoundException.class)
    ModelAndView appCouponNotFoundException(HttpServletResponse response) {

        return badRequestError("10002", response);

    }

    @ExceptionHandler(AppStoreCodeNotFoundException.class)
    ModelAndView appStoreCodeNotFoundException(HttpServletResponse response) {

        return badRequestError("10003", response);

    }

    /*
     * Conflict
     */

    @ExceptionHandler(EmailFoundException.class)
    ModelAndView emailFoundException(HttpServletResponse response) {

        return conflictError("40901", response);

    }

    /*
     * Internal server error
     */

    @ExceptionHandler(SendMessageException.class)
    ModelAndView sendMessageException(HttpServletResponse response) {

        return internalServerError("50001", response);

    }

    @ExceptionHandler(QRCodeGenerationException.class)
    ModelAndView qrCodeGenerationException(HttpServletResponse response) {

        return internalServerError("50002", response);

    }

    /*
     * Private
     */

    private ModelAndView badRequestError(String code, HttpServletResponse response) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        return new ModelAndView(new MappingJackson2JsonView(), ImmutableMap.of("code", code));
    }

    private ModelAndView conflictError(String code, HttpServletResponse response) {
        response.setStatus(HttpServletResponse.SC_CONFLICT);
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        return new ModelAndView(new MappingJackson2JsonView(), ImmutableMap.of("code", code));
    }

    private ModelAndView internalServerError(String code, HttpServletResponse response) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        return new ModelAndView(new MappingJackson2JsonView(), ImmutableMap.of("code", code));
    }


}
