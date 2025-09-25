<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo Khóa học - Adaptive Elearning</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
       <nav class="sidebar">
            <div class="sidebar-header">
                <h3>Reported Course</h3>
            </div>
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item ">
                    <a href="${pageContext.request.contextPath}/accountmanagement" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Account Management</span>
                    </a>
                </li>
                <li class="nav-item ">
                    <a href="${pageContext.request.contextPath}/createadmin" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Create Admin</span>
                    </a>
                </li>
                
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/notification" class="nav-link">
                        <i class="fas fa-bell"></i>
                        <span>Notification Management</span>
                    </a>
                </li>
                <li class="nav-item ">
                    <a href="" class="nav-link">
                        <i class="fas fa-flag"></i>
                        <span>Reported Groups</span>
                    </a>
                </li>
                <li class="nav-item active">
                    <a href="${pageContext.request.contextPath}/reportedcourse" class="nav-link">
                        <i class="fas fa-book"></i>
                        <span>Reported Courses</span>
                    </a>
                </li>
                <li class="nav-item ">
                    <a href="" class="nav-link">
                        <i class="fas fa-book"></i>
                        <span>Leaner View</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Sign Out</span>
                    </a>
                </li>
            </ul>
        </nav>

</body>
</html>
                        