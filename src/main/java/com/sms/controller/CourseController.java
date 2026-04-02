package com.sms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;

@Controller
public class CourseController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/AddCourseServlet")
    public String addCourse(@RequestParam("course_code") String code,
                            @RequestParam("course_name") String name,
                            @RequestParam int credits,
                            HttpSession session) {
        
        String role = (String) session.getAttribute("role");
        if (role == null || !"admin".equalsIgnoreCase(role)) return "redirect:/admin_login";

        try {
            String sql = "INSERT INTO courses (course_code, course_name, credits) VALUES (?, ?, ?)";
            jdbcTemplate.update(sql, code, name, credits);
            session.setAttribute("successMessage", "Course added successfully!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Failed to add course: " + e.getMessage());
        }
        return "redirect:/manage_courses";
    }

    @PostMapping("/CourseRegistrationServlet")
    @Transactional
    public String registerCourses(@RequestParam(value="courseIds", required=false) String[] courseIds, HttpSession session) {
        String email = (String) session.getAttribute("email");
        if (email == null) return "redirect:/";

        if (courseIds == null || courseIds.length == 0) {
            session.setAttribute("errorMessage", "No courses selected.");
            return "redirect:/course_registration";
        }

        try {
            String checkSql = "SELECT COUNT(*) FROM registrations WHERE email = ? AND course_id = ?";
            String insertSql = "INSERT INTO registrations (email, course_id) VALUES (?, ?)";
            
            int countSkipped = 0;
            int countAdded = 0;

            for (String id : courseIds) {
                int courseId = Integer.parseInt(id);
                Integer existing = jdbcTemplate.queryForObject(checkSql, Integer.class, email, courseId);
                
                if (existing != null && existing > 0) {
                    countSkipped++;
                } else {
                    jdbcTemplate.update(insertSql, email, courseId);
                    countAdded++;
                }
            }
            
            if (countAdded > 0) {
                session.setAttribute("successMessage", "Successfully registered for " + countAdded + " courses!");
                if (countSkipped > 0) {
                    session.setAttribute("errorMessage", countSkipped + " courses were already registered and skipped.");
                }
            } else if (countSkipped > 0) {
                session.setAttribute("errorMessage", "All selected courses were already registered.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Registration failed: " + e.getMessage());
        }
        return "redirect:/course_registration";
    }

    @PostMapping("/RemoveRegistrationServlet")
    @Transactional
    public String removeRegistration(@RequestParam int courseId, HttpSession session) {
        String email = (String) session.getAttribute("email");
        if (email == null) return "redirect:/";

        try {
            String sql = "DELETE FROM registrations WHERE email = ? AND course_id = ?";
            jdbcTemplate.update(sql, email, courseId);
            session.setAttribute("successMessage", "Course removed successfully!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Failed to remove course: " + e.getMessage());
        }
        return "redirect:/course_registration";
    }
}
