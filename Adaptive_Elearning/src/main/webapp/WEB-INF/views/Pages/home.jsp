<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="controller.CourseManagementController"%>
<%@page import="controller.CourseManagementController.Course"%>
<%@page import="java.util.*"%>
<%@page import="model.Users"%>

<%
    // Dữ liệu courses, phân trang, tìm kiếm
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    String search = (String) request.getAttribute("search");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalCourses = (Integer) request.getAttribute("totalCourses");
    String errorMessage = (String) request.getAttribute("errorMessage");

    if (search == null) {
        search = "";
    }
    if (currentPage == null) {
        currentPage = 1;
    }
    if (totalPages == null) {
        totalPages = 1;
    }
    if (totalCourses == null) {
        totalCourses = 0;
    }

    Users u = null;
    if (session != null) {
        u = (Users) session.getAttribute("account");
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Trang chủ - Homepage</title>
        <link rel="stylesheet" href="assests/css/home.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Nút to hơn */
            .user-box{
                padding: 12px 18px;        /* ↑ tăng kích thước */
                font-size: 20px;           /* ↑ chữ lớn hơn */
                border-radius: 16px; /* bo tròn hơn */
                background-color: #c82333;
            }

            /* Container dropdown giữ đúng bề rộng nút */
            .dropdown{
                position: relative;
                display: inline-block;      /* chiều rộng = chiều rộng nút */
            }

            /* Menu: bằng đúng bề rộng nút */
            .dropdown-menu{
                display: none;
                position: absolute;
                left: 0;                    /* canh theo mép trái của .dropdown (nút) */
                right: auto;
                top: calc(100%);
                width: 100%;                /* = đúng bề rộng nút */
                padding: 10px 12px;
                background: #fff;
                border-radius: 14px;
                box-shadow: 0 14px 32px rgba(0,0,0,.18);
                z-index: 9999;

                opacity: 0;
                transform: translateY(-4px) scale(.98);
                transition: opacity .15s ease, transform .15s ease;
            }

            /* Hiện menu */
            .dropdown.open .dropdown-menu{
                display: block !important;
                opacity: 1;
                transform: translateY(0) scale(1);
            }

            /* Mũi tên nhỏ – vẫn bám cạnh phải của menu */
            .dropdown-menu::before{
                content: "";
                position: absolute;
                right: 16px;               /* chỉnh 8–24px cho đẹp */
                top: -7px;
                width: 12px;
                height: 12px;
                background: #fff;
                transform: rotate(45deg);
                box-shadow: -2px -2px 4px rgba(0,0,0,.03);
            }

            /* Item menu */
            .dropdown-menu a,
            .dropdown-menu a:visited{
                display: block;
                padding: 10px 8px;
                border-radius: 10px;
                color: #2b2b2b;
                text-decoration: none;
                font-weight: 600;
                font-size: 14px;
            }
            .dropdown-menu a:hover{
                background: #f5f6f8;
            }
        </style>
    </head>

    <body>
        <header class="page-header">
            <div class="top-nav d-flex justify-content-center py-2">
                <nav class="d-flex gap-4">
                    <a href="home" class="active">Home</a>
                    <a href="#">Courses</a>
                    <a href="#">Learning Groups</a>
                </nav>
            </div>

            <div class="middle-nav container-fluid d-flex justify-content-between align-items-center py-3">
                <img src="assets/images/logo.png" alt="Logo" style="height:50px;">

                <!-- Search form -->
                <form method="get" action="home" class="search-bar d-flex flex-grow-1 mx-4">
                    <input type="text" name="search" value="<%= search%>" placeholder="Search courses..." class="form-control rounded-start">
                    <button type="submit" class="btn btn-primary rounded-end"><i class="fas fa-search"></i> Search</button>
                </form>

                <!-- User Info -->
                <div class="user-actions">
                    <% if (u != null) {%>
                    <div class="dropdown">
                        <button type="button" class="user-box" id="userDropdownBtn" aria-haspopup="true" aria-expanded="false">
                            <span><%= u.getUserName()%></span>
                            <i class="fa fa-caret-down caret"></i>
                            <i class="fa fa-bell"></i>
                        </button>

                        <div class="dropdown-menu" id="dropdownMenu" role="menu" aria-labelledby="userDropdownBtn">
                            <a href="#">Các khóa học đã đăng ký</a>
                            <a href="#">Information</a>
                            <a href="/Adaptive_Elearning/login">Log out</a>
                        </div>
                    </div>
                    <% } else { %>
                    <a href="login" class="btn btn-danger">Sign In</a>
                    <% } %>
                </div>
            </div>
        </header>

        <main class="container my-4">
            <% if (errorMessage != null) {%>
            <div class="alert alert-danger"><%= errorMessage%></div>
            <% } %>

            <div class="feature-header">
                <h2>Khóa học nổi bật</h2>
            </div>

            <div class="courses-grid">
                <% if (courses != null && !courses.isEmpty()) {
                        for (Course c : courses) {%>
                <div class="course-card">
                    <div class="course-thumbnail">
                        <img src="<%= c.getThumbUrl() != null && !c.getThumbUrl().isEmpty() ? c.getThumbUrl() : "assets/images/default.jpg"%>" 
                             alt="<%= c.getTitle()%>" style="width:100%; height:100%; object-fit:cover;">
                    </div>
                    <div class="course-content">
                        <div class="course-title"><%= c.getTitle()%></div>
                        <div class="course-meta">
                            Trạng thái: <%= c.getStatus()%><br>
                            Cấp độ: <%= c.getLevel() != null ? c.getLevel() : "N/A"%><br>
                            Học viên: <%= c.getLearnerCount()%><br>
                            Đánh giá: <%= String.format("%.1f", c.getAverageRating())%> ★
                        </div>
                        <div class="course-footer">
                            <span class="price"><%= String.format("%,.0f", c.getPrice())%>₫</span>
                            <span class="status">
                                <%
                                    String st = c.getStatus();
                                    String text = "Đang diễn ra";
                                    if ("Off".equals(st))
                                        text = "Đã tắt";
                                    else if ("Completed".equals(st))
                                        text = "Hoàn thành";
                                    else if ("Draft".equals(st))
                                        text = "Bản nháp";
                                %>
                                <%= text%>
                            </span>
                        </div>
                    </div>
                </div>
                <%  }
                } else { %>
                <div class="text-center text-muted">Không tìm thấy khóa học nào</div>
                <% } %>
            </div>

            <!-- Pagination -->
            <% if (totalPages > 1) { %>
            <div class="pagination-container my-4">
                <div class="pagination d-flex gap-2 justify-content-center">
                    <% if (currentPage > 1) {%>
                    <a href="home?search=<%= java.net.URLEncoder.encode(search, "UTF-8")%>&page=<%= currentPage - 1%>" class="pagination-btn">&laquo; Trước</a>
                    <% } %>

                    <% for (int i = 1; i <= totalPages; i++) { %>
                    <% if (i == currentPage) {%>
                    <span class="pagination-number active"><%= i%></span>
                    <% } else {%>
                    <a href="home?search=<%= java.net.URLEncoder.encode(search, "UTF-8")%>&page=<%= i%>" class="pagination-number"><%= i%></a>
                    <% } %>
                    <% } %>

                    <% if (currentPage < totalPages) {%>
                    <a href="home?search=<%= java.net.URLEncoder.encode(search, "UTF-8")%>&page=<%= currentPage + 1%>" class="pagination-btn">Tiếp &raquo;</a>
                    <% } %>
                </div>
            </div>
            <% }%>
        </main>
        <script>
            // Gắn sự kiện sau khi DOM sẵn sàng
            document.addEventListener('DOMContentLoaded', function () {
                const dropdown = document.querySelector('.dropdown');
                const btn = document.getElementById('userDropdownBtn');

                if (!dropdown || !btn)
                    return;

                btn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    const isOpen = dropdown.classList.toggle('open');
                    btn.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
                    // Log để kiểm tra nhanh
                    console.log('Dropdown toggled:', isOpen);
                });

                // Click ra ngoài thì đóng
                document.addEventListener('click', function (e) {
                    if (!dropdown.classList.contains('open'))
                        return;
                    if (!dropdown.contains(e.target)) {
                        dropdown.classList.remove('open');
                        btn.setAttribute('aria-expanded', 'false');
                    }
                });

                // ESC để đóng
                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape' && dropdown.classList.contains('open')) {
                        dropdown.classList.remove('open');
                        btn.setAttribute('aria-expanded', 'false');
                    }
                });
            });
        </script>
    </body>
</html>
