<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Course Marketplace</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/market.css">
</head>
<body>
<div class="container">
    <!-- Sidebar -->
    <aside class="sidebar">
        <h3>Categories</h3>
        <ul>
            <li><a href="#" data-category="All">All</a></li>
            <li><a href="#" data-category="Development">Development</a></li>
            <li><a href="#" data-category="Marketing">Marketing</a></li>
            <li><a href="#" data-category="Business">Business</a></li>
            <li><a href="#" data-category="Lifestyle">Lifestyle</a></li>
            <li><a href="#" data-category="Personal Development">Personal Development</a></li>
            <li><a href="#" data-category="Finance & Accounting">Finance & Accounting</a></li>
            <li><a href="#" data-category="IT & Software">IT & Software</a></li>
        </ul>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="content-header">
            <input type="text" id="searchBox" placeholder="🔍 Search courses..." class="search-box">
        </div>

        <div class="sort-bar">
            <a href="#" data-sort="newest">Newest</a>
            <a href="#" data-sort="rating">Average Rating</a>
            <a href="#" data-sort="price">Price</a>
            <a href="#" data-sort="discount">Discount</a>
        </div>

        <div class="course-grid">
            <c:forEach var="c" items="${courses}">
                <div class="course-card" 
                     data-createdat="${c.createdAt}" 
                     data-category="${c.category}">
                    <img src="${c.thumbnail}" alt="${c.title}">
                    <h4>${c.title}</h4>
                    <p>${c.instructor}</p>
                    <p class="price">
                        <c:if test="${c.discount > 0}">
                            <span class="old-price">${c.price}đ</span>
                            <span class="new-price">${c.price - c.discount}đ</span>
                        </c:if>
                        <c:if test="${c.discount == 0}">
                            <span class="new-price">${c.price}đ</span>
                        </c:if>
                    </p>
                    <p>⭐ <span class="rating">${c.rating}</span> | 👥 ${c.studentsCount}</p>
                </div>
            </c:forEach>
        </div>

        <!-- Pagination -->
        <div class="pagination">
            <a href="#">1</a>
            <a href="#">2</a>
            <a href="#">3</a>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/market.js"></script>
</body>
</html>
