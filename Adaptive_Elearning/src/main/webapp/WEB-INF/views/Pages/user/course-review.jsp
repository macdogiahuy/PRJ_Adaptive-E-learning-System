<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${not empty course.title ? course.title : 'Course Detail'} - Adaptive E-Learning</title>
    
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <!-- Home CSS for course card styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css" />
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/course-detail.css" />
</head>
<body>
    <!-- Header -->
    <jsp:include page="/WEB-INF/views/Pages/user/header.jsp" />
    
    <!-- Hero Section -->
    <section class="course-hero">
        <div class="container hero-content">
            <div class="row">
                <div class="col-lg-8">
                    <!-- Back Button -->
                    <a href="${pageContext.request.contextPath}/home" class="back-button">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span>Quay lại trang chủ</span>
                    </a>
                    
                    <h1>${not empty course.title ? course.title : 'Course Title'}</h1>
                    <div class="course-meta-hero">
                        <div class="meta-item-hero">
                            <div class="rating-stars">
                                <c:forEach begin="1" end="5">
                                    <i class="fa-solid fa-star"></i>
                                </c:forEach>
                            </div>
                            <span>${not empty course ? course.averageRating : '0.0'} (${not empty course ? course.ratingCount : 0} đánh giá)</span>
                        </div>
                        <div class="meta-item-hero">
                            <i class="fa-solid fa-user-graduate"></i>
                            <span>${not empty course ? course.learnerCount : 0} học viên</span>
                        </div>
                        <div class="meta-item-hero">
                            <i class="fa-solid fa-clock"></i>
                            <span>Cập nhật gần đây</span>
                        </div>
                        <div class="meta-item-hero">
                            <i class="fa-solid fa-globe"></i>
                            <span>Tiếng Việt</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <section class="course-content-wrapper">
        <div class="content-grid">
            <!-- Left Column - Main Content -->
            <div class="main-content">
                <!-- Course Preview -->
                <div class="course-preview">
                    <img src="${not empty course.thumbUrl ? course.thumbUrl : (pageContext.request.contextPath + '/assets/img/demo/idea.jpg')}" 
                         alt="${not empty course.title ? course.title : 'Course'}" 
                         onerror="this.src='${pageContext.request.contextPath}/assets/img/demo/idea.jpg'" />
                    <div class="preview-overlay" onclick="alert('Video preview coming soon!')">
                        <i class="fa-solid fa-play"></i>
                    </div>
                </div>

                <!-- Tabs Navigation -->
                <div class="course-tabs">
                    <button class="tab-button active" onclick="switchTab(event, 'overview')">
                        <i class="fa-solid fa-book-open"></i> Tổng quan
                    </button>
                    <button class="tab-button" onclick="switchTab(event, 'curriculum')">
                        <i class="fa-solid fa-list-check"></i> Nội dung khóa học
                    </button>
                    <button class="tab-button" onclick="switchTab(event, 'instructor')">
                        <i class="fa-solid fa-chalkboard-user"></i> Giảng viên
                    </button>
                    <button class="tab-button" onclick="switchTab(event, 'reviews')">
                        <i class="fa-solid fa-star"></i> Đánh giá
                    </button>
                </div>

                <!-- Tab Content -->
                <div class="tab-content">
                    <!-- Overview Tab -->
                    <div id="overview" class="tab-pane active">
                        <div class="overview-section">
                            <h3 class="section-title">
                                <i class="fa-solid fa-lightbulb"></i>
                                Bạn sẽ học được gì?
                            </h3>
                            <div class="learning-outcomes">
                                <div class="outcome-item">
                                    <i class="fa-solid fa-circle-check"></i>
                                    <p>Áp dụng các kỹ thuật, chiến lược và quan điểm mới vào cuộc sống của họ, để trở thành phiên bản thành công nhất của chính mình</p>
                                </div>
                                <div class="outcome-item">
                                    <i class="fa-solid fa-circle-check"></i>
                                    <p>Hiểu sâu về các khái niệm cơ bản và nâng cao trong lĩnh vực này</p>
                                </div>
                                <div class="outcome-item">
                                    <i class="fa-solid fa-circle-check"></i>
                                    <p>Thực hành với các dự án thực tế và case studies</p>
                                </div>
                                <div class="outcome-item">
                                    <i class="fa-solid fa-circle-check"></i>
                                    <p>Phát triển tư duy phê phán và kỹ năng giải quyết vấn đề</p>
                                </div>
                            </div>
                        </div>

                        <div class="overview-section">
                            <h3 class="section-title">
                                <i class="fa-solid fa-clipboard-list"></i>
                                Yêu cầu
                            </h3>
                            <ul class="requirements-list">
                                <li>Tôi sẽ dạy bạn mọi thứ bạn cần biết</li>
                                <li>Một máy tính có kết nối internet</li>
                                <li>Sự nhiệt tình và tinh thần học hỏi</li>
                            </ul>
                        </div>

                        <div class="overview-section">
                            <h3 class="section-title">
                                <i class="fa-solid fa-align-left"></i>
                                Mô tả khóa học
                            </h3>
                            <div class="description-text">
                                <c:choose>
                                    <c:when test="${not empty course.intro || not empty course.description}">
                                        <c:if test="${not empty course.intro}">
                                            <div class="intro-section">
                                                <h4 style="font-size: 1.2rem; font-weight: 600; color: #667eea; margin-bottom: 15px;">
                                                    <i class="fa-solid fa-quote-left"></i> Giới thiệu
                                                </h4>
                                                <p style="font-size: 1.1rem; line-height: 1.8; margin-bottom: 25px; padding-left: 15px; border-left: 3px solid #667eea;">
                                                    ${course.intro}
                                                </p>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty course.description}">
                                            <div class="description-section">
                                                <h4 style="font-size: 1.2rem; font-weight: 600; color: #667eea; margin-bottom: 15px;">
                                                    <i class="fa-solid fa-info-circle"></i> Chi tiết
                                                </h4>
                                                <p style="line-height: 1.8;">${course.description}</p>
                                            </div>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <p>Khóa học này được thiết kế để cung cấp cho bạn kiến thức toàn diện và kỹ năng thực tiễn. 
                                        Với phương pháp giảng dạy hiện đại và tương tác, bạn sẽ được trải nghiệm một hành trình học tập 
                                        thú vị và hiệu quả.</p>
                                        <p>Chúng tôi cam kết mang đến cho bạn nội dung chất lượng cao, được cập nhật thường xuyên và 
                                        phù hợp với xu hướng thị trường hiện tại.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Curriculum Tab -->
                    <div id="curriculum" class="tab-pane">
                        <div class="overview-section">
                            <h3 class="section-title">
                                <i class="fa-solid fa-book"></i>
                                Nội dung khóa học
                            </h3>
                            <div class="alert alert-info">
                                <i class="fa-solid fa-info-circle"></i>
                                Nội dung chi tiết khóa học đang được cập nhật...
                            </div>
                        </div>
                    </div>

                    <!-- Instructor Tab -->
                    <div id="instructor" class="tab-pane">
                        <div class="overview-section">
                            <h3 class="section-title">
                                <i class="fa-solid fa-user-tie"></i>
                                Giảng viên
                            </h3>
                            <div class="instructor-card">
                                <div class="instructor-header">
                                    <div class="instructor-avatar">
                                        <i class="fa-solid fa-user"></i>
                                    </div>
                                    <div class="instructor-info">
                                        <h4>${not empty course ? course.instructorName : 'Instructor Name'}</h4>
                                        <p class="text-muted">Chuyên gia trong lĩnh vực</p>
                                    </div>
                                </div>
                                <div class="instructor-stats">
                                    <div class="stat-item">
                                        <i class="fa-solid fa-graduation-cap"></i>
                                        <div>
                                            <strong>Học viên</strong>
                                            <span>${not empty course ? course.learnerCount : 0}</span>
                                        </div>
                                    </div>
                                    <div class="stat-item">
                                        <i class="fa-solid fa-book-open"></i>
                                        <div>
                                            <strong>Khóa học</strong>
                                            <span>1</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Reviews Tab -->
                    <div id="reviews" class="tab-pane">
                        <div class="reviews-container">
                            <h3 class="section-title">
                                <i class="fa-solid fa-star"></i>
                                Đánh giá từ học viên
                            </h3>
                            <div class="no-reviews-message">
                                <i class="fa-solid fa-comments"></i>
                                <p>Chưa có đánh giá nào!</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column - Sticky Sidebar -->
            <aside class="sidebar-sticky">
                <div class="pricing-card">
                    <div class="pricing-card-image">
                        <img src="${not empty course.thumbUrl ? course.thumbUrl : (pageContext.request.contextPath + '/assets/img/demo/idea.jpg')}" 
                             alt="Course" 
                             onerror="this.src='${pageContext.request.contextPath}/assets/img/demo/idea.jpg'" />
                        <c:if test="${not empty course.discount && course.discount > 0}">
                            <span class="pricing-badge">-${course.discount}%</span>
                        </c:if>
                    </div>
                    
                    <div class="pricing-content">
                        <div class="price-section">
                            <c:choose>
                                <c:when test="${not empty course && course.discount > 0}">
                                    <span class="original-price">${course.formattedPrice}</span>
                                    <div class="current-price">${course.formattedDiscountedPrice}</div>
                                    <span class="discount-badge">Giảm ${course.discount}%</span>
                                </c:when>
                                <c:otherwise>
                                    <div class="current-price">${not empty course ? course.formattedPrice : '123.123 ₫'}</div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="cta-buttons">
                            <a href="${pageContext.request.contextPath}/cart/add?courseId=${course.id}" 
                               class="btn-primary-gradient">
                                <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
                            </a>
                            <a href="${pageContext.request.contextPath}/checkout?courseId=${course.id}" 
                               class="btn-secondary">
                                <i class="fa-solid fa-bolt"></i> Mua ngay
                            </a>
                        </div>

                        <div class="course-includes">
                            <h4>Khóa học bao gồm:</h4>
                            <ul class="includes-list">
                                <li>
                                    <i class="fa-solid fa-infinity"></i>
                                    <span>Truy cập trọn đời</span>
                                </li>
                                <li>
                                    <i class="fa-solid fa-mobile-screen"></i>
                                    <span>Học trên mọi thiết bị</span>
                                </li>
                                <li>
                                    <i class="fa-solid fa-certificate"></i>
                                    <span>Chứng chỉ hoàn thành</span>
                                </li>
                                <li>
                                    <i class="fa-solid fa-headset"></i>
                                    <span>Hỗ trợ trực tuyến</span>
                                </li>
                                <li>
                                    <i class="fa-solid fa-file-arrow-down"></i>
                                    <span>Tài liệu tham khảo</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </aside>
        </div>

       
    </section>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        // Tab Switching Function
        function switchTab(event, tabId) {
            // Remove active class from all tabs and buttons
            const tabButtons = document.querySelectorAll('.tab-button');
            const tabPanes = document.querySelectorAll('.tab-pane');
            
            tabButtons.forEach(btn => btn.classList.remove('active'));
            tabPanes.forEach(pane => pane.classList.remove('active'));
            
            // Add active class to clicked button and corresponding pane
            event.currentTarget.classList.add('active');
            document.getElementById(tabId).classList.add('active');
            
            // Smooth scroll to tabs section on mobile
            if (window.innerWidth < 768) {
                document.querySelector('.course-tabs').scrollIntoView({ 
                    behavior: 'smooth', 
                    block: 'start' 
                });
            }
        }

        // Smooth scroll for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Add to cart animation
        document.querySelectorAll('.btn-primary-gradient').forEach(btn => {
            btn.addEventListener('click', function(e) {
                // Add ripple effect
                const ripple = document.createElement('span');
                ripple.style.position = 'absolute';
                ripple.style.borderRadius = '50%';
                ripple.style.background = 'rgba(255,255,255,0.6)';
                ripple.style.width = ripple.style.height = '100px';
                ripple.style.marginLeft = '-50px';
                ripple.style.marginTop = '-50px';
                ripple.style.animation = 'ripple 0.6s';
                this.appendChild(ripple);
                
                setTimeout(() => {
                    ripple.remove();
                }, 600);
            });
        });

        // Lazy loading for images
        if ('IntersectionObserver' in window) {
            const imageObserver = new IntersectionObserver((entries, observer) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const img = entry.target;
                        img.classList.add('loaded');
                        observer.unobserve(img);
                    }
                });
            });

            document.querySelectorAll('img').forEach(img => {
                imageObserver.observe(img);
            });
        }

        // Debug: Check if images are loading
        document.addEventListener('DOMContentLoaded', function() {
            const images = document.querySelectorAll('.more-courses img');
            console.log('Total images in more courses:', images.length);
            images.forEach((img, index) => {
                console.log(`Image ${index}:`, img.src);
                img.addEventListener('load', () => console.log(`Image ${index} loaded successfully`));
                img.addEventListener('error', () => console.error(`Image ${index} failed to load:`, img.src));
            });
        });

        // Sticky sidebar on scroll
        window.addEventListener('scroll', () => {
            const sidebar = document.querySelector('.sidebar-sticky');
            if (sidebar && window.innerWidth > 992) {
                const scrollTop = window.pageYOffset;
                if (scrollTop > 300) {
                    sidebar.style.transform = 'translateY(0)';
                }
            }
        });
    </script>

    <!-- Additional Styles for Instructor Card -->
    <style>
        .instructor-card {
            background: linear-gradient(135deg, #f8f9fd 0%, #e8eaf6 100%);
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }
        
        .instructor-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .instructor-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: var(--primary-gradient);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 2rem;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }
        
        .instructor-info h4 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 5px;
        }
        
        .instructor-stats {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }
        
        .stat-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 20px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .stat-item i {
            font-size: 2rem;
            color: #667eea;
        }
        
        .stat-item strong {
            display: block;
            color: var(--text-secondary);
            font-size: 0.9rem;
        }
        
        .stat-item span {
            display: block;
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
        }
    </style>
</body>
</html>
