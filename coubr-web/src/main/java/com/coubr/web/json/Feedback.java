package com.coubr.web.json;

import javax.validation.constraints.NotNull;

/**
 * Created by sebastian on 10.10.14.
 */
public class Feedback {

    @NotNull
    private String feedback;

    private String location;

    private String userAgent;

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }
}
