package com.sms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;



@Controller
public class PageController {

    @GetMapping("/")
    public String index() {
        return "index"; // index.html (Student Login)
    }

    @GetMapping("/admin_login")
    public String adminLogin() {
        return "admin_login"; // admin_login.html
    }


}
