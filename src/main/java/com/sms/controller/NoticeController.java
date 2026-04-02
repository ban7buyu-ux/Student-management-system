package com.sms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;

@Controller
public class NoticeController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/PostNoticeServlet")
    public String postNotice(@RequestParam String title, @RequestParam String message, HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (!"admin".equalsIgnoreCase(role)) return "redirect:/admin_login";

        jdbcTemplate.update("INSERT INTO announcements (title, message) VALUES (?, ?)", title, message);
        
        session.setAttribute("successMessage", "New announcement posted!");
        return "redirect:/admin_dashboard";
    }
}
