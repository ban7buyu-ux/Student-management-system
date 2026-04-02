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
    <title>Add Student - Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="role-admin">
    <header>
        Register New Student
        <a href="admin_dashboard.jsp" class="logout-header-btn">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </header>

    <div class="container">
        <div class="content-card" style="max-width: 500px;">
            <h2 style="color: var(--primary-red); margin-top: 0; border-bottom: 2px solid var(--text-blue); padding-bottom: 10px;">Student Registration</h2>
            <p style="font-size: 13px; color: #666; margin-bottom: 20px;">Use this form to register a new student and their initial academic details in the system.</p>

            <form action="AddStudentServlet" method="post">
                <input type="email" name="email" placeholder="Student Email (Must match users table)" required>
                <input type="text" name="name" placeholder="Full Student Name" required>
                <input type="text" name="dept" placeholder="Department (e.g., Computer Science)" required>
                <input type="text" name="year" placeholder="Current Year (e.g., 4th Year)" required>
                <input type="text" name="phone" placeholder="Contact Number" required>
                
                <div style="margin-top: 25px; padding-top: 15px; border-top: 1px dashed #ccc;">
                    <h3 style="margin-top: 0; font-size:16px; color: var(--text-blue);">Initial Enrollment Data</h3>
                    <input type="text" name="subject" placeholder="Primary Subject Name">
                    <input type="number" name="percentage" placeholder="Attendance (%)" min="0" max="100">
                    <input type="number" name="marks" placeholder="Exam Marks (0-100)" min="0" max="100">
                </div>

                <button type="submit" style="margin-top:20px;">Register Student Record</button>
            </form>
        </div>
    </div>
</body>
</html>
