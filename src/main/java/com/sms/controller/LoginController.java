package com.sms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
public class LoginController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/LoginServlet")
    public String login(@RequestParam String email, 
                        @RequestParam String password, 
                        @RequestParam(required = false) String securityKey,
                        HttpSession session, 
                        Model model) {
        
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        List<Map<String, Object>> users = jdbcTemplate.queryForList(sql, email, password);

        if (!users.isEmpty()) {
            Map<String, Object> user = users.get(0);
            String role = (String) user.get("role");

            session.setAttribute("email", email);
            session.setAttribute("user", email);
            session.setAttribute("role", role);

            if ("admin".equalsIgnoreCase(role)) {
                if (securityKey == null || !"SMS-ADMIN-2026".equals(securityKey)) {
                    model.addAttribute("errorMessage", "Invalid System Security Key for Administrative Access.");
                    return "admin_login"; // Thymeleaf will look for admin_login.html
                }
                session.setAttribute("successMessage", "Admin Login Successful! Welcome System Administrator.");
                return "redirect:/admin_dashboard";
            } else {
                session.setAttribute("successMessage", "Login Successful! Welcome to your student portal.");
                return "redirect:/dashboard";
            }
        } else {
            model.addAttribute("errorMessage", "Invalid username or password.");
            return "index"; // Assuming studentmanagementsystem.jsp becomes index.html
        }
    }
}
