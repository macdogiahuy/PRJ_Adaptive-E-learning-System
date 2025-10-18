<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%
    List<User> users = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"/>
    <title>User List</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f8f8f8; }
        table { border-collapse: collapse; width: 100%; background: #fff; }
        th, td { padding: 10px 14px; border-bottom: 1px solid #eee; }
        th { background: #f0f0f0; }
        tr:hover { background: #f5faff; }
        a { color: #1976d2; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
<h2>User List</h2>
<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Username</th>
        <th>Full Name</th>
        <th>Email</th>
        <th>Role</th>
        <th>Action</th>
    </tr>
    </thead>
    <tbody>
    <% for (User u : users) { %>
        <tr>
            <td><%= u.getId() %></td>
            <td><%= u.getUserName() %></td>
            <td><%= u.getFullName() %></td>
            <td><%= u.getEmail() %></td>
            <td><%= u.getRole() %></td>
            <td><a href="<%= request.getContextPath() %>/profile?id=<%= u.getId() %>">View</a></td>
        </tr>
    <% } %>
    </tbody>
</table>
</body>
</html>
