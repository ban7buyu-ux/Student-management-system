package com.sms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
public class HostelController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/HostelBookingServlet")
    @ResponseBody
    @Transactional
    public String bookHostel(@RequestParam int roomId, HttpSession session) {
        String email = (String) session.getAttribute("email");
        if (email == null) {
            return "Please login first.";
        }

        try {
            // 1. Fetch room details
            String fetchSql = "SELECT * FROM hostel_rooms WHERE id = ?";
            List<Map<String, Object>> rooms = jdbcTemplate.queryForList(fetchSql, roomId);

            if (!rooms.isEmpty()) {
                Map<String, Object> room = rooms.get(0);
                String blockName = (String) room.get("block_name");
                String roomNumber = (String) room.get("room_number");

                // 2. Insert or update allotment
                String sql = "INSERT INTO hostel (email, block_name, room_number, status) VALUES (?, ?, ?, 'Allotted') " +
                             "ON DUPLICATE KEY UPDATE block_name = VALUES(block_name), room_number = VALUES(room_number), status = 'Allotted'";
                
                jdbcTemplate.update(sql, email, blockName, roomNumber);
                return "Hostel room booked successfully!";
            } else {
                return "Room not found.";
            }
        } catch (Exception e) {
            return "Booking failed: " + e.getMessage();
        }
    }
}
