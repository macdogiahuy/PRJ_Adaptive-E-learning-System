<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>

<%
    Users user = null;
    int cartCount = 0;
    if (session != null) {
        user = (Users) session.getAttribute("account");
        // Lấy số lượng giỏ hàng từ session
        java.util.Map<String, model.CartItem> cart = 
            (java.util.Map<String, model.CartItem>) session.getAttribute("cart");
        if (cart != null) {
            cartCount = cart.size();
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Về chúng tôi - FlyUp</title>
    <meta name="description" content="Tìm hiểu về FlyUp - nền tảng học trực tuyến hàng đầu Việt Nam với sứ mệnh mang giáo dục chất lượng đến mọi người.">
    
    <!-- CSS -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/Adaptive_Elearning/assets/css/home.css">
    
    <style>
        .about-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }
        
        .hero-section {
            text-align: center;
            padding: 4rem 0;
            background: #ff9e4f;
            border-radius: var(--radius-lg);
            margin-bottom: 4rem;
        }
        
        .hero-title {
            font-size: 3rem;
            font-weight: 800;
            color: var(--secondary-900);
            margin-bottom: 1rem;
            background: white;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .hero-subtitle {
            font-size: 1.25rem;
            color: white;   
            max-width: 600px;
            margin: 0 auto;
            line-height: 1.6;
        }
        
        .mission-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
            margin-bottom: 4rem;
            align-items: center;
        }
        
        .mission-content h2 {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--secondary-900);
            margin-bottom: 1.5rem;
        }
        
        .mission-content p {
            font-size: 1.1rem;
            line-height: 1.8;
            color: var(--secondary-600);
            margin-bottom: 1.5rem;
        }
        
        .mission-image {
            position: relative;
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-lg);
        }
        
        .mission-image img {
            width: 100%;
            height: 400px;
            object-fit: cover;
        }
        
        .stats-section {
            background: white;
            padding: 3rem;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            margin-bottom: 4rem;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
            text-align: center;
        }
        
        .stat-item {
            padding: 1.5rem;
        }
        
        .stat-number {
            font-size: 3rem;
            font-weight: 800;
            color: var(--primary-600);
            display: block;
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            font-size: 1.1rem;
            color: var(--secondary-600);
            font-weight: 500;
        }
        
        .values-section {
            margin-bottom: 4rem;
        }
        
        .section-title {
            text-align: center;
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--secondary-900);
            margin-bottom: 3rem;
        }
        
        .values-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }
        
        .value-card {
            background: white;
            padding: 2rem;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            text-align: center;
            transition: all var(--animate-duration);
        }
        
        .value-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }
        
        .value-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 1.5rem;
            background: var(--gradient-primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
        }
        
        .value-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--secondary-900);
            margin-bottom: 1rem;
        }
        
        .value-description {
            color: var(--secondary-600);
            line-height: 1.6;
        }
        
        .team-section {
            margin-bottom: 4rem;
        }
        
        .team-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }
        
        .team-card {
            background: white;
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            transition: all var(--animate-duration);
        }
        
        .team-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }
        
        .team-avatar {
            width: 100%;
            height: 250px;
            background: var(--gradient-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            color: white;
        }
        
        .team-info {
            padding: 1.5rem;
            text-align: center;
        }
        
        .team-name {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--secondary-900);
            margin-bottom: 0.5rem;
        }
        
        .team-role {
            color: var(--primary-600);
            font-weight: 500;
            margin-bottom: 1rem;
        }
        
        .team-description {
            color: var(--secondary-600);
            font-size: 0.9rem;
            line-height: 1.5;
        }
        
        .cta-section {
            background: var(--gradient-primary);
            color: white;
            padding: 4rem 2rem;
            border-radius: var(--radius-lg);
            text-align: center;
        }
        
        .cta-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        
        .cta-description {
            font-size: 1.1rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }
        
        .cta-button {
            background: white;
            color: var(--primary-600);
            padding: 1rem 2rem;
            border-radius: var(--radius-md);
            text-decoration: none;
            font-weight: 600;
            display: inline-block;
            transition: all var(--animate-duration);
        }
        
        .cta-button:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2rem;
            }
            
            .mission-section {
                grid-template-columns: 1fr;
                gap: 2rem;
            }
            
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .section-title {
                font-size: 2rem;
            }
            
            .cta-title {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <nav class="nav-container">
                <a href="/Adaptive_Elearning/" class="logo">
                    <i class="fas fa-graduation-cap"></i>
                    <span>FlyUp</span>
                </a>
                
                <div class="nav-menu">
                    <a href="/Adaptive_Elearning/" class="nav-link">Trang chủ</a>
                    <a href="/Adaptive_Elearning/courses" class="nav-link">Khóa học</a>
                    <a href="/Adaptive_Elearning/about" class="nav-link active">Giới thiệu</a>
                    <a href="/Adaptive_Elearning/contact" class="nav-link">Liên hệ</a>
                </div>
                
                <div class="nav-actions">
                    <% if (user != null) { %>
                        <a href="/Adaptive_Elearning/cart" class="cart-link">
                            <div class="cart-icon">
                                <i class="fas fa-shopping-cart"></i>
                                <span class="cart-badge" <% if (cartCount == 0) { %>style="display: none;"<% } %>><%= cartCount %></span>
                            </div>
                        </a>
                        <div class="user-dropdown">
                            <button class="user-menu-btn" type="button">
                                <div class="user-avatar">
                                    <% if (user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) { %>
                                        <img src="<%= user.getAvatarUrl() %>" alt="Avatar" class="avatar-img">
                                    <% } else { %>
                                        <i class="fas fa-user-circle"></i>
                                    <% } %>
                                </div>
                                <div class="user-info">
                                    <span class="user-name"><%= user.getUserName() %></span>
                                    <i class="fas fa-chevron-down dropdown-arrow"></i>
                                </div>
                            </button>
                            <div class="dropdown-menu">
                                <div class="dropdown-header">
                                    <div class="user-details">
                                        <% if (user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) { %>
                                            <img src="<%= user.getAvatarUrl() %>" alt="Avatar" class="dropdown-avatar">
                                        <% } else { %>
                                            <div class="dropdown-avatar-placeholder">
                                                <i class="fas fa-user-circle"></i>
                                            </div>
                                        <% } %>
                                        <div class="user-text">
                                            <div class="user-fullname"><%= user.getUserName() %></div>
                                            <div class="user-email"><%= user.getEmail() %></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="dropdown-divider"></div>
                                <div class="dropdown-items">
                                    <a href="/Adaptive_Elearning/dashboard" class="dropdown-item">
                                        <i class="fas fa-tachometer-alt"></i>
                                        <span>Dashboard</span>
                                    </a>
                                    <a href="/Adaptive_Elearning/my-courses" class="dropdown-item">
                                        <i class="fas fa-book"></i>
                                        <span>Khóa học đã đăng ký</span>
                                    </a>
                                    <a href="/Adaptive_Elearning/profile" class="dropdown-item">
                                        <i class="fas fa-user-edit"></i>
                                        <span>Chỉnh sửa hồ sơ</span>
                                    </a>
                                    <a href="/Adaptive_Elearning/settings" class="dropdown-item">
                                        <i class="fas fa-cog"></i>
                                        <span>Cài đặt</span>
                                    </a>
                                </div>
                                <div class="dropdown-divider"></div>
                                <div class="dropdown-items">
                                    <a href="/Adaptive_Elearning/logout" class="dropdown-item logout-item">
                                        <i class="fas fa-sign-out-alt"></i>
                                        <span>Đăng xuất</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    <% } else { %>
                        <a href="/Adaptive_Elearning/login" class="login-btn">Đăng nhập</a>
                        <a href="/Adaptive_Elearning/register" class="register-btn">Đăng ký</a>
                    <% } %>
                </div>
            </nav>
        </div>
    </header>

    <!-- Main Content -->
    <main class="about-container">
        <!-- Hero Section -->
     <section class="hero-section">
            <h1 class="hero-title">Về FlyUp</h1>
            <p class="hero-subtitle">
                Chúng tôi tin rằng giáo dục là chìa khóa mở ra tương lai. FlyUp ra đời với sứ mệnh 
                democratize education - mang giáo dục chất lượng cao đến tay mọi người, mọi lúc, mọi nơi.
            </p>
        </section>

        <!-- Mission Section -->
        <section class="mission-section">
            <div class="mission-content">
                <h2>Sứ mệnh của chúng tôi</h2>
                <p>
                    FlyUp được thành lập với mục tiêu cách mạng hóa cách mọi người học tập và phát triển kỹ năng. 
                    Chúng tôi kết nối học viên với các chuyên gia hàng đầu trong ngành, tạo ra một cộng đồng học tập 
                    sôi động và hiệu quả.
                </p>
                <p>
                    Với công nghệ tiên tiến và phương pháp giảng dạy hiện đại, chúng tôi cam kết mang đến trải nghiệm 
                    học tập tuyệt vời nhất, giúp mọi người đạt được mục tiêu nghề nghiệp và cá nhân của mình.
                </p>
            </div>
            <div class="mission-image">
                <img src="/Adaptive_Elearning/assets/images/mission.jpg" alt="Sứ mệnh FlyUp" 
                     onerror="this.src='https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'">
            </div>
        </section>

        <!-- Stats Section -->
        <section class="stats-section">
            <div class="stats-grid">
                <div class="stat-item">
                    <span class="stat-number">50,000+</span>
                    <span class="stat-label">Học viên</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">1,200+</span>
                    <span class="stat-label">Khóa học</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">500+</span>
                    <span class="stat-label">Giảng viên</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">98%</span>
                    <span class="stat-label">Hài lòng</span>
                </div>
            </div>
        </section>

        <!-- Values Section -->
        <section class="values-section">
            <h2 class="section-title">Giá trị cốt lõi</h2>
            <div class="values-grid">
                <div class="value-card">
                    <div class="value-icon">
                        <i class="fas fa-lightbulb"></i>
                    </div>
                    <h3 class="value-title">Đổi mới</h3>
                    <p class="value-description">
                        Chúng tôi không ngừng cải tiến và áp dụng công nghệ mới nhất để mang đến trải nghiệm học tập tốt nhất.
                    </p>
                </div>
                <div class="value-card">
                    <div class="value-icon">
                        <i class="fas fa-heart"></i>
                    </div>
                    <h3 class="value-title">Tận tâm</h3>
                    <p class="value-description">
                        Mỗi học viên đều quan trọng với chúng tôi. Chúng tôi cam kết hỗ trợ và đồng hành cùng bạn trong hành trình học tập.
                    </p>
                </div>
                <div class="value-card">
                    <div class="value-icon">
                        <i class="fas fa-award"></i>
                    </div>
                    <h3 class="value-title">Chất lượng</h3>
                    <p class="value-description">
                        Tất cả khóa học đều được kiểm duyệt kỹ lưỡng để đảm bảo nội dung chất lượng cao và cập nhật.
                    </p>
                </div>
                <div class="value-card">
                    <div class="value-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <h3 class="value-title">Cộng đồng</h3>
                    <p class="value-description">
                        Xây dựng cộng đồng học tập sôi động, nơi mọi người có thể chia sẻ kiến thức và hỗ trợ lẫn nhau.
                    </p>
                </div>
            </div>
        </section>

        <!-- Team Section -->
        <section class="team-section">
            <h2 class="section-title">Đội ngũ của chúng tôi</h2>
            <div class="team-grid">
                <div class="team-card">
                    <div class="team-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="team-info">
                        <h3 class="team-name">Nguyễn Văn An</h3>
                        <p class="team-role">CEO & Founder</p>
                        <p class="team-description">
                            Với hơn 15 năm kinh nghiệm trong lĩnh vực giáo dục và công nghệ, anh An đã dẫn dắt FlyUp trở thành nền tảng học tập hàng đầu.
                        </p>
                    </div>
                </div>
                <div class="team-card">
                    <div class="team-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="team-info">
                        <h3 class="team-name">Trần Thị Bình</h3>
                        <p class="team-role">CTO</p>
                        <p class="team-description">
                            Chuyên gia công nghệ với passion về AI và machine learning, chị Bình chịu trách nhiệm phát triển các tính năng thông minh của FlyUp.
                        </p>
                    </div>
                </div>
                <div class="team-card">
                    <div class="team-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="team-info">
                        <h3 class="team-name">Lê Minh Châu</h3>
                        <p class="team-role">Head of Education</p>
                        <p class="team-description">
                            Với background giáo dục học và tâm lý học, anh Châu đảm bảo chất lượng nội dung và phương pháp giảng dạy hiệu quả.
                        </p>
                    </div>
                </div>
            </div>
        </section>

        <!-- CTA Section -->
        <section class="cta-section">
            <h2 class="cta-title">Bắt đầu hành trình học tập của bạn</h2>
            <p class="cta-description">
                Tham gia cùng hàng nghìn học viên khác và khám phá tiềm năng của bản thân
            </p>
            <a href="/Adaptive_Elearning/" class="cta-button">
                Khám phá khóa học
            </a>
        </section>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-brand">
                    <h3>FlyUp</h3>
                    <p>Nền tảng học trực tuyến hàng đầu Việt Nam, mang đến những khóa học chất lượng cao với chi phí hợp lý.</p>
                </div>
                
                <div class="footer-section">
                    <h4 class="footer-title">Khóa học</h4>
                    <ul class="footer-links">
                        <li><a href="#">Lập trình</a></li>
                        <li><a href="#">Thiết kế</a></li>
                        <li><a href="#">Marketing</a></li>
                        <li><a href="#">Kinh doanh</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h4 class="footer-title">Hỗ trợ</h4>
                    <ul class="footer-links">
                        <li><a href="#">Trung tâm trợ giúp</a></li>
                        <li><a href="#">Liên hệ</a></li>
                        <li><a href="#">Câu hỏi thường gặp</a></li>
                        <li><a href="#">Báo cáo lỗi</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h4 class="footer-title">Kết nối</h4>
                    <ul class="footer-links">
                        <li><a href="#"><i class="fab fa-facebook"></i> Facebook</a></li>
                        <li><a href="#"><i class="fab fa-youtube"></i> YouTube</a></li>
                        <li><a href="#"><i class="fab fa-linkedin"></i> LinkedIn</a></li>
                        <li><a href="#"><i class="fab fa-twitter"></i> Twitter</a></li>
                    </ul>
                </div>
            </div>
            
            <div style="text-align: center; padding-top: 2rem; border-top: 1px solid #374151; display: flex; justify-content: center; align-items: center; gap: 30px; flex-wrap: wrap;">
                <p>&copy; 2024 FlyUp. Tất cả quyền được bảo lưu.</p>
                <%@ include file="/WEB-INF/components/online-users-counter.jsp" %>
            </div>
        </div>
    </footer>

    <!-- JavaScript -->
    <script>
        // User dropdown functionality
        document.addEventListener('DOMContentLoaded', function() {
            const userMenuBtn = document.querySelector('.user-menu-btn');
            const dropdownMenu = document.querySelector('.user-dropdown .dropdown-menu');
            
            if (userMenuBtn && dropdownMenu) {
                userMenuBtn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    dropdownMenu.classList.toggle('show');
                    
                    // Rotate arrow
                    const arrow = this.querySelector('.dropdown-arrow');
                    if (arrow) {
                        arrow.style.transform = dropdownMenu.classList.contains('show') 
                            ? 'rotate(180deg)' 
                            : 'rotate(0deg)';
                    }
                });
                
                // Close dropdown when clicking outside
                document.addEventListener('click', function(e) {
                    if (!userMenuBtn.contains(e.target) && !dropdownMenu.contains(e.target)) {
                        dropdownMenu.classList.remove('show');
                        const arrow = userMenuBtn.querySelector('.dropdown-arrow');
                        if (arrow) {
                            arrow.style.transform = 'rotate(0deg)';
                        }
                    }
                });
            }
        });

        // Animate stats on scroll
        const observerOptions = {
            threshold: 0.5,
            once: true
        };

        const statsObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const statNumbers = entry.target.querySelectorAll('.stat-number');
                    statNumbers.forEach(stat => {
                        const finalValue = stat.textContent;
                        const numericValue = parseInt(finalValue.replace(/[^0-9]/g, ''));
                        animateNumber(stat, 0, numericValue, finalValue.includes('%') ? '%' : '+', 2000);
                    });
                }
            });
        }, observerOptions);

        const statsSection = document.querySelector('.stats-section');
        if (statsSection) {
            statsObserver.observe(statsSection);
        }

        function animateNumber(element, start, end, suffix, duration) {
            const startTime = performance.now();
            
            function updateNumber(currentTime) {
                const elapsed = currentTime - startTime;
                const progress = Math.min(elapsed / duration, 1);
                
                const current = Math.floor(start + (end - start) * progress);
                element.textContent = current.toLocaleString() + suffix;
                
                if (progress < 1) {
                    requestAnimationFrame(updateNumber);
                }
            }
            
            requestAnimationFrame(updateNumber);
        }
    </script>
</body>
</html>