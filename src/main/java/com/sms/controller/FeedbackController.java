package com.sms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;

@Controller
public class FeedbackController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/FeedbackServlet")
    public String submitFeedback(@RequestParam String message, HttpSession session) {
        String email = (String) session.getAttribute("email");
        if (email == null) return "redirect:/";

        jdbcTemplate.update("INSERT INTO feedback (email, message) VALUES (?, ?)", email, message);
        
        session.setAttribute("successMessage", "Feedback submitted! Thank you.");
        return "redirect:/dashboard";
    }
}
