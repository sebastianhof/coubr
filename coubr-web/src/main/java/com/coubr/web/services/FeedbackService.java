package com.coubr.web.services;

import com.coubr.web.exceptions.SendMessageException;
import com.coubr.web.json.Feedback;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import java.util.Locale;

/**
 * Created by sebastian on 10.10.14.
 */
@Service("feedbackService")
public class FeedbackService {

    @Autowired
    private MailService mailService;

    @Autowired
    private TemplateEngine templateEngine;


    public void sendFeedback(String email, Feedback data) throws SendMessageException {

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

    }
}
