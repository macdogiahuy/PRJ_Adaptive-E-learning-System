<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.DashboardData"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Adaptive Elearning</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
       <nav class="sidebar">
            <div class="sidebar-header">
                <h3>DashBoard</h3>
            </div>
            <ul class="nav-menu">
                <li class="nav-item active">
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
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fas fa-flag"></i>
                        <span>Reported Groups</span>
                    </a>
                </li>
                <li class="nav-item">
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

        <!-- Main Content -->
        <main class="main-content">
            <div class="content-header">
                <h1>Dashboard</h1>
            </div>

            <!-- Top Cards Row -->
            <div class="cards-row">
                <div class="card">
                    <div class="card-icon users-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="card-content">
                        <h3>Users</h3>
                        <div class="card-number">${totalUsers}</div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-icon notifications-icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    <div class="card-content">
                        <h3>Notifications</h3>
                        <div class="card-number">${totalNotifications}</div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-icon admin-icon">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <div class="card-content">
                        <h3>Create Admin</h3>
                        <div class="card-number">Admin</div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-icon courses-icon">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="card-content">
                        <h3>Courses</h3>
                        <div class="card-number">${totalCourses}</div>
                    </div>
                </div>
            </div>

            <!-- Learning Groups Card -->
            <div class="learning-groups-card">
                <div class="card large-card">
                    <div class="card-icon learning-groups-icon">
                        <i class="fas fa-users-cog"></i>
                    </div>
                    <div class="card-content">
                        <h3>Learning Groups</h3>
                        <div class="card-number">${totalLearningGroups}</div>
                    </div>
                </div>
            </div>

            <!-- Chart Section -->
            <div class="chart-section">
                <div class="card chart-card">
                    <div class="card-header">
                        <h3>Statistical Chart</h3>
                    </div>
                    <div class="chart-content">
                        <div class="chart-placeholder">
                            <div class="chart-bar">
                                <div class="chart-label">Data Values</div>
                                <div class="bar-container">
                                    <div class="bar" style="height: 60%;"></div>
                                    <div class="bar-value">0</div>
                                </div>
                            </div>
                            <div class="chart-bar">
                                <div class="chart-label">Users</div>
                                <div class="bar-container">
                                    <div class="bar" style="height: 80%;"></div>
                                    <div class="bar-value">${totalUsers}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>
