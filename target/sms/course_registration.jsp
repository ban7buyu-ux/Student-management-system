<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.sms.util.DBConnection" %>
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Registration - SMS</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <header>
        Course Registration
        <a href="dashboard.jsp" class="logout-header-btn">
            <i class="fa-solid fa-arrow-left"></i> Back
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
                    <h4>Success!</h4>
                    <p style="color: white; font-weight: bold; font-size:14px; margin-top:5px;"><%= successMsg %></p>
                </div>
                <div style="margin-left: auto; cursor: pointer;" onclick="this.parentElement.style.display='none'">✕</div>
            </div>
        <%
                session.removeAttribute("successMessage");
            }
        %>

        <div class="content-card">
            <h2 style="color: var(--primary-red); margin-top: 0; border-bottom: 2px solid var(--text-blue); padding-bottom: 10px;">Select Your Courses</h2>
            <p style="font-size: 14px; color: #666; margin-bottom: 20px;">Check the boxes for the courses you wish to register for this semester.</p>

            <form action="CourseRegistrationServlet" method="post">
                <table>
                    <thead>
                        <tr>
                            <th>Select</th>
                            <th>Code</th>
                            <th>Course Name</th>
                            <th>Credits</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        try (Connection conn = DBConnection.getConnection()) {
                            // Fetch all courses
                            String sql = "SELECT * FROM courses";
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery(sql);
                            
                            // Also fetch already registered course IDs for this student
                            String regSql = "SELECT course_id FROM registrations WHERE email = ?";
                            PreparedStatement regPst = conn.prepareStatement(regSql);
                            regPst.setString(1, email);
                            ResultSet regRs = regPst.executeQuery();
                            java.util.Set<Integer> registeredIds = new java.util.HashSet<>();
                            while (regRs.next()) {
                                registeredIds.add(regRs.getInt("course_id"));
                            }

                            while (rs.next()) {
                                int courseId = rs.getInt("id");
                                boolean isRegistered = registeredIds.contains(courseId);
                    %>
                        <tr>
                            <td>
                                <input type="checkbox" name="courseIds" value="<%= courseId %>" <%= isRegistered ? "checked disabled" : "" %>>
                            </td>
                            <td><%= rs.getString("course_code") %></td>
                            <td><%= rs.getString("course_name") %></td>
                            <td><%= rs.getInt("credits") %></td>
                        </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                    </tbody>
                </table>

                <button type="submit" style="margin-top: 25px;">Complete Registration</button>
            </form>
        </div>

        <!-- NEW: Registered Courses Section -->
        <div class="content-card" style="margin-top: 30px;">
            <h3 style="color: var(--text-blue); margin-top: 0; border-bottom: 2px solid var(--primary-red); padding-bottom: 8px;">Your Registered Curriculum</h3>
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
                        String sql = "SELECT c.* FROM courses c JOIN registrations r ON c.id = r.course_id WHERE r.email = ? ORDER BY c.course_code ASC";
                        PreparedStatement pst = conn.prepareStatement(sql);
                        pst.setString(1, email);
                        ResultSet rs = pst.executeQuery();
                        boolean hasReg = false;
                        while (rs.next()) {
                            hasReg = true;
                %>
                    <tr>
                        <td><%= rs.getString("course_code") %></td>
                        <td><%= rs.getString("course_name") %></td>
                        <td><%= rs.getInt("credits") %></td>
                    </tr>
                <%
                        }
                        if (!hasReg) {
                            out.println("<tr><td colspan='3' style='text-align:center;'>No courses registered yet.</td></tr>");
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
