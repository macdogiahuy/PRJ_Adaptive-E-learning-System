<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="model.Users"%>
<%
    Users user = (Users) session.getAttribute("account");
    if (user == null) {
        out.println("<h2>Please login first</h2>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Test Courses Query</title>
    <style>
        body { font-family: monospace; padding: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        .info { background: #e3f2fd; padding: 10px; margin: 10px 0; border-left: 4px solid #2196F3; }
    </style>
</head>
<body>
    <h1>Database Course Query Test</h1>
    
    <div class="info">
        <strong>Logged in user:</strong><br>
        ID: <%= user.getId() %><br>
        Username: <%= user.getUserName() %><br>
        Role: <%= user.getRole() %>
    </div>
    
    <h2>All Courses in Database</h2>
    <%
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://localhost:1433;databaseName=CourseHubDB;encrypt=true;trustServerCertificate=true";
        conn = DriverManager.getConnection(url, "sa", "1234");
        
        // Query all courses
        String sqlAll = "SELECT Id, Title, CreatorId, Status, CreationTime FROM Courses ORDER BY CreationTime DESC";
        ps = conn.prepareStatement(sqlAll);
        rs = ps.executeQuery();
        
        out.println("<table>");
        out.println("<tr><th>ID</th><th>Title</th><th>CreatorId</th><th>Status</th><th>Created</th></tr>");
        
        int count = 0;
        while (rs.next()) {
            count++;
            out.println("<tr>");
            out.println("<td>" + rs.getString("Id") + "</td>");
            out.println("<td>" + rs.getString("Title") + "</td>");
            out.println("<td>" + rs.getString("CreatorId") + "</td>");
            out.println("<td>" + rs.getString("Status") + "</td>");
            out.println("<td>" + rs.getTimestamp("CreationTime") + "</td>");
            out.println("</tr>");
        }
        out.println("</table>");
        out.println("<p><strong>Total courses: " + count + "</strong></p>");
        
        rs.close();
        ps.close();
        
        // Query courses by current user
        out.println("<h2>Courses Created by Current User (ID: " + user.getId() + ")</h2>");
        
        String sqlUser = "SELECT Id, Title, CreatorId, Status, CreationTime FROM Courses WHERE CreatorId = ? ORDER BY CreationTime DESC";
        ps = conn.prepareStatement(sqlUser);
        ps.setString(1, user.getId());
        rs = ps.executeQuery();
        
        out.println("<table>");
        out.println("<tr><th>ID</th><th>Title</th><th>CreatorId</th><th>Status</th><th>Created</th></tr>");
        
        int userCount = 0;
        while (rs.next()) {
            userCount++;
            out.println("<tr>");
            out.println("<td>" + rs.getString("Id") + "</td>");
            out.println("<td>" + rs.getString("Title") + "</td>");
            out.println("<td>" + rs.getString("CreatorId") + "</td>");
            out.println("<td>" + rs.getString("Status") + "</td>");
            out.println("<td>" + rs.getTimestamp("CreationTime") + "</td>");
            out.println("</tr>");
        }
        out.println("</table>");
        out.println("<p><strong>Total courses by you: " + userCount + "</strong></p>");
        
    } catch (Exception e) {
        out.println("<div style='color: red; background: #ffebee; padding: 10px;'>");
        out.println("<strong>Error:</strong> " + e.getMessage() + "<br>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("</div>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
    %>
    
    <br><br>
    <a href="<%= request.getContextPath() %>/instructor-courses">Go to Manage Courses</a> |
    <a href="<%= request.getContextPath() %>/create-course">Create New Course</a>
</body>
</html>
