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
    <title>Attendance - Student Management System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>My Attendance</header>

    <div class="container">
        <div class="card" style="max-width: 600px;">
            <h2>Attendance Record</h2>
            <%
                boolean hasData = false;
                try (Connection conn = DBConnection.getConnection()) {
                    if (conn != null) {
                        String sql = "SELECT subject, percentage FROM attendance WHERE email = ?";
                        try (PreparedStatement pst = conn.prepareStatement(sql)) {
                            pst.setString(1, email);
                            try (ResultSet rs = pst.executeQuery()) {
                                out.println("<table><tr><th>Subject</th><th>Percentage</th></tr>");
                                while (rs.next()) {
                                    hasData = true;
                                    out.println("<tr>");
                                    out.println("<td>" + rs.getString("subject") + "</td>");
                                    out.println("<td>" + rs.getInt("percentage") + "%</td>");
                                    out.println("</tr>");
                                }
                                out.println("</table>");
                            }
                        }
                    }
                } catch (Exception e) {
                    out.println("<div class='error'>Error fetching attendance: " + e.getMessage() + "</div>");
                }

                if (!hasData) {
                    out.println("<p style='color: #e74c3c; font-weight: bold; margin-top:20px;'>No attendance records found.</p>");
                }
            %>
            
            <div class="nav-links">
                <a href="dashboard.jsp">Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>
