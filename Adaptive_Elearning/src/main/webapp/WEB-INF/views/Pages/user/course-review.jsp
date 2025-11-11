<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
                            
                            <!-- Show success/error messages -->
                            <c:if test="${not empty successMessage}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <i class="fa-solid fa-check-circle"></i>
                                    ${successMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <%session.removeAttribute("successMessage");%>
                            </c:if>
                            
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fa-solid fa-exclamation-circle"></i>
                                    ${errorMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <%session.removeAttribute("errorMessage");%>
                            </c:if>
                            
                            <!-- Review Form - Show only if user can review -->
                            <c:if test="${canReview == true}">
                                <div class="add-review-form">
                                    <h4><i class="fa-solid fa-pencil"></i> Viết đánh giá của bạn</h4>
                                    <form action="${pageContext.request.contextPath}/add-review" method="POST">
                                        <input type="hidden" name="courseId" value="${course.id}" />
                                        
                                        <div class="form-group mb-3">
                                            <label class="form-label">Đánh giá của bạn <span class="text-danger">*</span></label>
                                            <div class="rating-input">
                                                <input type="radio" name="rating" value="5" id="star5" required />
                                                <label for="star5" title="5 sao"><i class="fa-solid fa-star"></i></label>
                                                
                                                <input type="radio" name="rating" value="4" id="star4" />
                                                <label for="star4" title="4 sao"><i class="fa-solid fa-star"></i></label>
                                                
                                                <input type="radio" name="rating" value="3" id="star3" />
                                                <label for="star3" title="3 sao"><i class="fa-solid fa-star"></i></label>
                                                
                                                <input type="radio" name="rating" value="2" id="star2" />
                                                <label for="star2" title="2 sao"><i class="fa-solid fa-star"></i></label>
                                                
                                                <input type="radio" name="rating" value="1" id="star1" />
                                                <label for="star1" title="1 sao"><i class="fa-solid fa-star"></i></label>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group mb-3">
                                            <label for="reviewContent" class="form-label">Nội dung đánh giá <span class="text-danger">*</span></label>
                                            <textarea class="form-control" id="reviewContent" name="content" rows="4" 
                                                      placeholder="Chia sẻ trải nghiệm của bạn về khóa học này..." required></textarea>
                                        </div>
                                        
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fa-solid fa-paper-plane"></i> Gửi đánh giá
                                        </button>
                                    </form>
                                </div>
                                <hr class="my-4" />
                            </c:if>
                            
                            <!-- Show message if not enrolled -->
                            <c:if test="${hasEnrolled == false && not empty sessionScope.account}">
                                <div class="alert alert-info">
                                    <i class="fa-solid fa-info-circle"></i>
                                    Bạn cần mua khóa học này để có thể đánh giá.
                                </div>
                            </c:if>
                            
                            <!-- Display Reviews -->
                            <c:choose>
                                <c:when test="${not empty reviews && reviews.size() > 0}">
                                    <div class="reviews-list">
                                        <c:forEach var="review" items="${reviews}">
                                            <div class="review-item">
                                                <div class="review-header">
                                                    <div class="review-author">
                                                        <img src="${not empty review.avatarUrl ? review.avatarUrl : (pageContext.request.contextPath + '/assets/img/default-avatar.png')}" 
                                                             alt="${review.userName}" 
                                                             class="review-avatar"
                                                             onerror="this.src='${pageContext.request.contextPath}/assets/img/default-avatar.png'" />
                                                        <div>
                                                            <h5>${review.userName}</h5>
                                                            <div class="review-rating">
                                                                <c:forEach begin="1" end="${review.rating}">
                                                                    <i class="fa-solid fa-star text-warning"></i>
                                                                </c:forEach>
                                                                <c:forEach begin="${review.rating + 1}" end="5">
                                                                    <i class="fa-regular fa-star text-warning"></i>
                                                                </c:forEach>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="review-meta">
                                                        <div class="review-date">
                                                            <fmt:formatDate value="${review.creationTime}" pattern="dd/MM/yyyy HH:mm" />
                                                        </div>
                                                        <!-- Show Edit/Delete buttons only for review owner -->
                                                        <c:if test="${not empty sessionScope.account && sessionScope.account.id == review.creatorId}">
                                                            <div class="review-actions">
                                                                <button class="btn btn-sm btn-outline-primary btn-edit-review" 
                                                                        data-review-id="${review.id}" 
                                                                        data-rating="${review.rating}" 
                                                                        data-content="${fn:escapeXml(review.content)}">
                                                                    <i class="fa-solid fa-edit"></i> Sửa
                                                                </button>
                                                                <button class="btn btn-sm btn-outline-danger btn-delete-review" 
                                                                        data-review-id="${review.id}" 
                                                                        data-course-id="${course.id}">
                                                                    <i class="fa-solid fa-trash"></i> Xóa
                                                                </button>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>
                                                <div class="review-content">
                                                    <p>${review.content}</p>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-reviews-message">
                                        <i class="fa-solid fa-comments"></i>
                                        <p>Chưa có đánh giá nào!</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
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
                            <button class="btn-primary-gradient add-to-cart-detail" 
                                    data-course-id="${course.id}"
                                    type="button">
                                <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
                            </button>
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
        console.log('🔍 Setting up add-to-cart buttons...');
        
        // Clean up any old notifications on page load
        document.querySelectorAll('.custom-notification').forEach(n => n.remove());
        
        // Remove any stray "false" text elements (debugging artifacts)
        document.querySelectorAll('body > *').forEach(el => {
            if (el.textContent.trim() === 'false' && 
                !el.classList.contains('custom-notification') &&
                el.children.length === 0) {
                console.log('🗑️ Removing debug element:', el);
                el.remove();
            }
        });
        
        const cartButtons = document.querySelectorAll('.add-to-cart-detail');
        console.log('Found buttons:', cartButtons.length);
        
        cartButtons.forEach((btn, index) => {
            console.log(`Button ${index}:`, {
                courseId: btn.getAttribute('data-course-id'),
                className: btn.className
            });
            
            btn.addEventListener('click', async function(e) {
                e.preventDefault();
                console.log('🛒 Add to cart clicked!');
                
                const courseId = this.getAttribute('data-course-id');
                console.log('Course ID:', courseId);
                
                // Prevent multiple clicks
                if (this.classList.contains('loading')) return;
                
                this.classList.add('loading');
                const originalText = this.innerHTML;
                this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang thêm...';

                try {
                    console.log('📤 Sending request to add to cart...');
                    const response = await fetch('<c:url value="/cart" />', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'action=add&courseId=' + courseId
                    });

                    console.log('📥 Response status:', response.status);
                    const result = await response.json();
                    console.log('📦 Full Result:', JSON.stringify(result, null, 2));

                    // XỬ LÝ KẾT QUẢ
                    if (result.success === true) {
                        // ✅ TRƯỜNG HỢP 1: THÀNH CÔNG - Màu XANH LÁ
                        console.log('✅ SUCCESS: Added to cart');
                        showNotification('Thêm khóa học vào giỏ hàng thành công! 🎉', 'success');
                        
                        this.classList.add('added');
                        this.innerHTML = '<i class="fas fa-check"></i> Đã thêm';
                        
                        // Update cart badge
                        const cartBadge = document.querySelector('.cart-badge');
                        if (cartBadge && result.cartCount) {
                            cartBadge.textContent = result.cartCount;
                            cartBadge.style.display = 'flex';
                        }
                        
                        setTimeout(() => {
                            this.classList.remove('added');
                            this.innerHTML = originalText;
                        }, 2000);
                        
                    } else if (result.success === false) {
                        // THẤT BẠI - Kiểm tra nguyên nhân
                        
                        if (result.alreadyOwned === true) {
                            // 🚫 TRƯỜNG HỢP 2: ĐÃ ĐĂNG KÝ - Màu ĐỎ
                            console.log('🚫 FAILED: Already enrolled');
                            showNotification('Bạn đã đăng ký khóa học này rồi! Hãy kiểm tra trong mục "Khóa học của tôi". 📚', 'warning');
                            
                        } else {
                            // ℹ️ TRƯỜNG HỢP 3: ĐÃ CÓ TRONG GIỎ - Màu XANH DƯƠNG
                            console.log('ℹ️ FAILED: Already in cart or other reason');
                            const msg = result.message || 'Khóa học này đã có trong giỏ hàng của bạn rồi!';
                            showNotification(msg, 'info');
                        }
                    }
                    
                } catch (error) {
                    console.error('💥 Error adding to cart:', error);
                    showNotification('Có lỗi xảy ra khi thêm vào giỏ hàng! Vui lòng thử lại.', 'error');
                } finally {
                    this.classList.remove('loading');
                    if (!this.classList.contains('added')) {
                        this.innerHTML = originalText;
                    }
                }
                
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

        // Notification function - DEFENSIVE VERSION
        function showNotification(message, type = 'info') {
            // Normalize / coerce message
            const defaultMessages = {
                success: 'Thêm khóa học vào giỏ hàng thành công! 🎉',
                warning: 'Bạn đã đăng ký khóa học này rồi! Kiểm tra mục "Khóa học của tôi".',
                info: 'Khóa học này đã có trong giỏ hàng của bạn.',
                error: 'Có lỗi xảy ra. Vui lòng thử lại.'
            };
            
            let finalMessage = message; // Use different variable to prevent override
            
            // Handle object parameter (legacy calls)
            if (typeof finalMessage === 'object' && finalMessage !== null) {
                console.warn('[notify] Object detected, extracting message:', finalMessage);
                type = finalMessage.type || type;
                finalMessage = finalMessage.message || finalMessage.text || defaultMessages[type];
            }
            
            if (finalMessage === false || finalMessage === true) {
                console.warn('[notify] Boolean message detected, coercing:', finalMessage);
                finalMessage = defaultMessages[type] || defaultMessages.info;
            } else if (typeof finalMessage !== 'string') {
                console.warn('[notify] Non-string message detected, coercing:', finalMessage, typeof finalMessage);
                finalMessage = defaultMessages[type] || defaultMessages.info;
            } else if (finalMessage.trim().toLowerCase() === 'false') {
                console.warn('[notify] Literal "false" string detected, replacing.');
                finalMessage = defaultMessages[type] || defaultMessages.info;
            }

            console.log('🔔 Showing notification:', finalMessage, '| type:', type);
            
            // Remove existing notifications
            document.querySelectorAll('.custom-notification').forEach(n => n.remove());

            // Icon map
            const iconMap = {
                success: '✅',
                error: '❌',
                warning: '🚫',
                info: 'ℹ️'
            };
            
            // Background colors - SOLID COLORS
            const bgMap = {
                success: '#10b981',
                warning: '#ef4444',
                error: '#ef4444',
                info: '#3b82f6'
            };
            
            const notification = document.createElement('div');
            notification.className = 'custom-notification';
            Object.assign(notification.style, {
                position: 'fixed',
                top: '20px',
                right: '20px',
                minWidth: '320px',
                maxWidth: '450px',
                padding: '20px 24px',
                borderRadius: '12px',
                backgroundColor: bgMap[type] || bgMap.info,
                color: '#ffffff',
                fontSize: '16px',
                fontWeight: '600',
                boxShadow: '0 10px 40px rgba(0,0,0,0.5)',
                zIndex: '9999999',
                display: 'flex',
                alignItems: 'center',
                gap: '15px',
                opacity: '0',
                transform: 'translateX(400px)',
                transition: 'all 0.4s ease'
            });

            // Create elements manually to avoid template literal scope issues
            const iconSpan = document.createElement('span');
            iconSpan.style.fontSize = '24px';
            iconSpan.textContent = iconMap[type] || iconMap.info;
            
            const textSpan = document.createElement('span');
            textSpan.className = 'notification-text';
            textSpan.style.flex = '1';
            textSpan.style.color = '#fff';
            textSpan.textContent = finalMessage; // Direct assignment
            
            const closeBtn = document.createElement('button');
            closeBtn.type = 'button';
            closeBtn.setAttribute('aria-label', 'Đóng');
            closeBtn.style.cssText = 'background:rgba(255,255,255,0.15);border:none;color:#fff;padding:6px 10px;border-radius:8px;cursor:pointer;font-size:12px;';
            closeBtn.textContent = '✖';
            
            notification.appendChild(iconSpan);
            notification.appendChild(textSpan);
            notification.appendChild(closeBtn);
            
            console.log('📝 Text span content:', textSpan.textContent);
            console.log('📝 Final message:', finalMessage);

            // Close button
            closeBtn.addEventListener('click', () => {
                hideNotification(notification);
            });

            document.body.appendChild(notification);
            notification.offsetHeight; // reflow
            requestAnimationFrame(() => {
                notification.style.opacity = '1';
                notification.style.transform = 'translateX(0)';
                const textNode = notification.querySelector('.notification-text');
                console.log('🔍 After render - textNode:', textNode);
                console.log('🔍 After render - textContent:', textNode ? textNode.textContent : 'NULL');
                
                if (textNode) {
                    const currentText = textNode.textContent.trim().toLowerCase();
                    console.log('🔍 Current text lowercase:', currentText);
                    
                    if (currentText === 'false' || currentText === '[object object]') {
                        console.warn('[notify] ⚠️ Post-render bad text detected, fixing!');
                        const defaultMessages = {
                            success: 'Thêm khóa học vào giỏ hàng thành công! 🎉',
                            warning: 'Bạn đã đăng ký khóa học này rồi! Kiểm tra mục "Khóa học của tôi".',
                            info: 'Khóa học này đã có trong giỏ hàng của bạn.',
                            error: 'Có lỗi xảy ra. Vui lòng thử lại.'
                        };
                        textNode.textContent = defaultMessages[type] || defaultMessages.info;
                        console.log('✅ Fixed to:', textNode.textContent);
                    }
                }
            });

            // Auto hide
            const ttl = 5000;
            const autoTimer = setTimeout(() => hideNotification(notification), ttl);
            notification.addEventListener('mouseenter', () => {
                clearTimeout(autoTimer); // pause on hover
            });
        }

        function hideNotification(el) {
            if (! el) return;
            el.style.opacity = '0';
            el.style.transform = 'translateX(400px)';
            setTimeout(() => el.remove(), 400);
        }

        // MutationObserver to catch rogue 'false' text nodes created elsewhere
        const debugFalseObserver = new MutationObserver(mutations => {
            mutations.forEach(m => {
                m.addedNodes.forEach(node => {
                    if (node.nodeType === 1) { // element
                        const text = node.textContent && node.textContent.trim();
                        if (text === 'false' && !node.classList.contains('custom-notification')) {
                            console.warn('[notify] Removing rogue false element:', node);
                            node.remove();
                        }
                    }
                });
            });
        });
        debugFalseObserver.observe(document.body, { childList: true, subtree: true });

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
        /* ========================================
           NOTIFICATION STYLES - INLINE
           ======================================== */
        .notification {
            position: fixed !important;
            top: 30px !important;
            right: 30px !important;
            min-width: 350px !important;
            max-width: 450px !important;
            padding: 22px 28px !important;
            border-radius: 16px !important;
            display: flex !important;
            align-items: center !important;
            gap: 18px !important;
            font-size: 1.05rem !important;
            font-weight: 600 !important;
            line-height: 1.5 !important;
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.4), 0 5px 15px rgba(0, 0, 0, 0.3) !important;
            z-index: 999999 !important;
            opacity: 0 !important;
            transform: translateX(500px) !important;
            transition: all 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55) !important;
            pointer-events: none !important;
        }

        .notification.show {
            opacity: 1 !important;
            transform: translateX(0) !important;
            pointer-events: auto !important;
        }

        .notification i {
            font-size: 1.8rem !important;
            flex-shrink: 0 !important;
            display: block !important;
            color: #ffffff !important;
        }

        .notification span {
            flex: 1 !important;
            display: block !important;
            line-height: 1.6 !important;
            color: #ffffff !important;
        }

        /* Success - Green */
        .notification-success {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%) !important;
        }

        /* Warning - Yellow/Orange */
        .notification-warning {
            background: linear-gradient(135deg, #f5af19 0%, #f12711 100%) !important;
        }

        /* Error - Red */
        .notification-error {
            background: linear-gradient(135deg, #f85032 0%, #e73827 100%) !important;
        }

        /* Info - Blue */
        .notification-info {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
        }

        /* Responsive */
        @media (max-width: 576px) {
            .notification {
                min-width: auto !important;
                max-width: calc(100% - 40px) !important;
                right: 20px !important;
                left: 20px !important;
                font-size: 0.95rem !important;
                padding: 18px 22px !important;
            }
            
            .notification i {
                font-size: 1.5rem !important;
            }
        }
        
        /* ========================================
           INSTRUCTOR CARD STYLES
           ======================================== */
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
    
    <!-- Edit Review Modal -->
    <div class="modal fade" id="editReviewModal" tabindex="-1" aria-labelledby="editReviewModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editReviewModalLabel">
                        <i class="fa-solid fa-edit"></i> Chỉnh sửa đánh giá
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="editReviewForm" action="${pageContext.request.contextPath}/manage-review" method="POST">
                    <input type="hidden" name="action" value="edit" />
                    <input type="hidden" name="reviewId" id="editReviewId" />
                    <input type="hidden" name="courseId" value="${course.id}" />
                    
                    <div class="modal-body">
                        <div class="form-group mb-3">
                            <label class="form-label">Đánh giá của bạn <span class="text-danger">*</span></label>
                            <div class="rating-input" id="editRatingInput">
                                <input type="radio" name="rating" value="5" id="editStar5" required />
                                <label for="editStar5" title="5 sao"><i class="fa-solid fa-star"></i></label>
                                
                                <input type="radio" name="rating" value="4" id="editStar4" />
                                <label for="editStar4" title="4 sao"><i class="fa-solid fa-star"></i></label>
                                
                                <input type="radio" name="rating" value="3" id="editStar3" />
                                <label for="editStar3" title="3 sao"><i class="fa-solid fa-star"></i></label>
                                
                                <input type="radio" name="rating" value="2" id="editStar2" />
                                <label for="editStar2" title="2 sao"><i class="fa-solid fa-star"></i></label>
                                
                                <input type="radio" name="rating" value="1" id="editStar1" />
                                <label for="editStar1" title="1 sao"><i class="fa-solid fa-star"></i></label>
                            </div>
                        </div>
                        
                        <div class="form-group mb-3">
                            <label for="editReviewContent" class="form-label">Nội dung đánh giá <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="editReviewContent" name="content" rows="4" 
                                      placeholder="Chia sẻ trải nghiệm của bạn về khóa học này..." required></textarea>
                        </div>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fa-solid fa-save"></i> Lưu thay đổi
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        // Event listeners for edit buttons
        document.addEventListener('DOMContentLoaded', function() {
            // Edit review buttons
            const editButtons = document.querySelectorAll('.btn-edit-review');
            editButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const reviewId = this.getAttribute('data-review-id');
                    const rating = this.getAttribute('data-rating');
                    const content = this.getAttribute('data-content');
                    openEditModal(reviewId, rating, content);
                });
            });
            
            // Delete review buttons
            const deleteButtons = document.querySelectorAll('.btn-delete-review');
            deleteButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const reviewId = this.getAttribute('data-review-id');
                    const courseId = this.getAttribute('data-course-id');
                    confirmDelete(reviewId, courseId);
                });
            });
        });
        
        // Open edit modal and populate data
        function openEditModal(reviewId, rating, content) {
            document.getElementById('editReviewId').value = reviewId;
            document.getElementById('editReviewContent').value = content;
            
            // Set rating
            document.getElementById('editStar' + rating).checked = true;
            
            // Show modal
            const modal = new bootstrap.Modal(document.getElementById('editReviewModal'));
            modal.show();
        }
        
        // Confirm delete
        function confirmDelete(reviewId, courseId) {
            if (confirm('Bạn có chắc chắn muốn xóa đánh giá này?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/manage-review';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const reviewIdInput = document.createElement('input');
                reviewIdInput.type = 'hidden';
                reviewIdInput.name = 'reviewId';
                reviewIdInput.value = reviewId;
                
                const courseIdInput = document.createElement('input');
                courseIdInput.type = 'hidden';
                courseIdInput.name = 'courseId';
                courseIdInput.value = courseId;
                
                form.appendChild(actionInput);
                form.appendChild(reviewIdInput);
                form.appendChild(courseIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
