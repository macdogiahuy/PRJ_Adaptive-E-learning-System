<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Courses - Adaptive E-learning 2025</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #e0e7ff 0%, #f5f7fa 100%);
                min-height: 100vh;
            }
            .glass {
                background: rgba(255,255,255,0.7);
                box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.18);
                backdrop-filter: blur(12px);
                border-radius: 24px;
                border: 1px solid rgba(255,255,255,0.18);
            }
            .neumorph {
                background: #f5f7fa;
                border-radius: 18px;
                box-shadow: 8px 8px 24px #d1d9e6, -8px -8px 24px #ffffff;
            }
            .course-card {
                border-radius: 22px;
                box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.18);
                border: none;
                overflow: hidden;
                background: rgba(255,255,255,0.85);
                transition: transform 0.2s, box-shadow 0.2s;
                position: relative;
            }
            .course-card:hover {
                transform: translateY(-8px) scale(1.03);
                box-shadow: 0 16px 40px 0 rgba(31, 38, 135, 0.22);
            }
            .course-image {
                height: 180px;
                object-fit: cover;
                border-top-left-radius: 22px;
                border-top-right-radius: 22px;
            }
            .course-status {
                position: absolute;
                top: 18px;
                left: 18px;
                z-index: 2;
            }
            .btn-modern {
                background: linear-gradient(90deg, #6366f1 0%, #00bcd4 100%);
                color: #fff;
                border: none;
                border-radius: 12px;
                font-weight: 600;
                box-shadow: 0 2px 8px rgba(99,102,241,0.12);
                transition: background 0.2s, box-shadow 0.2s;
            }
            .btn-modern:hover {
                background: linear-gradient(90deg, #00bcd4 0%, #6366f1 100%);
                box-shadow: 0 4px 16px rgba(99,102,241,0.18);
            }
            .sidebar-section {
                margin-bottom: 2rem;
            }
            @media (max-width: 991px) {
                .course-image { height: 140px; }
            }
            @media (max-width: 767px) {
                .glass, .neumorph { border-radius: 12px; }
                .course-card { border-radius: 14px; }
                .course-image { border-radius: 14px 14px 0 0; }
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <div class="animated-bg">
            <span style="left:10vw; animation-delay:0s;"></span>
            <span style="left:30vw; animation-delay:2s;"></span>
            <span style="left:50vw; animation-delay:4s;"></span>
            <span style="left:70vw; animation-delay:1s;"></span>
            <span style="left:90vw; animation-delay:3s;"></span>
        </div>
        <!-- 3D Banner Spline Embed, làm mờ nhẹ -->
        <div style="width:100%;max-width:1100px;height:180px;overflow:hidden;border-radius:28px;margin:32px auto 32px auto;box-shadow:0 4px 24px 0 rgba(31,38,135,0.10);position:relative;z-index:1;backdrop-filter: blur(2px);background:rgba(255,255,255,0.18);">
            <iframe src="https://app.spline.design/community/file/1b2c3d4e-5f6g-7h8i-9j0k-1l2m3n4o5p6q/embed" frameborder="0" width="100%" height="180" style="background:transparent;filter: blur(0.5px) brightness(0.97);"></iframe>
        </div>
    <div class="container" style="padding-top: 12px; padding-bottom: 32px;">
            <div class="row g-4">
                <!-- Sidebar -->
                <aside class="col-lg-3">
                    <div class="glass sidebar-section p-4 mb-4">
                        <h5 class="fw-bold mb-3"><i class="fas fa-th-large me-2"></i> Danh mục</h5>
                        <div class="list-group list-group-flush">
                            <a href="?category=development" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                <span><i class="fas fa-code me-2 category-icon-dev"></i>Development</span>
                                <span class="badge bg-primary rounded-pill">14</span>
                            </a>
                            <a href="?category=marketing" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                <span><i class="fas fa-bullhorn me-2 category-icon-marketing"></i>Marketing</span>
                                <span class="badge bg-primary rounded-pill">8</span>
                            </a>
                            <a href="?category=business" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                <span><i class="fas fa-briefcase me-2 category-icon-business"></i>Business</span>
                                <span class="badge bg-primary rounded-pill">12</span>
                            </a>
                            <a href="?category=lifestyle" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                <span><i class="fas fa-heart me-2 category-icon-lifestyle"></i>Lifestyle</span>
                                <span class="badge bg-primary rounded-pill">6</span>
                            </a>
                            <a href="?category=personal" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                <span><i class="fas fa-user-astronaut me-2 category-icon-personal"></i>Personal Development</span>
                                <span class="badge bg-primary rounded-pill">10</span>
                            </a>
                        </div>
                    </div>
                    <div class="glass sidebar-section p-4 mb-4">
                        <h5 class="fw-bold mb-3"><i class="fas fa-sort me-2"></i> Sắp xếp</h5>
                        <div class="list-group list-group-flush">
                            <a href="?sort=newest${searchTerm != null ? '&search='+=searchTerm : ''}" class="list-group-item list-group-item-action ${sortBy == null || sortBy == 'newest' ? 'active' : ''}"><i class="fas fa-clock me-2"></i>Mới nhất</a>
                            <a href="?sort=popular${searchTerm != null ? '&search='+=searchTerm : ''}" class="list-group-item list-group-item-action ${sortBy == 'popular' ? 'active' : ''}"><i class="fas fa-fire me-2"></i>Phổ biến</a>
                            <a href="?sort=rating${searchTerm != null ? '&search='+=searchTerm : ''}" class="list-group-item list-group-item-action ${sortBy == 'rating' ? 'active' : ''}"><i class="fas fa-star me-2"></i>Đánh giá cao</a>
                            <a href="?sort=price${searchTerm != null ? '&search='+=searchTerm : ''}" class="list-group-item list-group-item-action ${sortBy == 'price' ? 'active' : ''}"><i class="fas fa-tag me-2"></i>Giá</a>
                        </div>
                    </div>
                    <div class="glass sidebar-section p-4">
                        <h5 class="fw-bold mb-3"><i class="fas fa-chart-pie me-2"></i> Thống kê</h5>
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item d-flex justify-content-between align-items-center">Tổng khóa học <span class="badge bg-primary rounded-pill">${stats.totalCourses}</span></li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">Đang diễn ra <span class="badge bg-success rounded-pill">${stats.ongoingCourses}</span></li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">Đã hoàn thành <span class="badge bg-info rounded-pill">${stats.completedCourses}</span></li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">Bản nháp <span class="badge bg-secondary rounded-pill">${stats.draftCourses}</span></li>
                        </ul>
                    </div>
                </aside>
                <!-- Main Content -->
                <main class="col-lg-9">
                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4" style="margin-top: 8px;">
                        <h2 class="fw-bold mb-2 mb-md-0" style="font-size:2.1rem;letter-spacing:-1px;">
                            <c:choose>
                                <c:when test="${not empty searchTerm}">Kết quả cho "${searchTerm}"</c:when>
                                <c:otherwise>Danh sách khóa học</c:otherwise>
                            </c:choose>
                        </h2>
                        <span class="text-muted" style="font-size:1.1rem;">
                            Hiển thị ${(currentPage-1)*6 + 1} - ${Math.min(currentPage*6, totalCourses)} / ${totalCourses} khóa học
                        </span>
                    </div>
                    <div class="row g-4">
                        <c:forEach items="${courses}" var="course">
                            <div class="col-md-6 col-lg-4">
                                <div class="course-card p-0 mb-3">
                                    <img src="${course.thumbUrl}" class="course-image w-100" alt="${course.title}" onerror="this.src='${pageContext.request.contextPath}/assets/img/course-default.jpg'">
                                    <div class="course-status">
                                        <span class="badge bg-${course.status == 'Ongoing' ? 'success' : course.status == 'Completed' ? 'primary' : 'secondary'}">${course.status}</span>
                                    </div>
                                    <div class="card-body">
                                        <h5 class="card-title text-truncate mb-2" title="${course.title}">${course.title}</h5>
                                        <p class="card-text text-muted small mb-2"><i class="fas fa-chalkboard-teacher"></i> ${course.instructorName}</p>
                                        <p class="card-text mb-2"><span class="badge bg-light text-dark"><i class="fas fa-layer-group"></i> ${course.level}</span></p>
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div class="price-section">
                                                <c:if test="${course.hasDiscount()}">
                                                    <small class="text-decoration-line-through text-muted">${course.formattedPrice}</small>
                                                    <span class="badge bg-danger">-${course.discountPercentage}%</span><br>
                                                </c:if>
                                                <span class="price">${course.formattedDiscountedPrice}</span>
                                            </div>
                                            <span class="learners"><i class="fas fa-users"></i> ${course.learnerCount}</span>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div class="rating">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="fa${i <= course.averageRating ? 's' : 'r'} fa-star"></i>
                                                </c:forEach>
                                                <small class="text-muted">(${course.ratingCount})</small>
                                            </div>
                                            <a href="course-detail?id=${course.id}" class="btn btn-modern btn-sm">Xem chi tiết</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <nav aria-label="Course pagination" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}${not empty searchTerm ? '&search='+=searchTerm : ''}${not empty sortBy ? '&sort='+=sortBy : ''}" tabindex="-1"><i class="fas fa-chevron-left"></i></a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}${not empty searchTerm ? '&search='+=searchTerm : ''}${not empty sortBy ? '&sort='+=sortBy : ''}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}${not empty searchTerm ? '&search='+=searchTerm : ''}${not empty sortBy ? '&sort='+=sortBy : ''}"><i class="fas fa-chevron-right"></i></a>
                            </li>
                        </ul>
                    </nav>
                </main>
            </div>
        </div>
                <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script>
                <!-- VanillaTilt.js for 3D card hover -->
                <script src="https://cdn.jsdelivr.net/npm/vanilla-tilt@1.7.2/dist/vanilla-tilt.min.js"></script>
                <script>
                    window.addEventListener('DOMContentLoaded', function() {
                        if (window.VanillaTilt) {
                            VanillaTilt.init(document.querySelectorAll('.course-card'), {
                                max: 18,
                                speed: 600,
                                glare: true,
                                'max-glare': 0.18
                            });
                        }
                    });
                </script>
    </body>
</html>