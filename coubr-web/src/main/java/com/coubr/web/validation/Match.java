package com.coubr.web.validation;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

/**
 * Created by sebastian on 02.10.14.
 */
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = MatchValidator.class)
@Documented
public @interface Match
{
    String message() default "{com.coubr.web.validation.match}";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    String a();

    String b();

}