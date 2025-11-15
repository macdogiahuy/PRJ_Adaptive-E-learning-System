<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Users" %>
<%
    Users currentUser = (Users) session.getAttribute("account");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Access Denied</title>
    <style>
        body { font-family: Arial; text-align: center; margin-top: 100px; }
        h1 { color: #e74c3c; }
        a { color: #3498db; text-decoration: none; }
    </style>
</head>
<body>
    <h1>🚫 Access Denied</h1>
    <p>Bạn không có quyền truy cập trang này.</p>
    <% if (currentUser != null) { %>
        <p>Đăng nhập bằng: <strong><%= currentUser.getUserName() %></strong></p>
        <a href="<%= request.getContextPath() %>/home">⬅ Quay về trang chủ</a>
    <% } else { %>
        <a href="<%= request.getContextPath() %>/login">⬅ Quay lại đăng nhập</a>
    <% } %>
</body>
</html>
