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
    <title>View Students - Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="role-admin">
    <header>
        Manage Students
        <a href="admin_dashboard.jsp" class="logout-header-btn">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </header>

    <div class="container" style="max-width: 900px;">
        <div class="content-card">
            <h2 style="color: var(--primary-red); margin-top: 0; border-bottom: 2px solid var(--text-blue); padding-bottom: 10px;">Registered Students</h2>
            
            <div style="margin: 15px 0;">
                <input type="text" id="studentSearch" onkeyup="searchTable()" placeholder="Search by name or department..." style="width: 100%; border: 1px solid #ccc;">
            </div>

            <table id="studentTable">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Department</th>
                        <th>Email</th>
                        <th>Year</th>
                        <th>Phone</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        String sql = "SELECT * FROM profile ORDER BY name ASC";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);
                        while (rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getString("name") %></td>
                        <td><%= rs.getString("department") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td><%= rs.getString("year") %></td>
                        <td><%= rs.getString("phone") %></td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='5'>Error loading data: " + e.getMessage() + "</td></tr>");
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
    function searchTable() {
        var input, filter, table, tr, td, i, txtValue;
        input = document.getElementById("studentSearch");
        filter = input.value.toUpperCase();
        table = document.getElementById("studentTable");
        tr = table.getElementsByTagName("tr");

        for (i = 1; i < tr.length; i++) {
            tr[i].style.display = "none";
            td = tr[i].getElementsByTagName("td");
            for (var j = 0; j < td.length; j++) {
                if (td[j]) {
                    txtValue = td[j].textContent || td[j].innerText;
                    if (txtValue.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                        break;
                    }
                }
            }
        }
    }

    </script>
</body>
</html>
