package com.sms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class StudentController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/AddStudentServlet")
    @ResponseBody
    @Transactional
    public String addStudent(@RequestParam String email,
                             @RequestParam String name,
                             @RequestParam String dept,
                             @RequestParam String year,
                             @RequestParam String phone,
                             @RequestParam(required = false) String subject,
                             @RequestParam(defaultValue = "0") int percentage,
                             @RequestParam(defaultValue = "0") int marks) {
        
        try {
            // 1. Insert Profile
            String sqlProfile = "INSERT INTO profile (email, name, dept, year, phone) VALUES (?, ?, ?, ?, ?)";
            jdbcTemplate.update(sqlProfile, email, name, dept, year, phone);

            // 2. Insert Attendance & Results
            if (subject != null && !subject.isEmpty()) {
                String sqlAtt = "INSERT INTO attendance (email, subject, percentage) VALUES (?, ?, ?)";
                jdbcTemplate.update(sqlAtt, email, subject, percentage);

                String sqlRes = "INSERT INTO results (email, subject, marks) VALUES (?, ?, ?)";
                jdbcTemplate.update(sqlRes, email, subject, marks);
            }

            return "Student added successfully across Profile, Attendance, and Results tables!";
        } catch (Exception e) {
            return "Failed to insert student: " + e.getMessage();
        }
    }
}
