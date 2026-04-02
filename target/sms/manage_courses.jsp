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
    <title>Manage Courses - Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="role-admin">
    <header>
        Course Management
        <a href="admin_dashboard.jsp" class="logout-header-btn">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </header>

    <div class="container" style="max-width: 900px;">
        <!-- Add New Course Form -->
        <div class="content-card" style="margin-bottom: 30px;">
            <h3 style="color: var(--text-blue); margin-top: 0;">Add New Course</h3>
            <form action="AddCourseServlet" method="post" style="display: flex; gap: 10px; flex-wrap: wrap;">
                <input type="text" name="code" placeholder="Code (e.g. CS101)" required style="flex: 1; min-width: 120px;">
                <input type="text" name="name" placeholder="Course Name" required style="flex: 2; min-width: 200px;">
                <input type="number" name="credits" placeholder="Credits" required style="flex: 0.5; min-width: 80px;">
                <button type="submit" style="flex: 1; margin: 10px 0; min-width: 150px;">Add Course</button>
            </form>
        </div>

        <div class="content-card">
            <h3 style="color: var(--primary-red); margin-top: 0;">Existing Curriculum</h3>
            <table>
                <thead>
                    <tr>
                        <th>Code</th>
                        <th>Course Name</th>
                        <th>Credits</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        String sql = "SELECT * FROM courses ORDER BY course_code ASC";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);
                        while (rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getString("course_code") %></td>
                        <td><%= rs.getString("course_name") %></td>
                        <td><%= rs.getInt("credits") %></td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='3'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
