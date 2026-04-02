<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <title>Admin Dashboard - SMS</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Force Visibility for Admin Dashboard */
        .role-admin .card-text { color: #0b3c5d !important; }
        .role-admin h2, .role-admin h3 { color: #0b3c5d !important; }
        .role-admin header { background: #0b3c5d !important; color: white !important; }
        .role-admin .dash-card { background: white !important; border: 1px solid #ddd !important; }
        .role-admin .card-icon { background: #0b3c5d !important; color: white !important; }
    </style>
</head>
<body class="role-admin">
    <header>
        Admin Dashboard
        <a href="LogoutServlet" class="logout-header-btn">
            <i class="fa-solid fa-power-off"></i> Logout
        </a>
    </header>

    <div class="container">
        <!-- Success Toast for Login -->
        <div class="toast">
            <div class="toast-icon">✓</div>
            <div class="toast-body">
                <h4>System Secure</h4>
                <p style="color: white; font-weight: bold; font-size:14px; margin-top:5px;">Admin Logged In: <%= email.toUpperCase() %></p>
                <p style="color: white; margin-top:2px;">Management Portal Accessed Successfully</p>
            </div>
            <div style="margin-left: auto; cursor: pointer;">✕</div>
        </div>

        <h2 style="color: var(--text-blue); margin-bottom: 20px;">System Configuration</h2>

        <div class="dashboard-grid">
            <a href="view_students.jsp" class="dash-card">
                <div class="card-icon"><i class="fa-solid fa-users"></i></div>
                <div class="card-text">View All Students</div>
            </a>
            <a href="manage_courses.jsp" class="dash-card">
                <div class="card-icon"><i class="fa-solid fa-book-bookmark"></i></div>
                <div class="card-text">Manage Courses</div>
            </a>
            <a href="add_student.jsp" class="dash-card">
                <div class="card-icon"><i class="fa-solid fa-user-plus"></i></div>
                <div class="card-text">Add New Student</div>
            </a>
            <a href="enter_marks.jsp" class="dash-card">
                <div class="card-icon"><i class="fa-solid fa-file-invoice"></i></div>
                <div class="card-text">Marks Portal</div>
            </a>
            <a href="manage_noticeboard.jsp" class="dash-card">
                <div class="card-icon"><i class="fa-solid fa-bullhorn"></i></div>
                <div class="card-text">Notice Board</div>
            </a>
            <a href="view_feedback.jsp" class="dash-card">
                <div class="card-icon"><i class="fa-solid fa-envelope-open-text"></i></div>
                <div class="card-text">Student Feedback</div>
            </a>
            <a href="LogoutServlet" class="dash-card">
                <div class="card-icon"><i class="fa-solid fa-power-off"></i></div>
                <div class="card-text">System Logout</div>
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
