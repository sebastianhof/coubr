package com.coubr.web.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

/**
 * Created by sebastian on 02.10.14.
 */
@Service("mailService")
public class MailService {

    private static final String SENDER_ADDRESS = "daemon@sebastianhof.com";


    @Autowired
    JavaMailSender mailSender;

    public void sendEmail(final String receiverAddress, final String subject, final String plainBody, final String htmlBody) throws MessagingException {

        final MimeMessage mimeMessage = mailSender.createMimeMessage();
        final MimeMessageHelper message = new MimeMessageHelper(mimeMessage, true);

        message.setFrom(SENDER_ADDRESS);
        message.setTo(receiverAddress);
        message.setSubject(subject);
        message.setText(plainBody, htmlBody);
        mailSender.send(mimeMessage);
    }

}
