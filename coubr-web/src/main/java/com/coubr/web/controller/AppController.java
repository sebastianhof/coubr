package com.coubr.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Created by sebastian on 28.09.14.
 */
@Controller
public class AppController {

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String index() {
        return "redirect:/app";
    }

    @RequestMapping(value = "/app", method = RequestMethod.GET)
    public String app() {
        return "app";
    }

}
