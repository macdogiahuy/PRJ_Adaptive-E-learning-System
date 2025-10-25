<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CourseHub - Trang chủ</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-graduation-cap"></i> CourseHub
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/courses">Khóa học</a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <c:if test="${sessionScope.user != null}">
                        <!-- Cart Icon -->
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/cart-page" class="nav-link cart-link">
                                <div class="cart-icon-wrapper">
                                    <i class="fas fa-shopping-cart"></i>
                                    <span class="cart-counter" style="display: none;">0</span>
                                </div>
                            </a>
                        </li>
                        
                        <!-- User Menu -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user"></i> ${sessionScope.user.fullName}
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Hồ sơ</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/my-courses">Khóa học của tôi</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                            </ul>
                        </li>
                    </c:if>
                    
                    <c:if test="${sessionScope.user == null}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/register">Đăng ký</a>
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section bg-primary text-white py-5">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="display-4 fw-bold mb-4">Học tập trực tuyến với CourseHub</h1>
                    <p class="lead mb-4">Khám phá hàng ngàn khóa học chất lượng cao từ các chuyên gia hàng đầu</p>
                    <a href="${pageContext.request.contextPath}/courses" class="btn btn-light btn-lg">
                        <i class="fas fa-search"></i> Khám phá khóa học
                    </a>
                </div>
                <div class="col-lg-6">
                    <img src="${pageContext.request.contextPath}/assets/images/hero-image.jpg" 
                         class="img-fluid rounded" alt="E-learning">
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Courses Section -->
    <section class="py-5">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <h2 class="text-center mb-5">Khóa học nổi bật</h2>
                </div>
            </div>
            
            <!-- Courses Grid -->
            <div class="courses-grid">
                <c:forEach var="course" items="${featuredCourses}">
                    <div class="course-card card">
                        <img src="${course.thumbUrl != null ? course.thumbUrl : '/assets/images/default-course.jpg'}" 
                             class="card-img-top" alt="${course.title}">
                        
                        <div class="card-body">
                            <h5 class="card-title">${course.title}</h5>
                            <p class="card-text">${course.description}</p>
                            
                            <div class="course-meta">
                                <span><i class="fas fa-user"></i> ${course.creatorId.fullName}</span>
                                <span><i class="fas fa-star"></i> 
                                    <c:choose>
                                        <c:when test="${course.ratingCount > 0}">
                                            <fmt:formatNumber value="${course.totalRating / course.ratingCount}" pattern="#.#"/>
                                            (${course.ratingCount})
                                        </c:when>
                                        <c:otherwise>Chưa có đánh giá</c:otherwise>
                                    </c:choose>
                                </span>
                                <span><i class="fas fa-users"></i> ${course.learnerCount} học viên</span>
                            </div>
                            
                            <div class="course-price-section">
                                <div class="course-price-info">
                                    <c:choose>
                                        <c:when test="${course.discount > 0 && (course.discountExpiry == null || course.discountExpiry.time > System.currentTimeMillis())}">
                                            <span class="course-price">
                                                <fmt:formatNumber value="${course.price * (1 - course.discount / 100)}" pattern="#,##0"/>₫
                                            </span>
                                            <span class="course-original-price">
                                                <fmt:formatNumber value="${course.price}" pattern="#,##0"/>₫
                                            </span>
                                            <span class="course-discount">-${course.discount}%</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="course-price">
                                                <fmt:formatNumber value="${course.price}" pattern="#,##0"/>₫
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <c:if test="${sessionScope.user != null}">
                                    <!-- Add to Cart Button -->
                                    <button type="button" 
                                            class="btn btn-primary add-to-cart-btn" 
                                            data-course-id="${course.id}">
                                        <i class="fas fa-cart-plus"></i> Thêm vào giỏ hàng
                                    </button>
                                </c:if>
                                
                                <c:if test="${sessionScope.user == null}">
                                    <a href="${pageContext.request.contextPath}/login" 
                                       class="btn btn-outline-primary">
                                        <i class="fas fa-sign-in-alt"></i> Đăng nhập để mua
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <!-- Load More Button -->
            <div class="text-center mt-5">
                <a href="${pageContext.request.contextPath}/courses" class="btn btn-outline-primary btn-lg">
                    <i class="fas fa-plus"></i> Xem thêm khóa học
                </a>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="py-5 bg-light">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <h2 class="text-center mb-5">Tại sao chọn CourseHub?</h2>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-4 text-center mb-4">
                    <div class="feature-item p-4">
                        <i class="fas fa-play-circle fa-3x text-primary mb-3"></i>
                        <h4>Học mọi lúc, mọi nơi</h4>
                        <p>Truy cập khóa học bất cứ khi nào, trên mọi thiết bị</p>
                    </div>
                </div>
                
                <div class="col-md-4 text-center mb-4">
                    <div class="feature-item p-4">
                        <i class="fas fa-certificate fa-3x text-primary mb-3"></i>
                        <h4>Chứng chỉ hoàn thành</h4>
                        <p>Nhận chứng chỉ sau khi hoàn thành khóa học</p>
                    </div>
                </div>
                
                <div class="col-md-4 text-center mb-4">
                    <div class="feature-item p-4">
                        <i class="fas fa-users fa-3x text-primary mb-3"></i>
                        <h4>Cộng đồng học tập</h4>
                        <p>Kết nối và học hỏi cùng cộng đồng học viên</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-white py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5><i class="fas fa-graduation-cap"></i> CourseHub</h5>
                    <p>Nền tảng học tập trực tuyến hàng đầu Việt Nam</p>
                </div>
                <div class="col-md-6">
                    <h5>Liên hệ</h5>
                    <p>
                        <i class="fas fa-envelope"></i> support@coursehub.vn<br>
                        <i class="fas fa-phone"></i> 1900-XXX-XXX
                    </p>
                </div>
            </div>
            <hr>
            <div class="row">
                <div class="col-12 text-center">
                    <p>&copy; 2024 CourseHub. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/cart.js"></script>
    
    <script>
        // Check enrollment status and update buttons
        document.addEventListener('DOMContentLoaded', function() {
            <c:if test="${sessionScope.user != null}">
                // Check if user is already enrolled in courses or courses are in cart
                const cartButtons = document.querySelectorAll('.add-to-cart-btn');
                cartButtons.forEach(button => {
                    const courseId = button.getAttribute('data-course-id');
                    
                    // You can add AJAX call here to check enrollment status
                    // and update button accordingly
                });
            </c:if>
        });
    </script>
</body>
</html>