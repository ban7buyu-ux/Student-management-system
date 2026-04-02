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
    <title>Academic Results - Student Management System</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @media print {
            header, .logout-header-btn, .print-btn {
                display: none !important;
            }
            .container {
                margin: 0 !important;
                padding: 0 !important;
                max-width: 100% !important;
            }
            .content-card {
                box-shadow: none !important;
                border: 1px solid #eee !important;
            }
        }
        .print-btn {
            background-color: var(--text-blue);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            float: right;
            margin-bottom: 20px;
            font-weight: bold;
        }
        .print-btn:hover {
            background-color: var(--primary-red);
        }
    </style>
</head>
<body>
    <header>
        Academic Results
        <a href="dashboard.jsp" class="logout-header-btn">
            <i class="fa-solid fa-arrow-left"></i> Back
        </a>
    </header>

    <div class="container" style="max-width: 800px;">
        <button class="print-btn" onclick="window.print()">
            <i class="fa-solid fa-print"></i> Print Grade Sheet
        </button>

        <div class="content-card" style="clear: both;">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 2px solid var(--text-blue); padding-bottom: 10px; margin-bottom: 20px;">
                <div>
                    <h2 style="color: var(--primary-red); margin: 0;">End-Semester Results</h2>
                    <p style="font-size: 14px; color: #666; margin: 5px 0 0 0;">Official Performance Report</p>
                </div>
                <div style="text-align: right; font-size: 14px; color: #333;">
                    <strong>Student:</strong> <%= email %><br>
                    <strong>Date:</strong> <%= new java.util.Date() %>
                </div>
            </div>
            
            <table>
                <thead>
                    <tr>
                        <th>Subject Name</th>
                        <th>Marks</th>
                        <th>Grade</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    boolean hasData = false;
                    try (Connection conn = DBConnection.getConnection()) {
                        String sql = "SELECT subject, marks FROM results WHERE email = ?";
                        PreparedStatement pst = conn.prepareStatement(sql);
                        pst.setString(1, email);
                        ResultSet rs = pst.executeQuery();
                        while (rs.next()) {
                            hasData = true;
                            int marks = rs.getInt("marks");
                            String grade = "F";
                            if (marks >= 90) grade = "A+";
                            else if (marks >= 80) grade = "A";
                            else if (marks >= 70) grade = "B";
                            else if (marks >= 60) grade = "C";
                            else if (marks >= 50) grade = "D";
                %>
                    <tr>
                        <td><%= rs.getString("subject") %></td>
                        <td style="font-weight: bold;"><%= marks %></td>
                        <td style="font-weight: bold; color: <%= marks >= 50 ? "#27ae60" : "#e74c3c" %>;"><%= grade %></td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='3'>Error: " + e.getMessage() + "</td></tr>");
                    }
                    if (!hasData) {
                        out.println("<tr><td colspan='3' style='text-align:center; color:#e74c3c;'>No results found for this session.</td></tr>");
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
