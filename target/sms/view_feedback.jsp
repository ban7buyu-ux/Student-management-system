<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.sms.util.DBConnection" %>
<%
    String email = (String) session.getAttribute("email");
    String role = (String) session.getAttribute("role");
    if (email == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("studentmanagementsystem.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Feedback - Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="role-admin">
    <header>
        Student Feedback
        <a href="admin_dashboard.jsp" class="logout-header-btn">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </header>

    <div class="container" style="max-width: 900px;">
        <div class="content-card">
            <h2 style="color: var(--primary-red); margin-top: 0; border-bottom: 2px solid var(--text-blue); padding-bottom: 10px;">Messages from Students</h2>
            
            <table id="feedbackTable">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Student Email</th>
                        <th>Message</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        String sql = "SELECT * FROM feedback ORDER BY submission_date DESC";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);
                        while (rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getTimestamp("submission_date") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td><%= rs.getString("message") %></td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='3'>Error loading feedback: " + e.getMessage() + "</td></tr>");
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
