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
public class StudentPageController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        String email = (String) session.getAttribute("email");
        if (email == null) return "redirect:/";

        Map<String, Object> profile = jdbcTemplate.queryForMap("SELECT * FROM profile WHERE email = ?", email);
        model.addAttribute("profile", profile);
        return "profile";
    }

    @GetMapping("/attendance")
    public String attendance(HttpSession session, Model model) {
        String email = (String) session.getAttribute("email");
        if (email == null) return "redirect:/";

        List<Map<String, Object>> attendance = jdbcTemplate.queryForList("SELECT * FROM attendance WHERE email = ?", email);
        model.addAttribute("attendance", attendance);
        return "attendance";
    }

    @GetMapping("/results")
    public String results(HttpSession session, Model model) {
        String email = (String) session.getAttribute("email");
        if (email == null) return "redirect:/";

        List<Map<String, Object>> results = jdbcTemplate.queryForList("SELECT * FROM results WHERE email = ?", email);
        model.addAttribute("results", results);
        return "results";
    }

    @GetMapping("/feedback")
    public String feedback(HttpSession session) {
        if (session.getAttribute("email") == null) return "redirect:/";
        return "feedback";
    }

    @GetMapping("/course_registration")
    public String courseRegistration(HttpSession session, Model model) {
        String email = (String) session.getAttribute("email");
        if (email == null) return "redirect:/";

        List<Map<String, Object>> courses = jdbcTemplate.queryForList("SELECT * FROM courses");
        model.addAttribute("courses", courses);

        // Fetch already registered courses
        List<Map<String, Object>> registeredCourses = jdbcTemplate.queryForList(
            "SELECT c.* FROM courses c JOIN registrations r ON c.id = r.course_id WHERE r.email = ?", email);
        model.addAttribute("registeredCourses", registeredCourses);

        return "course_registration";
    }

    @GetMapping("/hostel_booking")
    public String hostelBooking(HttpSession session, Model model) {
        if (session.getAttribute("email") == null) return "redirect:/";

        List<Map<String, Object>> rooms = jdbcTemplate.queryForList("SELECT * FROM hostel_rooms");
        model.addAttribute("rooms", rooms);
        return "hostel_booking";
    }

    @GetMapping("/hostel")
    public String hostelInfo(HttpSession session, Model model) {
        String email = (String) session.getAttribute("email");
        if (email == null) return "redirect:/";

        List<Map<String, Object>> allotment = jdbcTemplate.queryForList("SELECT * FROM hostel WHERE email = ?", email);
        if (!allotment.isEmpty()) {
            model.addAttribute("hostel", allotment.get(0));
        }
        return "hostel";
    }
}
