<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Courses - Adaptive Elearning</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/courses.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <h3>Adaptive_Elearning</h3>
            </div>
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="dashboard.jsp" class="nav-link">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item active">
                    <a href="courses.jsp" class="nav-link">
                        <i class="fas fa-book"></i>
                        <span>Courses</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Learning Groups</span>
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
                <h1>Enrolled Courses</h1>
                <input type="text" id="courseSearch" placeholder="🔍 Search courses..." class="search-box">
            </div>

            <!-- Courses Table -->
            <div class="courses-section">
                <table class="course-table">
                    <thead>
                        <tr>
                            <th>Course Title</th>
                            <th>Thumbnail</th>
                            <th>Instructor</th>
                            <th>Rating</th>
                            <th>Enrolled At</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${courses}">
                            <tr>
                                <td><a href="#">${c.title}</a></td>
                                <td><img src="${c.thumbnail}" alt="thumb" class="thumb"></td>
                                <td>${c.instructor}</td>
                                <td>${c.rating}</td>
                                <td>${c.enrolledAt}</td>
                                <td><span class="status ${c.status}">${c.status}</span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/courses.js"></script>
</body>
</html>
```

