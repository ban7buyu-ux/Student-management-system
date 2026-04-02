package com.sms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
public class AdminController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private boolean isAdmin(HttpSession session) {
        String role = (String) session.getAttribute("role");
        return "admin".equalsIgnoreCase(role);
    }

    @GetMapping("/admin_dashboard")
    public String adminDashboard(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/admin_login";
        
        // Fetch some basic stats for the admin dashboard
        int studentCount = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM profile", Integer.class);
        int courseCount = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM courses", Integer.class);
        int feedbackCount = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM feedback", Integer.class);
        
        model.addAttribute("studentCount", studentCount);
        model.addAttribute("courseCount", courseCount);
        model.addAttribute("feedbackCount", feedbackCount);
        
        return "admin_dashboard";
    }

    @GetMapping("/add_student")
    public String addStudent(HttpSession session) {
        if (!isAdmin(session)) return "redirect:/admin_login";
        return "add_student";
    }

    @GetMapping("/manage_courses")
    public String manageCourses(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/admin_login";
        List<Map<String, Object>> courses = jdbcTemplate.queryForList("SELECT * FROM courses");
        model.addAttribute("courses", courses);
        return "manage_courses";
    }

    @GetMapping("/view_students")
    public String viewStudents(@RequestParam(value="query", required=false) String query, HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/admin_login";
        
        List<Map<String, Object>> students;
        if (query != null && !query.trim().isEmpty()) {
            students = jdbcTemplate.queryForList(
                "SELECT * FROM profile WHERE name LIKE ? OR email LIKE ?", 
                "%" + query + "%", "%" + query + "%");
            model.addAttribute("searchQuery", query);
        } else {
            students = jdbcTemplate.queryForList("SELECT * FROM profile");
        }
        
        model.addAttribute("students", students);
        return "view_students";
    }

    @GetMapping("/enter_marks")
    public String enterMarks(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/admin_login";
        List<Map<String, Object>> students = jdbcTemplate.queryForList("SELECT * FROM profile");
        model.addAttribute("students", students);
        return "enter_marks";
    }

    @GetMapping("/view_feedback")
    public String viewFeedback(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/admin_login";
        List<Map<String, Object>> feedbackList = jdbcTemplate.queryForList("SELECT * FROM feedback");
        model.addAttribute("feedbackList", feedbackList);
        return "view_feedback";
    }

    @GetMapping("/manage_noticeboard")
    public String manageNoticeboard(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/admin_login";
        List<Map<String, Object>> notices = jdbcTemplate.queryForList("SELECT * FROM announcements ORDER BY id DESC");
        model.addAttribute("notices", notices);
        return "manage_noticeboard";
    }
}
