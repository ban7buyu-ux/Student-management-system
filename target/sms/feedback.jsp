<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <title>Submit Feedback - SMS</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <header>
        Student Feedback
        <a href="dashboard.jsp" class="logout-header-btn">
            <i class="fa-solid fa-arrow-left"></i> Back
        </a>
    </header>

    <div class="container" style="max-width: 700px;">
        <%
            String successMsg = (String) request.getAttribute("successMessage");
            String errorMsg = (String) request.getAttribute("errorMessage");
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
            }
            if (errorMsg != null) {
        %>
            <div class="error" style="text-align: center; margin-bottom: 20px;"><%= errorMsg %></div>
        <%
            }
        %>

        <div class="content-card">
            <h2 style="color: var(--primary-red); margin-top: 0; border-bottom: 2px solid var(--text-blue); padding-bottom: 10px;">Submit Your Feedback</h2>
            <p style="font-size: 14px; color: #666; margin-bottom: 20px;">We value your suggestions! Please share your thoughts below.</p>

            <form action="FeedbackServlet" method="post">
                <div style="margin-bottom: 20px;">
                    <label style="display: block; margin-bottom: 8px; font-weight: bold; color: #333;">Your Message</label>
                    <textarea name="message" placeholder="Type your feedback or suggestions here..." required 
                              style="width: 100%; height: 150px; padding: 12px; border: 1px solid #ccc; border-radius: 5px; font-family: inherit; resize: vertical;"></textarea>
                </div>

                <button type="submit">SEND FEEDBACK</button>
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
