<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="servlet.MyCoursesServlet.CourseEnrollmentInfo"%>
<%@page import="servlet.MyCoursesServlet.CourseStats"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khóa Học Của Tôi - CourseHub</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <style>
        .course-card {
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-radius: 15px;
            overflow: hidden;
        }
        
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .course-thumbnail {
            height: 200px;
            object-fit: cover;
            width: 100%;
        }
        
        .progress-bar {
            height: 8px;
            border-radius: 5px;
        }
        
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .stats-item {
            text-align: center;
        }
        
        .stats-number {
            font-size: 2.5rem;
            font-weight: bold;
            display: block;
        }
        
        .stats-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        
        .page-header {
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 3rem;
        }
        
        .badge-level {
            font-size: 0.8rem;
            padding: 0.4rem 0.8rem;
        }
        
        .course-meta {
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .enrolled-date {
            font-size: 0.8rem;
            color: #888;
        }
        
        .success-message {
            animation: slideInDown 0.5s ease-out;
        }
        
        @keyframes slideInDown {
            from {
                transform: translateY(-100%);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-graduation-cap me-2"></i>CourseHub
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                            <i class="fas fa-home me-1"></i>Trang chủ
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/my-courses">
                            <i class="fas fa-book me-1"></i>Khóa học của tôi
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart.jsp">
                            <i class="fas fa-shopping-cart me-1"></i>Giỏ hàng
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user me-1"></i>${user.userName}
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#"><i class="fas fa-user-edit me-2"></i>Hồ sơ</a></li>
                            <li><a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i>Cài đặt</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Success Message -->
    <c:if test="${showSuccessMessage}">
        <div class="alert alert-success alert-dismissible fade show success-message m-0" role="alert">
            <div class="container">
                <div class="d-flex align-items-center">
                    <div class="me-3">
                        <i class="fas fa-check-circle fa-2x"></i>
                    </div>
                    <div class="flex-grow-1">
                        <h5 class="alert-heading mb-1">🎉 Chúc mừng! Thanh toán thành công!</h5>
                        <p class="mb-0">${successMessage}</p>
                        <small class="text-success">
                            <i class="fas fa-info-circle me-1"></i>
                            Các khóa học đã được thêm vĩnh viễn vào tài khoản của bạn
                        </small>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-5 fw-bold mb-2">
                        <i class="fas fa-book-open me-3"></i>Khóa Học Của Tôi
                    </h1>
                    <p class="lead mb-0">Quản lý và theo dõi tiến trình học tập của bạn</p>
                </div>
                <div class="col-md-4 text-md-end">
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-light btn-lg">
                        <i class="fas fa-search me-2"></i>Khám phá thêm
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Statistics -->
        <c:if test="${courseStats != null}">
            <div class="stats-card">
                <div class="row">
                    <div class="col-md-3 stats-item">
                        <span class="stats-number">${courseStats.totalCourses}</span>
                        <span class="stats-label">Tổng khóa học</span>
                    </div>
                    <div class="col-md-3 stats-item">
                        <span class="stats-number">${courseStats.completedCourses}</span>
                        <span class="stats-label">Đã hoàn thành</span>
                    </div>
                    <div class="col-md-3 stats-item">
                        <span class="stats-number">${courseStats.inProgressCourses}</span>
                        <span class="stats-label">Đang học</span>
                    </div>
                    <div class="col-md-3 stats-item">
                        <span class="stats-number">${courseStats.totalHours}</span>
                        <span class="stats-label">Giờ học</span>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Courses Grid -->
        <div class="row">
            <c:choose>
                <c:when test="${empty enrolledCourses}">
                    <!-- Empty State -->
                    <div class="col-12">
                        <div class="empty-state">
                            <i class="fas fa-book-open"></i>
                            <h3>Chưa có khóa học nào</h3>
                            <p class="mb-4">Bạn chưa đăng ký khóa học nào. Hãy khám phá và tìm kiếm những khóa học phù hợp!</p>
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary btn-lg">
                                <i class="fas fa-search me-2"></i>Khám phá khóa học
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Course Cards -->
                    <c:forEach var="courseInfo" items="${enrolledCourses}">
                        <div class="col-lg-4 col-md-6 mb-4">
                            <div class="card course-card h-100">
                                <!-- Course Thumbnail -->
                                <div class="position-relative">
                                    <c:choose>
                                        <c:when test="${not empty courseInfo.course.thumbUrl}">
                                            <img src="${courseInfo.course.thumbUrl}" 
                                                 class="course-thumbnail" 
                                                 alt="${courseInfo.course.title}"
                                                 onerror="this.src='${pageContext.request.contextPath}/assets/images/default-course.jpg'">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/assets/images/default-course.jpg" 
                                                 class="course-thumbnail" 
                                                 alt="Default Course Image">
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <!-- Level Badge -->
                                    <span class="position-absolute top-0 end-0 m-2">
                                        <span class="badge bg-primary badge-level">
                                            ${courseInfo.course.level != null ? courseInfo.course.level : 'Cơ bản'}
                                        </span>
                                    </span>
                                    
                                    <!-- Progress Overlay -->
                                    <div class="position-absolute bottom-0 start-0 end-0 p-2 bg-dark bg-opacity-75">
                                        <div class="progress">
                                            <div class="progress-bar bg-success" 
                                                 style="width: ${courseInfo.progress}%"
                                                 aria-valuenow="${courseInfo.progress}" 
                                                 aria-valuemin="0" 
                                                 aria-valuemax="100">
                                            </div>
                                        </div>
                                        <small class="text-white">Tiến độ: ${courseInfo.progress}%</small>
                                    </div>
                                </div>
                                
                                <div class="card-body d-flex flex-column">
                                    <!-- Course Title -->
                                    <h5 class="card-title fw-bold mb-3">
                                        ${courseInfo.course.title}
                                    </h5>
                                    
                                    <!-- Course Meta -->
                                    <div class="course-meta mb-3">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <span>
                                                <i class="fas fa-users me-1"></i>
                                                ${courseInfo.course.learnerCount != null ? courseInfo.course.learnerCount : 0} học viên
                                            </span>
                                            <c:if test="${courseInfo.course.price != null && courseInfo.course.price > 0}">
                                                <span class="fw-bold text-primary">
                                                    <i class="fas fa-tag me-1"></i>
                                                    ${String.format("%,.0f", courseInfo.course.price)} VNĐ
                                                </span>
                                            </c:if>
                                        </div>
                                        
                                        <!-- Enrollment Date -->
                                        <div class="enrolled-date">
                                            <i class="fas fa-calendar me-1"></i>
                                            Đăng ký: <strong>
                                                <c:choose>
                                                    <c:when test="${courseInfo.enrollment.creationTime != null}">
                                                        ${String.format('%1$td/%1$tm/%1$tY', courseInfo.enrollment.creationTime)}
                                                    </c:when>
                                                    <c:otherwise>N/A</c:otherwise>
                                                </c:choose>
                                            </strong>
                                        </div>
                                        
                                        <!-- Status -->
                                        <div class="mt-2">
                                            <c:choose>
                                                <c:when test="${courseInfo.enrollment.status == 'ACTIVE'}">
                                                    <span class="badge bg-success">
                                                        <i class="fas fa-play me-1"></i>Đang học
                                                    </span>
                                                </c:when>
                                                <c:when test="${courseInfo.enrollment.status == 'COMPLETED'}">
                                                    <span class="badge bg-primary">
                                                        <i class="fas fa-check me-1"></i>Hoàn thành
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">
                                                        <i class="fas fa-clock me-1"></i>Chờ xử lý
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <!-- Action Buttons -->
                                    <div class="mt-auto">
                                        <div class="d-grid gap-2">
                                            <a href="${pageContext.request.contextPath}/course-detail?id=${courseInfo.course.id}" 
                                               class="btn btn-primary">
                                                <i class="fas fa-play me-2"></i>Tiếp tục học
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light py-5 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5><i class="fas fa-graduation-cap me-2"></i>CourseHub</h5>
                    <p>Nền tảng học trực tuyến hàng đầu với hàng nghìn khóa học chất lượng cao.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <p>&copy; 2024 CourseHub. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Auto dismiss success message after 5 seconds
        setTimeout(function() {
            const alert = document.querySelector('.success-message');
            if (alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }
        }, 5000);
        
        // Add loading animation to course cards
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.course-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    card.style.transition = 'all 0.5s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html>