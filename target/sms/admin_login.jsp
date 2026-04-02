<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - SMS</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Bulletproof Admin Styling */
        body { background-color: #f7f9fc !important; font-family: 'Inter', sans-serif; margin: 0; padding: 0; }
        .login-container { max-width: 450px; margin: 80px auto; padding: 0 20px; text-align: center; }
        .login-form { margin-top: 50px; }
        .login-form input { width: 100%; display: block; padding: 14px 15px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 6px; font-size: 16px; box-sizing: border-box; }
        .login-links { text-align: center; margin-top: 15px; margin-bottom: 30px; }
        .login-links a, .login-links div { display: block; color: #666; font-size: 14px; text-decoration: none; margin-bottom: 8px; font-weight: 500; }
        .login-links i { margin-right: 5px; color: #0b3c5d; }
        .login-btn { background-color: #4a7c97 !important; color: white !important; padding: 14px; border: none; border-radius: 6px; font-weight: 700; font-size: 16px; width: 100%; cursor: pointer; transition: 0.3s; }
        .login-btn:hover { background-color: #3b6379 !important; }
        .error { color: #A8282D; font-size: 13px; font-weight: 600; margin-bottom: 15px; }
    </style>
</head>
<body>
    <div class="login-container">
        <!-- Admin Title Sync -->
        <div style="margin-bottom: 60px;">
            <h1 style="font-size: 42px; line-height: 1.1; margin: 0; font-family: 'Inter', sans-serif; font-weight: 900; letter-spacing: -1px;">
                <span style="color: #0b3c5d; display: block; margin-bottom: 5px;">Admin</span>
                <span style="color: #407593;">Portal</span>
            </h1>
            <p style="color: #666; margin-top: 15px; font-weight: bold; text-transform: uppercase; letter-spacing: 1px; font-size: 11px;">Authorized Personnel Only</p>
        </div>
        
        <div class="login-form">
            <%
                String errorMsg = (String) request.getAttribute("errorMessage");
                if (errorMsg != null) {
            %>
                <div class="error" style="text-align: center;"><%= errorMsg %></div>
            <%
                }
            %>

            <form action="LoginServlet" method="post">
                <input type="email" name="email" placeholder="Admin Email ID" required>
                <input type="password" name="password" placeholder="Password" required>
                <input type="password" name="securityKey" placeholder="System Security Key" required>
                
                <div class="login-links">
                    <a href="studentmanagementsystem.jsp" style="font-weight: 800; color: #0b3c5d;">
                        <i class="fa-solid fa-arrow-left"></i> Back to Student Login
                    </a>
                </div>

                <button type="submit" class="login-btn">LOGIN TO SYSTEM</button>
            </form>
        </div>
    </div>
</body>
</html>
