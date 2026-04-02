package com.sms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
public class DashboardController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        String email = (String) session.getAttribute("email");
        if (email == null) {
            return "redirect:/";
        }

        // 1. Attendance Average
        Integer totalAttendance = jdbcTemplate.queryForObject(
                "SELECT AVG(percentage) FROM attendance WHERE email = ?", Integer.class, email);
        model.addAttribute("totalAttendance", totalAttendance != null ? totalAttendance : 0);

        // 2. GPA Calculation
        Double avgMarks = jdbcTemplate.queryForObject(
                "SELECT AVG(marks) FROM results WHERE email = ?", Double.class, email);
        double gpa = (avgMarks != null) ? (avgMarks / 100.0) * 4.0 : 0.0;
        model.addAttribute("gpa", String.format("%.2f", gpa));

        // 3. Credits Progress
        Integer creditsTotal = jdbcTemplate.queryForObject(
                "SELECT SUM(c.credits) FROM courses c JOIN registrations r ON c.id = r.course_id WHERE r.email = ?", 
                Integer.class, email);
        model.addAttribute("creditsTotal", creditsTotal != null ? creditsTotal : 0);

        // 4. Announcements
        List<Map<String, Object>> notices = jdbcTemplate.queryForList(
                "SELECT * FROM announcements ORDER BY post_date DESC LIMIT 5");
        model.addAttribute("notices", notices);

        return "dashboard";
    }

}
