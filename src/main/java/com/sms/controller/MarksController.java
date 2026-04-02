package com.sms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;

@Controller
public class MarksController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/EnterMarksServlet")
    public String enterMarks(@RequestParam String studentEmail,
                           @RequestParam String subjectName,
                           @RequestParam int marks,
                           HttpSession session) {
        
        String role = (String) session.getAttribute("role");
        if (!"admin".equalsIgnoreCase(role)) return "redirect:/admin_login";

        // Calculate Grade
        String grade;
        if (marks >= 90) grade = "A+";
        else if (marks >= 80) grade = "A";
        else if (marks >= 70) grade = "B";
        else if (marks >= 60) grade = "C";
        else if (marks >= 50) grade = "D";
        else grade = "F";

        // Check if marks already exist for this student/subject
        Integer count = jdbcTemplate.queryForObject(
            "SELECT COUNT(*) FROM results WHERE email = ? AND subject_name = ?", 
            Integer.class, studentEmail, subjectName);

        if (count != null && count > 0) {
            jdbcTemplate.update("UPDATE results SET marks = ?, grade = ? WHERE email = ? AND subject_name = ?",
                marks, grade, studentEmail, subjectName);
        } else {
            jdbcTemplate.update("INSERT INTO results (email, subject_name, marks, grade) VALUES (?, ?, ?, ?)",
                studentEmail, subjectName, marks, grade);
        }

        session.setAttribute("successMessage", "Marks updated for " + studentEmail);
        return "redirect:/admin_dashboard";
    }
}
