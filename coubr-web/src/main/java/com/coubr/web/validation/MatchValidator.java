package com.coubr.web.validation;

import org.apache.commons.beanutils.BeanUtils;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.lang.reflect.InvocationTargetException;

/**
 * Created by sebastian on 02.10.14.
 */
public class MatchValidator implements ConstraintValidator<Match, Object> {

    private String a;
    private String b;

    @Override
    public void initialize(Match constraintAnnotation) {
        a = constraintAnnotation.a();
        b = constraintAnnotation.b();
    }

    @Override
    public boolean isValid(final Object value, final ConstraintValidatorContext context) {

        try {
            final Object aObject = BeanUtils.getProperty(value, a);
            final Object bObject = BeanUtils.getProperty(value, b);

            if (aObject == null && bObject == null) {
                return true;
            } else if (aObject != null) {
                return aObject.equals(bObject);
            } else {
                return false;
            }

        } catch (IllegalAccessException e) {

            e.printStackTrace();

        } catch (InvocationTargetException e) {

            e.printStackTrace();

        } catch (NoSuchMethodException e) {

            e.printStackTrace();

        }

        return true;
    }
}
