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
    <title>Profile - Student Management System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>My Profile</header>

    <div class="container">
        <div class="card" style="max-width: 600px;">
            <h2>Profile Details</h2>
            <%
                boolean hasData = false;
                Connection conn = null;
                PreparedStatement pst = null;
                ResultSet rs = null;
                try {
                    conn = DBConnection.getConnection();
                    if (conn != null) {
                        String sql = "SELECT * FROM profile WHERE email = ?";
                        pst = conn.prepareStatement(sql);
                        pst.setString(1, email);
                        rs = pst.executeQuery();
                                if (rs.next()) {
                                    hasData = true;
            %>
                                    <table style="text-align: left;">
                                        <tr><th>Name:</th><td><%= rs.getString("name") %></td></tr>
                                        <tr><th>Email:</th><td><%= rs.getString("email") %></td></tr>
                                        <tr><th>Department:</th><td><%= rs.getString("dept") %></td></tr>
                                        <tr><th>Year:</th><td><%= rs.getString("year") %></td></tr>
                                        <tr><th>Phone:</th><td><%= rs.getString("phone") %></td></tr>
                                    </table>
            <%
                                }
                            }
                        }
                    }
                } catch (Exception e) {
                    out.println("<div class='error'>Error fetching profile: " + e.getMessage() + "</div>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                    if (pst != null) try { pst.close(); } catch (SQLException ignore) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                }

                if (!hasData) {
            %>
                    <p style="color: #e74c3c; font-weight: bold;">No data found for this user.</p>
            <%
                }
            %>

            <div class="nav-links">
                <a href="dashboard.jsp">Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>
