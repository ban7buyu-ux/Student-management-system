<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.sms.util.DBConnection" %>
<%
    String email = (String) session.getAttribute("email");
    if (email == null) {
        response.sendRedirect("studentmanagementsystem.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hostel - Student Management System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        Hostel Allotment Details
        <a href="dashboard.jsp" class="logout-header-btn">
            <i class="fa-solid fa-arrow-left"></i> Back
        </a>
    </header>

    <div class="container" style="max-width: 800px;">
        <div class="content-card">
            <h2 style="color: var(--primary-red); margin-top: 0; border-bottom: 2px solid var(--text-blue); padding-bottom: 10px;">Your Current Assignment</h2>
            <%
                boolean hasData = false;
                try (Connection conn = DBConnection.getConnection()) {
                    if (conn != null) {
                        String sql = "SELECT * FROM hostel WHERE email = ?";
                        try (PreparedStatement pst = conn.prepareStatement(sql)) {
                            pst.setString(1, email);
                            try (ResultSet rs = pst.executeQuery()) {
                                if (rs.next()) {
                                    hasData = true;
            %>
                                    <div style="margin-top: 20px;">
                                        <div style="margin-bottom: 15px; font-size: 18px;">
                                            <strong style="color: var(--text-blue);">Block:</strong> <%= rs.getString("block_name") %>
                                        </div>
                                        <div style="margin-bottom: 15px; font-size: 18px;">
                                            <strong style="color: var(--text-blue);">Room Number:</strong> <%= rs.getString("room_number") %>
                                        </div>
                                        <div style="margin-bottom: 15px; font-size: 18px;">
                                            <strong style="color: var(--text-blue);">Status:</strong> 
                                            <span style="color: #27ae60; font-weight: bold;"><%= rs.getString("status") %></span>
                                        </div>
                                    </div>
            <%
                                }
                            }
                        }
                    }
                } catch (Exception e) {
                    out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
                }

                if (!hasData) {
            %>
                    <p style="color: #e74c3c; font-weight: bold; margin-top: 20px;">
                        <i class="fa-solid fa-circle-exclamation"></i> No hostel allotment found yet.
                    </p>
                    <a href="hostel_booking.jsp" style="display: inline-block; margin-top: 15px; text-decoration: none; color: white; background: var(--text-blue); padding: 10px 20px; border-radius: 5px;">
                        Book a Room Now
                    </a>
            <%
                }
            %>
        </div>
    </div>
</body>
</html>
