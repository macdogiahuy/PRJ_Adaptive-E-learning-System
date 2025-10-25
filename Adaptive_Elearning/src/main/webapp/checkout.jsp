<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>
<%@page import="java.util.*"%>
<%
    String method = request.getParameter("method");
    String message = "";
    Users u = (Users) session.getAttribute("account");
    if (u == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    if ("cod".equals(method)) {
        message = "Đặt hàng thành công! Bạn sẽ thanh toán khi nhận khóa học.";
    } else if ("online".equals(method)) {
        message = "Thanh toán thành công! Cảm ơn bạn đã sử dụng VietQR.";
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Checkout - EduHub</title>
    <link rel="stylesheet" href="/Adaptive_Elearning/assets/css/checkout.css">
</head>
<body>
    <div class="checkout-container">
        <h1>Checkout</h1>
        <div class="checkout-message">
            <h2><%= message %></h2>
            <p>Một email xác nhận đã được gửi tới: <strong><%= u.getEmail() %></strong></p>
            <a href="/Adaptive_Elearning/my-courses" class="btn-primary">Về trang khóa học của tôi</a>
        </div>
    </div>
</body>
</html>
