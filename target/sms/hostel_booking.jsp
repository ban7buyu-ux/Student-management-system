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
    <title>Book Hostel Room - SMS</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @media print {
            header, .logout-header-btn, .print-btn, .content-card:not(.print-container) {
                display: none !important;
            }
            .container {
                margin: 0 !important;
                padding: 0 !important;
                max-width: 100% !important;
            }
            .print-container {
                box-shadow: none !important;
                border: 1px solid #000 !important;
                display: block !important;
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
    </style>
</head>
<body>
    <header>
        Hostel Booking Portal
        <a href="dashboard.jsp" class="logout-header-btn">
            <i class="fa-solid fa-arrow-left"></i> Back
        </a>
    </header>

    <div class="container" style="max-width: 900px;">
        <%
            String successMsg = (String) session.getAttribute("successMessage");
            if (successMsg != null) {
        %>
            <button class="print-btn" onclick="window.print()">
                <i class="fa-solid fa-print"></i> Print Booking Sheet
            </button>

            <div class="toast" style="background-color: #4a744c; margin-bottom: 20px; clear: both;">
                <div class="toast-icon">✓</div>
                <div class="toast-body">
                    <h4>Booking Success!</h4>
                    <p style="color: white; font-weight: bold; font-size:14px; margin-top:5px;"><%= successMsg %></p>
                </div>
                <div style="margin-left: auto; cursor: pointer;" onclick="this.parentElement.style.display='none'">✕</div>
            </div>

            <!-- Hidden printable area -->
            <div class="content-card print-container" style="display: none; margin-top: 20px; border: 2px solid var(--text-blue);">
                <div style="text-align: center; border-bottom: 2px solid var(--primary-red); padding-bottom: 15px; margin-bottom: 20px;">
                    <h2 style="color: var(--primary-red); margin: 0;">Hostel Allotment Order</h2>
                    <p style="color: #666; margin: 5px 0 0 0;">Official Student Housing Assignment</p>
                </div>
                
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        String sql = "SELECT * FROM hostel WHERE email = ?";
                        PreparedStatement pst = conn.prepareStatement(sql);
                        pst.setString(1, email);
                        ResultSet rs = pst.executeQuery();
                        if (rs.next()) {
                %>
                <div style="font-size: 18px; line-height: 2;">
                    <strong>Student Email:</strong> <%= email %><br>
                    <strong>Date of Allotment:</strong> <%= new java.util.Date() %><br>
                    <hr style="border: 0; border-top: 1px dashed #ccc; margin: 20px 0;">
                    <div style="background: #f9f9f9; padding: 20px; border-radius: 5px;">
                        <span style="color: var(--text-blue); font-weight: bold;">ALLOTMENT DETAILS:</span><br>
                        <strong>Building Block:</strong> <%= rs.getString("block_name") %><br>
                        <strong>Room Number:</strong> <%= rs.getString("room_number") %><br>
                        <strong>Status:</strong> CONFIRMED / ALLOTTED
                    </div>
                </div>
                <%
                        }
                    } catch (Exception e) {
                        out.println("Error loading print details.");
                    }
                %>
                
                <div style="margin-top: 40px; text-align: right; border-top: 1px solid #eee; padding-top: 10px;">
                    <p style="font-size: 12px; color: #999;">This is a computer-generated document from the SMS Portal.</p>
                </div>
            </div>
        <%
                session.removeAttribute("successMessage");
            }
        %>

        <div class="content-card">
            <h2 style="color: var(--primary-red); margin-top: 0; border-bottom: 2px solid var(--text-blue); padding-bottom: 10px;">Available Rooms</h2>
            <p style="font-size: 14px; color: #666; margin-bottom: 20px;">Choose a block and room that suits your preference. Available rooms are listed below.</p>

            <form action="HostelBookingServlet" method="post">
                <table>
                    <thead>
                        <tr>
                            <th>Select</th>
                            <th>Block Name</th>
                            <th>Room No</th>
                            <th>Capacity</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        try (Connection conn = DBConnection.getConnection()) {
                            // Check if student already has a room
                            String checkSql = "SELECT * FROM hostel WHERE email = ?";
                            PreparedStatement checkPst = conn.prepareStatement(checkSql);
                            checkPst.setString(1, email);
                            ResultSet checkRs = checkPst.executeQuery();
                            boolean alreadyBooked = checkRs.next();

                            String sql = "SELECT * FROM hostel_rooms WHERE status = 'Available'";
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery(sql);
                            
                            while (rs.next()) {
                    %>
                        <tr>
                            <td>
                                <input type="radio" name="roomId" value="<%= rs.getInt("id") %>" <%= alreadyBooked ? "disabled" : "required" %>>
                            </td>
                            <td><%= rs.getString("block_name") %></td>
                            <td><%= rs.getString("room_number") %></td>
                            <td><%= rs.getInt("capacity") %> Students</td>
                            <td><span style="color: #27ae60; font-weight: bold;"><%= rs.getString("status") %></span></td>
                        </tr>
                    <%
                            }
                            if (alreadyBooked) {
                    %>
                        <tr>
                            <td colspan="5" style="text-align: center; color: #e74c3c; font-weight: bold; padding: 20px;">
                                <i class="fa-solid fa-circle-exclamation"></i> You have already been allotted a room and cannot book another one.
                            </td>
                        </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                    </tbody>
                </table>

                <button type="submit" style="margin-top: 25px;" <%= session.getAttribute("alreadyBooked") != null ? "disabled" : "" %>>Confirm Room Selection</button>
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
