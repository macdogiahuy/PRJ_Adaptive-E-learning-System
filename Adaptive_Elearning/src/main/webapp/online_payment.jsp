<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>
<%@page import="java.util.*"%>
<%
    String qrUrl = (String) request.getAttribute("qrUrl");
    String orderId = (String) request.getAttribute("orderId");
    Double totalAmount = (Double) request.getAttribute("totalAmount");
    Users u = (Users) session.getAttribute("account");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán VietQR - EduHub</title>
    <link rel="stylesheet" href="/Adaptive_Elearning/assets/css/checkout.css">
</head>
<body>
    <div class="checkout-container">
        <h1>Thanh toán online qua VietQR</h1>
        <div class="qr-section">
            <img src="<%= qrUrl %>" alt="VietQR" class="qr-image" />
            <p>Quét mã QR bằng ứng dụng ngân hàng để thanh toán <strong><%= String.format("%,.0f đ", totalAmount) %></strong></p>
            <form action="/Adaptive_Elearning/checkout" method="post">
                <input type="hidden" name="orderId" value="<%= orderId %>" />
                <button type="submit" class="btn-primary">Tôi đã thanh toán</button>
            </form>
        </div>
        <a href="/Adaptive_Elearning/cart" class="btn-secondary">Quay lại giỏ hàng</a>
    </div>
</body>
</html>
