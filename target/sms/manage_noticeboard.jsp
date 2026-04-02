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
    <title>Manage Notice Board - Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="role-admin">
    <header>
        Digital Notice Board
        <a href="admin_dashboard.jsp" class="logout-header-btn">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </header>

    <div class="container" style="max-width: 900px;">
        <%
            String successMsg = (String) session.getAttribute("successMessage");
            if (successMsg != null) {
        %>
            <div class="toast" style="background-color: #4a744c; margin-bottom: 20px;">
                <div class="toast-icon">✓</div>
                <div class="toast-body">
                    <h4>Notice Posted</h4>
                    <p style="color: white; font-weight: bold; font-size:14px; margin-top:5px;"><%= successMsg %></p>
                </div>
                <div style="margin-left: auto; cursor: pointer;" onclick="this.parentElement.style.display='none'">✕</div>
            </div>
        <%
                session.removeAttribute("successMessage");
            }
        %>

        <div class="content-card" style="margin-bottom: 30px;">
            <h2 style="color: var(--primary-red); margin-top: 0; border-bottom: 2px solid var(--text-blue); padding-bottom: 10px;">Post New Announcement</h2>
            <form action="PostNoticeServlet" method="post">
                <div style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: bold;">Notice Title</label>
                    <input type="text" name="title" placeholder="e.g. Exam Schedule Update" required style="width: 100%; border: 1px solid #ccc;">
                </div>
                <div style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: bold;">Message Content</label>
                    <textarea name="message" placeholder="Type the full announcement here..." required style="width: 100%; height: 100px; border: 1px solid #ccc;"></textarea>
                </div>
                <button type="submit">POST TO BOARD</button>
            </form>
        </div>

        <div class="content-card">
            <h3 style="color: var(--text-blue); margin-top: 0;">Active Notices</h3>
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Title</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        String sql = "SELECT * FROM announcements ORDER BY post_date DESC";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);
                        while (rs.next()) {
                %>
                    <tr>
                        <td style="font-size: 12px; color: #666;"><%= rs.getTimestamp("post_date") %></td>
                        <td style="font-weight: bold;"><%= rs.getString("title") %></td>
                        <td>
                            <form action="PostNoticeServlet" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                                <button type="submit" style="padding: 5px 10px; background: #e74c3c; width: auto; font-size: 12px;">Delete</button>
                            </form>
                        </td>
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
