package com.coubr.web.controller;

import com.coubr.web.exceptions.*;
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

    @ExceptionHandler(StoreNotFoundException.class)
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

    @ExceptionHandler(CouponNotFoundException.class)
    ModelAndView couponNotFoundException(HttpServletResponse response) {

        return badRequestError("40010", response);

    }

    @ExceptionHandler(InvalidAmountException.class)
    ModelAndView invalidAmountException(HttpServletResponse response) {

        return badRequestError("40011", response);

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

    /*
     * Private
     */

    private ModelAndView badRequestError(String code, HttpServletResponse response) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        return new ModelAndView(new MappingJackson2JsonView(), ImmutableMap.of(code, true));
    }

    private ModelAndView conflictError(String code, HttpServletResponse response) {
        response.setStatus(HttpServletResponse.SC_CONFLICT);
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        return new ModelAndView(new MappingJackson2JsonView(), ImmutableMap.of(code, true));
    }

    private ModelAndView internalServerError(String code, HttpServletResponse response) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        return new ModelAndView(new MappingJackson2JsonView(), ImmutableMap.of(code, true));
    }



}
