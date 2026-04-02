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
    <title>Enter Marks - Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="role-admin">
    <header>
        Academic Records
        <a href="admin_dashboard.jsp" class="logout-header-btn">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </header>

    <div class="container" style="max-width: 800px;">
        <%
            String successMsg = (String) session.getAttribute("successMessage");
            if (successMsg != null) {
        %>
            <div class="toast" style="background-color: #4a744c; margin-bottom: 20px;">
                <div class="toast-icon">✓</div>
                <div class="toast-body">
                    <h4>Record Updated</h4>
                    <p style="color: white; font-weight: bold; font-size:14px; margin-top:5px;"><%= successMsg %></p>
                </div>
                <div style="margin-left: auto; cursor: pointer;" onclick="this.parentElement.style.display='none'">✕</div>
            </div>
        <%
                session.removeAttribute("successMessage");
            }
        %>

        <div class="content-card">
            <h2 style="color: var(--primary-red); margin-top: 0; border-bottom: 2px solid var(--text-blue); padding-bottom: 10px;">Enter Student Marks</h2>
            <p style="font-size: 14px; color: #666; margin-bottom: 20px;">Select a student and course to record academic performance.</p>

            <form action="EnterMarksServlet" method="post">
                <div style="margin-bottom: 20px;">
                    <label style="display: block; margin-bottom: 8px; font-weight: bold; color: #333;">Select Student</label>
                    <select name="studentEmail" required style="width: 100%; border: 1px solid #ccc;">
                        <option value="">-- Choose Student --</option>
                        <%
                            try (Connection conn = DBConnection.getConnection()) {
                                String sql = "SELECT email, name FROM profile ORDER BY name ASC";
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery(sql);
                                while (rs.next()) {
                                    out.println("<option value='" + rs.getString("email") + "'>" + rs.getString("name") + " (" + rs.getString("email") + ")</option>");
                                }
                            } catch (Exception e) {
                                out.println("<option>Error loading students</option>");
                            }
                        %>
                    </select>
                </div>

                <div style="margin-bottom: 20px;">
                    <label style="display: block; margin-bottom: 8px; font-weight: bold; color: #333;">Select Course</label>
                    <select name="subjectName" required style="width: 100%; border: 1px solid #ccc;">
                        <option value="">-- Choose Course --</option>
                        <%
                            try (Connection conn = DBConnection.getConnection()) {
                                String sql = "SELECT course_name FROM courses ORDER BY course_name ASC";
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery(sql);
                                while (rs.next()) {
                                    out.println("<option value='" + rs.getString("course_name") + "'>" + rs.getString("course_name") + "</option>");
                                }
                            } catch (Exception e) {
                                out.println("<option>Error loading courses</option>");
                            }
                        %>
                    </select>
                </div>

                <div style="margin-bottom: 20px;">
                    <label style="display: block; margin-bottom: 8px; font-weight: bold; color: #333;">Marks Obtained (0-100)</label>
                    <input type="number" name="marks" min="0" max="100" placeholder="Enter numerical marks" required style="width: 100%; border: 1px solid #ccc;">
                </div>

                <button type="submit" style="margin-top: 10px;">UPDATE RECORDS</button>
            </form>
        </div>
    </div>

    <script>
    // Auto-close success toast after 5 seconds
    window.onload = function() {
        const toast = document.querySelector('.toast');
        if (toast) {
            setTimeout(() => {
                toast.style.transition = "opacity 0.5s ease";
                toast.style.opacity = "0";
                setTimeout(() => {
                    toast.style.display = "none";
                }, 500);
            }, 5000);
        }
    };
    </script>
</body>
</html>
