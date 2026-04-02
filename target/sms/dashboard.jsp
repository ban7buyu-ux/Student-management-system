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
    <title>Student Dashboard - SMS</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <header>
        Student Dashboard
        <a href="LogoutServlet" class="logout-header-btn">
            <i class="fa-solid fa-power-off"></i> Logout
        </a>
    </header>

    <div class="container">
        <!-- Toast Notification mimicking reference -->
        <%
            String successMsg = (String) session.getAttribute("successMessage");
            if (successMsg != null) {
        %>
            <div class="toast">
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

        <!-- Academic Performance Overview -->
        <div class="analytics-grid">
            <%
                int totalAttendance = 0;
                double gpaSum = 0;
                int creditsTotal = 0;
                Connection conn = null;
                PreparedStatement attPst = null;
                PreparedStatement gpaPst = null;
                PreparedStatement credPst = null;
                ResultSet attRs = null;
                ResultSet gpaRs = null;
                ResultSet credRs = null;

                try {
                    conn = DBConnection.getConnection();
                    if (conn != null) {
                        // 1. Attendance Average
                        String attSql = "SELECT AVG(percentage) FROM attendance WHERE email = ?";
                        attPst = conn.prepareStatement(attSql);
                        attPst.setString(1, email);
                        attRs = attPst.executeQuery();
                        if (attRs.next()) totalAttendance = attRs.getInt(1);

                        // 2. GPA Calculation
                        String gpaSql = "SELECT AVG(marks) FROM results WHERE email = ?";
                        gpaPst = conn.prepareStatement(gpaSql);
                        gpaPst.setString(1, email);
                        gpaRs = gpaPst.executeQuery();
                        if (gpaRs.next()) {
                            double avgMarks = gpaRs.getDouble(1);
                            gpaSum = (avgMarks / 100.0) * 4.0;
                        }

                        // 3. Credits Progress
                        String credSql = "SELECT SUM(c.credits) FROM courses c JOIN registrations r ON c.id = r.course_id WHERE r.email = ?";
                        credPst = conn.prepareStatement(credSql);
                        credPst.setString(1, email);
                        credRs = credPst.executeQuery();
                        if (credRs.next()) creditsTotal = credRs.getInt(1);
                    }
                } catch (Exception e) { 
                    e.printStackTrace(); 
                } finally {
                    if (attRs != null) try { attRs.close(); } catch (SQLException ignore) {}
                    if (gpaRs != null) try { gpaRs.close(); } catch (SQLException ignore) {}
                    if (credRs != null) try { credRs.close(); } catch (SQLException ignore) {}
                    if (attPst != null) try { attPst.close(); } catch (SQLException ignore) {}
                    if (gpaPst != null) try { gpaPst.close(); } catch (SQLException ignore) {}
                    if (credPst != null) try { credPst.close(); } catch (SQLException ignore) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                }
            %>
            
            <!-- Attendance Card -->
            <div class="stat-card">
                <div style="font-size: 12px; color: #666; font-weight: bold; text-transform: uppercase;">Attendance</div>
                <div style="font-size: 28px; font-weight: 800; color: var(--primary-red); margin: 10px 0;"><%= totalAttendance %>%</div>
                <div class="progress-bar-container">
                    <div class="progress-bar-fill" style="width: <%= totalAttendance %>%"></div>
                </div>
            </div>

            <!-- Credits Card -->
            <div class="stat-card">
                <div style="font-size: 12px; color: #666; font-weight: bold; text-transform: uppercase;">Academic Progress</div>
                <div style="font-size: 28px; font-weight: 800; color: var(--accent-blue); margin: 10px 0;"><%= creditsTotal %> <span style="font-size: 14px; font-weight: 400;">/ 120 Cr</span></div>
                <div class="progress-bar-container">
                    <div class="progress-bar-fill" style="width: <%= (creditsTotal / 120.0) * 100 %>%"></div>
                </div>
            </div>

            <!-- GPA Card -->
            <div class="stat-card">
                <div style="font-size: 12px; color: #666; font-weight: bold; text-transform: uppercase;">Current GPA</div>
                <div style="font-size: 28px; font-weight: 800; color: #27ae60; margin: 10px 0;"><%= String.format("%.2f", gpaSum) %></div>
                <div style="font-size: 11px; color: #999;">Updated: Today</div>
            </div>
        </div>

        <!-- Digital Notice Board -->
        <div class="content-card" style="margin-bottom: 25px; border-left: 5px solid var(--primary-red); padding: 15px;">
            <h3 style="color: var(--text-blue); margin-top: 0; display: flex; align-items: center; gap: 10px;">
                <i class="fa-solid fa-bullhorn" style="color: var(--primary-red);"></i> University Notice Board
            </h3>
            <div style="max-height: 200px; overflow-y: auto;">
            <%
                conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                try {
                    conn = DBConnection.getConnection();
                    if (conn != null) {
                        String sql = "SELECT * FROM announcements ORDER BY post_date DESC LIMIT 5";
                        stmt = conn.createStatement();
                        rs = stmt.executeQuery(sql);
                        boolean found = false;
                        while (rs.next()) {
                            found = true;
            %>
                <div style="margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px;">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <strong style="color: #333;"><%= rs.getString("title") %></strong>
                        <span style="font-size: 11px; color: #999;"><%= rs.getTimestamp("post_date") %></span>
                    </div>
                    <p style="margin: 5px 0 0 0; font-size: 14px; color: #555;"><%= rs.getString("message") %></p>
                </div>
            <%
                        }
                        if (!found) {
                            out.println("<p style='color: #999; font-style: italic;'>No active announcements at this time.</p>");
                        }
                    }
                } catch (Exception e) {
                    out.println("<p>Error loading notices: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                }
            %>
            </div>
        </div>

        <div class="dashboard-grid">
            <a href="profile.jsp" class="dash-card">
                <div class="card-icon"><i class="fa-regular fa-id-badge"></i></div>
                <div class="card-text">Profile Detail</div>
            </a>
            <a href="attendance.jsp" class="dash-card">
                <div class="card-icon"><i class="fa-regular fa-calendar-check"></i></div>
                <div class="card-text">Attendance Report</div>
            </a>
            <a href="results.jsp" class="dash-card">
                <div class="card-icon"><i class="fa-solid fa-graduation-cap"></i></div>
                <div class="card-text">Results & Marks</div>
            </a>
            <a href="feedback.jsp" class="dash-card">
                <div class="card-icon"><i class="fa-regular fa-comments"></i></div>
                <div class="card-text">Submit Feedback</div>
            </a>
            <a href="course_registration.jsp" class="dash-card">
                <div class="card-icon"><i class="fa-solid fa-book-open"></i></div>
                <div class="card-text">Course Registration</div>
            </a>
            <a href="hostel_booking.jsp" class="dash-card">
                <div class="card-icon"><i class="fa-solid fa-bed"></i></div>
                <div class="card-text">Hostel Booking</div>
            </a>
            <a href="hostel.jsp" class="dash-card">
                <div class="card-icon"><i class="fa-solid fa-house"></i></div>
                <div class="card-text">Hostel Info</div>
            </a>
            <a href="LogoutServlet" class="dash-card">
                <div class="card-icon"><i class="fa-solid fa-power-off"></i></div>
                <div class="card-text">Logout</div>
            </a>
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
