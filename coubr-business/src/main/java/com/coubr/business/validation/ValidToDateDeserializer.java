package com.coubr.business.validation;


import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

/**
 * Created by sebastian on 08.10.14.
 */
public class ValidToDateDeserializer extends JsonDeserializer<Date> {

    private static final String DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.sssZ"; // "2014-10-30T23:00:00.000Z"

    @Override
    public Date deserialize(JsonParser jp, DeserializationContext ctxt) throws IOException, JsonProcessingException {

        SimpleDateFormat format = new SimpleDateFormat(DATE_FORMAT);
        String dateString = jp.getText();

        try {
            Date date = format.parse(dateString);
            Calendar calendar = new GregorianCalendar();
            calendar.setTime(date);
            calendar.set(Calendar.HOUR_OF_DAY, 23);
            calendar.set(Calendar.MINUTE, 59);
            calendar.set(Calendar.SECOND, 59);
            calendar.set(Calendar.MILLISECOND, 59);

            return calendar.getTime();
        } catch (ParseException ex) {
            throw new IOException(ex);
        }

    }
}
