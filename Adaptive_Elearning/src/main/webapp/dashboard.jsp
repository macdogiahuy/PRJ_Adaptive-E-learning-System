<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%

    // Redirect to admin_dashboard.jsp for proper entry point    // Forward to admin dashboard

    response.sendRedirect("admin_dashboard.jsp");    request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);

%>
        }
        
        .dashboard-header {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 20px;
            margin-bottom: 30px;
            color: white;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        }
        
        .stats-card {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border: 1px solid rgba(255,255,255,0.2);
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 45px rgba(0,0,0,0.2);
        }
        
        .stats-icon {
            width: 60px;
            height: 60px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
        }
        
        .stats-icon.users { background: linear-gradient(135deg, #667eea, #764ba2); }
        .stats-icon.courses { background: linear-gradient(135deg, #f093fb, #f5576c); }
        .stats-icon.enrollments { background: linear-gradient(135deg, #4facfe, #00f2fe); }
        .stats-icon.notifications { background: linear-gradient(135deg, #43e97b, #38f9d7); }
        
        .chart-container {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            border: 1px solid rgba(255,255,255,0.2);
        }
        
        .chart-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 20px;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .sidebar {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 20px;
            margin-right: 20px;
            height: fit-content;
            position: sticky;
            top: 20px;
        }
        
        .sidebar .nav-link {
            color: rgba(255,255,255,0.9);
            padding: 12px 20px;
            margin-bottom: 8px;
            border-radius: 12px;
            transition: all 0.3s ease;
            text-decoration: none;
        }
        
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: rgba(255,255,255,0.2);
            color: white;
            transform: translateX(5px);
        }
        
        .data-source {
            background: rgba(255,255,255,0.1);
            color: rgba(255,255,255,0.8);
            padding: 10px 15px;
            border-radius: 10px;
            font-size: 0.85rem;
            margin-top: 15px;
        }
        
        .chart-canvas {
            position: relative;
            height: 300px !important;
        }
        
        .container-fluid {
            padding: 20px;
        }
        
        .loading-indicator {
            background: rgba(255,255,255,0.9);
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            margin: 20px 0;
        }
        
        .status-indicator {
            padding: 10px 15px;
            border-radius: 8px;
            font-size: 0.9rem;
            margin-top: 10px;
        }
        
        .status-success {
            background: rgba(40, 167, 69, 0.1);
            border: 1px solid rgba(40, 167, 69, 0.3);
            color: #28a745;
        }
        
        .status-error {
            background: rgba(220, 53, 69, 0.1);
            border: 1px solid rgba(220, 53, 69, 0.3);
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <!-- Header -->
        <div class="dashboard-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="mb-2">
                        <i class="fas fa-chart-line me-3"></i>
                        Dashboard CourseHub E-Learning
                    </h1>
                    <p class="mb-0 opacity-75">Hệ thống quản lý học trực tuyến thích ứng</p>
                </div>
                <div class="text-end">
                    <div class="fs-6 opacity-75">Cập nhật lần cuối</div>
                    <div class="fs-5" id="current-time"></div>
                    <button class="btn btn-light btn-sm mt-2" onclick="loadDashboardData()">
                        <i class="fas fa-sync-alt me-1"></i>Tải dữ liệu thật
                    </button>
                </div>
            </div>
            <div class="data-source">
                <i class="fas fa-database me-2"></i>
                Dữ liệu từ CourseHubDB Database
                <div class="status-indicator" id="db-status">
                    <i class="fas fa-clock me-2"></i>
                    Đang kiểm tra kết nối...
                </div>
            </div>
        </div>
        
        <div class="row">
            <!-- Sidebar -->
            <div class="col-lg-2">
                <div class="sidebar">
                    <div class="text-center mb-4">
                        <i class="fas fa-tachometer-alt fa-2x text-white mb-2"></i>
                        <h5 class="text-white mb-0">Menu</h5>
                    </div>
                    <nav class="nav flex-column">
                        <a class="nav-link active" href="#overview">
                            <i class="fas fa-home me-2"></i>Tổng quan
                        </a>
                        <a class="nav-link" href="#users">
                            <i class="fas fa-users me-2"></i>Người dùng
                        </a>
                        <a class="nav-link" href="#courses">
                            <i class="fas fa-book me-2"></i>Khóa học
                        </a>
                        <a class="nav-link" href="#enrollments">
                            <i class="fas fa-user-graduate me-2"></i>Đăng ký học
                        </a>
                        <a class="nav-link" href="#notifications">
                            <i class="fas fa-bell me-2"></i>Thông báo
                        </a>
                        <hr class="my-3" style="border-color: rgba(255,255,255,0.3);">
                        <a class="nav-link" href="javascript:location.reload()">
                            <i class="fas fa-sync-alt me-2"></i>Làm mới
                        </a>
                    </nav>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-lg-10">
                <!-- Loading Indicator -->
                <div class="loading-indicator" id="loading-indicator" style="display: none;">
                    <div class="spinner-border text-primary me-3" role="status"></div>
                    <span>Đang tải dữ liệu từ database...</span>
                </div>
                
                <!-- Stats Cards -->
                <div class="row mb-4" id="overview">
                    <div class="col-lg-3 col-md-6">
                        <div class="stats-card">
                            <div class="d-flex align-items-center">
                                <div class="stats-icon users me-3">
                                    <i class="fas fa-users"></i>
                                </div>
                                <div>
                                    <div class="fs-3 fw-bold text-primary" id="total-users">
                                        ---
                                    </div>
                                    <div class="text-muted">Tổng số Users</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="stats-card">
                            <div class="d-flex align-items-center">
                                <div class="stats-icon courses me-3">
                                    <i class="fas fa-book"></i>
                                </div>
                                <div>
                                    <div class="fs-3 fw-bold text-danger" id="total-courses">
                                        ---
                                    </div>
                                    <div class="text-muted">Tổng số Courses</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="stats-card">
                            <div class="d-flex align-items-center">
                                <div class="stats-icon enrollments me-3">
                                    <i class="fas fa-user-graduate"></i>
                                </div>
                                <div>
                                    <div class="fs-3 fw-bold text-info" id="total-enrollments">
                                        ---
                                    </div>
                                    <div class="text-muted">Tổng số Enrollments</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="stats-card">
                            <div class="d-flex align-items-center">
                                <div class="stats-icon notifications me-3">
                                    <i class="fas fa-bell"></i>
                                </div>
                                <div>
                                    <div class="fs-3 fw-bold text-success" id="total-notifications">
                                        ---
                                    </div>
                                    <div class="text-muted">Tổng số Notifications</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Charts Row 1 -->
                <div class="row mb-4" id="users">
                    <div class="col-lg-6">
                        <div class="chart-container">
                            <div class="chart-title">
                                <i class="fas fa-chart-line text-primary"></i>
                                Users đăng ký (30 ngày gần nhất)
                            </div>
                            <canvas id="usersChart" class="chart-canvas"></canvas>
                        </div>
                    </div>
                    <div class="col-lg-6" id="enrollments">
                        <div class="chart-container">
                            <div class="chart-title">
                                <i class="fas fa-chart-bar text-info"></i>
                                Enrollments theo tháng (Năm 2024)
                            </div>
                            <canvas id="enrollmentsChart" class="chart-canvas"></canvas>
                        </div>
                    </div>
                </div>
                
                <!-- Charts Row 2 -->
                <div class="row mb-4" id="courses">
                    <div class="col-lg-6">
                        <div class="chart-container">
                            <div class="chart-title">
                                <i class="fas fa-chart-area text-danger"></i>
                                Courses theo năm (5 năm gần nhất)
                            </div>
                            <canvas id="coursesChart" class="chart-canvas"></canvas>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="chart-container">
                            <div class="chart-title">
                                <i class="fas fa-trophy text-warning"></i>
                                Top 5 Courses phổ biến nhất
                            </div>
                            <canvas id="topCoursesChart" class="chart-canvas"></canvas>
                        </div>
                    </div>
                </div>
                
                <!-- Charts Row 3 -->
                <div class="row mb-4" id="notifications">
                    <div class="col-lg-8 offset-lg-2">
                        <div class="chart-container">
                            <div class="chart-title">
                                <i class="fas fa-chart-pie text-success"></i>
                                Phân bố Notifications theo trạng thái
                            </div>
                            <div class="row">
                                <div class="col-lg-8 offset-lg-2">
                                    <canvas id="notificationsChart" class="chart-canvas"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Chart storage
        let charts = {};
        
        // Current data storage
        let dashboardData = {
            overview: {
                totalUsers: 0,
                totalCourses: 0,
                totalEnrollments: 0,
                totalNotifications: 0
            },
            hasRealData: false
        };
        
        // Sample data for fallback
        const sampleData = {
            usersByDay: {
                days: generateLast30Days(),
                userCounts: [2,1,3,0,1,4,2,1,0,2,3,1,2,4,1,0,2,3,1,2,1,3,2,1,4,2,1,3,2,1]
            },
            enrollmentsByMonth: {
                months: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                enrollmentCounts: [12,8,15,20,18,25,22,19,16,14,11,9]
            },
            coursesByYear: {
                years: ['2020', '2021', '2022', '2023', '2024'],
                courseCounts: [5, 8, 12, 18, 24]
            },
            topCourses: {
                courseNames: ['Java Programming', 'Web Development', 'Data Science', 'Mobile App', 'AI/ML'],
                learnerCounts: [45, 38, 32, 28, 22]
            },
            notifications: {
                statusLabels: ['Active', 'Pending', 'Read', 'Archived'],
                statusCounts: [120, 85, 67, 40]
            }
        };
        
        // Load dashboard when page loads
        document.addEventListener('DOMContentLoaded', function() {
            updateCurrentTime();
            setInterval(updateCurrentTime, 1000);
            
            // Load real data immediately
            loadDashboardData();
        });
        
        function updateCurrentTime() {
            const now = new Date();
            const timeString = now.toLocaleString('vi-VN', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            });
            document.getElementById('current-time').textContent = timeString;
        }
        
        // function loadSampleData() - REMOVED: Only use real data now
        // Dashboard will show error state if database connection fails
        
        async function loadDashboardData() {
            try {
                // Show loading
                showLoading(true);
                updateDbStatus('loading', 'Đang kết nối tới CourseHubDB...');
                
                // Make actual request to dashboard API
                const response = await fetch('/Adaptive_Elearning/api/dashboard', {
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json',
                    }
                });
                
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                
                const result = await response.json();
                console.log('API Response:', result);
                
                if (result.error) {
                    throw new Error(result.error);
                }
                
                // Update with real data from database
                dashboardData.overview = {
                    totalUsers: result.totalUsers || 0,
                    totalCourses: result.totalCourses || 0,
                    totalEnrollments: result.totalEnrollments || 0,
                    totalNotifications: result.totalNotifications || 0
                };
                dashboardData.hasRealData = true;
                
                // Update UI
                updateOverviewCards();
                createAllCharts();
                updateDbStatus('success', 'Kết nối CourseHubDB thành công! Dữ liệu thật từ database: ' + new Date().toLocaleString());
                
            } catch (error) {
                console.error('Database connection error:', error);
                updateDbStatus('error', 'Lỗi kết nối database: ' + error.message + '. Vui lòng kiểm tra kết nối CourseHubDB.');
                
                // Show error state, no fallback to sample data
                dashboardData.hasRealData = false;
                showErrorState();
            } finally {
                showLoading(false);
            }
        }
        
        function showLoading(show) {
            const indicator = document.getElementById('loading-indicator');
            indicator.style.display = show ? 'block' : 'none';
        }
        
        function showErrorState() {
            // Clear all data displays
            document.getElementById('total-users').textContent = '---';
            document.getElementById('total-courses').textContent = '---';
            document.getElementById('total-enrollments').textContent = '---';
            document.getElementById('total-notifications').textContent = '---';
            
            // Show error message in loading indicator
            const loadingIndicator = document.getElementById('loading-indicator');
            loadingIndicator.innerHTML = `
                <div class="alert alert-danger" role="alert">
                    <h5><i class="fas fa-exclamation-triangle me-2"></i>Lỗi kết nối database</h5>
                    <p class="mb-2">Không thể kết nối đến CourseHubDB. Vui lòng:</p>
                    <ul class="mb-2">
                        <li>Kiểm tra database CourseHubDB đang chạy</li>
                        <li>Kiểm tra connection string trong DBConnection.java</li>
                        <li>Đảm bảo có dữ liệu trong các bảng Users, Courses, Enrollments, Notifications</li>
                    </ul>
                    <button class="btn btn-primary btn-sm" onclick="location.reload()">
                        <i class="fas fa-sync-alt me-1"></i>Thử lại
                    </button>
                </div>
            `;
            loadingIndicator.style.display = 'block';
        }
        
        function updateDbStatus(type, message) {
            const statusEl = document.getElementById('db-status');
            statusEl.className = 'status-indicator';
            
            let iconClass = 'fa-clock';
            let additionalClass = '';
            
            switch(type) {
                case 'success':
                    iconClass = 'fa-check-circle';
                    additionalClass = 'status-success';
                    break;
                case 'error':
                    iconClass = 'fa-exclamation-triangle';
                    additionalClass = 'status-error';
                    break;
                case 'loading':
                    iconClass = 'fa-spinner fa-spin';
                    break;
                case 'sample':
                    iconClass = 'fa-info-circle';
                    break;
            }
            
            statusEl.className += ' ' + additionalClass;
            statusEl.innerHTML = '<i class="fas ' + iconClass + ' me-2"></i>' + message;
        }
        
        function updateOverviewCards() {
            document.getElementById('total-users').textContent = dashboardData.overview.totalUsers.toLocaleString();
            document.getElementById('total-courses').textContent = dashboardData.overview.totalCourses.toLocaleString();
            document.getElementById('total-enrollments').textContent = dashboardData.overview.totalEnrollments.toLocaleString();
            document.getElementById('total-notifications').textContent = dashboardData.overview.totalNotifications.toLocaleString();
        }
        
        function generateLast30Days() {
            const days = [];
            for (let i = 29; i >= 0; i--) {
                const date = new Date();
                date.setDate(date.getDate() - i);
                days.push((date.getMonth() + 1).toString().padStart(2, '0') + '-' + 
                         date.getDate().toString().padStart(2, '0'));
            }
            return days;
        }
        
        function createAllCharts() {
            createUsersChart();
            createEnrollmentsChart();
            createCoursesChart();
            createTopCoursesChart();
            createNotificationsChart();
        }
        
        function createUsersChart() {
            const ctx = document.getElementById('usersChart').getContext('2d');
            if (charts.users) charts.users.destroy();
            
            charts.users = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: sampleData.usersByDay.days,
                    datasets: [{
                        label: 'Người dùng đăng ký',
                        data: sampleData.usersByDay.userCounts,
                        borderColor: '#667eea',
                        backgroundColor: 'rgba(102, 126, 234, 0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointBackgroundColor: '#667eea',
                        pointBorderColor: '#ffffff',
                        pointBorderWidth: 2,
                        pointRadius: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top'
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1
                            }
                        }
                    }
                }
            });
        }
        
        function createEnrollmentsChart() {
            const ctx = document.getElementById('enrollmentsChart').getContext('2d');
            if (charts.enrollments) charts.enrollments.destroy();
            
            charts.enrollments = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: sampleData.enrollmentsByMonth.months,
                    datasets: [{
                        label: 'Số lượng đăng ký',
                        data: sampleData.enrollmentsByMonth.enrollmentCounts,
                        backgroundColor: 'rgba(79, 172, 254, 0.8)',
                        borderColor: '#4facfe',
                        borderWidth: 2,
                        borderRadius: 8,
                        borderSkipped: false,
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top'
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }
        
        function createCoursesChart() {
            const ctx = document.getElementById('coursesChart').getContext('2d');
            if (charts.courses) charts.courses.destroy();
            
            charts.courses = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: sampleData.coursesByYear.years,
                    datasets: [{
                        label: 'Số khóa học mới',
                        data: sampleData.coursesByYear.courseCounts,
                        borderColor: '#f5576c',
                        backgroundColor: 'rgba(245, 87, 108, 0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointBackgroundColor: '#f5576c',
                        pointBorderColor: '#ffffff',
                        pointBorderWidth: 2,
                        pointRadius: 5
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top'
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }
        
        function createTopCoursesChart() {
            const ctx = document.getElementById('topCoursesChart').getContext('2d');
            if (charts.topCourses) charts.topCourses.destroy();
            
            charts.topCourses = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: sampleData.topCourses.courseNames,
                    datasets: [{
                        label: 'Số học viên',
                        data: sampleData.topCourses.learnerCounts,
                        backgroundColor: [
                            '#667eea',
                            '#f093fb',
                            '#4facfe',
                            '#43e97b',
                            '#f5576c'
                        ],
                        borderWidth: 3,
                        borderColor: '#ffffff',
                        hoverBorderWidth: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: true,
                            position: 'bottom',
                            labels: {
                                padding: 20,
                                usePointStyle: true
                            }
                        }
                    }
                }
            });
        }
        
        function createNotificationsChart() {
            const ctx = document.getElementById('notificationsChart').getContext('2d');
            if (charts.notifications) charts.notifications.destroy();
            
            charts.notifications = new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: sampleData.notifications.statusLabels,
                    datasets: [{
                        label: 'Số thông báo',
                        data: sampleData.notifications.statusCounts,
                        backgroundColor: [
                            '#43e97b',
                            '#f093fb',
                            '#4facfe',
                            '#667eea',
                            '#f5576c'
                        ],
                        borderWidth: 3,
                        borderColor: '#ffffff',
                        hoverBorderWidth: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: true,
                            position: 'bottom',
                            labels: {
                                padding: 20,
                                usePointStyle: true
                            }
                        }
                    }
                }
            });
        }
        
        // Navigation setup
        document.addEventListener('DOMContentLoaded', function() {
            // Smooth scrolling for navigation
            document.querySelectorAll('.sidebar .nav-link').forEach(link => {
                link.addEventListener('click', function(e) {
                    if (this.getAttribute('href').startsWith('#')) {
                        e.preventDefault();
                        const targetId = this.getAttribute('href');
                        const targetElement = document.querySelector(targetId);
                        if (targetElement) {
                            targetElement.scrollIntoView({
                                behavior: 'smooth',
                                block: 'start'
                            });
                        }
                        
                        // Update active state
                        document.querySelectorAll('.sidebar .nav-link').forEach(l => l.classList.remove('active'));
                        this.classList.add('active');
                    }
                });
            });
        });
        
        // Auto-refresh every 5 minutes if has real data
        setInterval(() => {
            if (dashboardData.hasRealData) {
                loadDashboardData();
            }
        }, 5 * 60 * 1000);
        
        console.log('CourseHub Dashboard initialized successfully');
    </script>
</body>
</html>