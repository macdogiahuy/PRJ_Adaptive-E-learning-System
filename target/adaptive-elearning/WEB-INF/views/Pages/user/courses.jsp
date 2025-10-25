<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Available Courses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/courses-page.css" />
</head>
<body>
    <jsp:include page="/WEB-INF/views/Pages/user/header.jsp" />

    <div class="container-fluid my-5">
        <div class="d-flex justify-content-center">
            <div class="content-wrapper w-100" style="max-width:1200px;">
                <div class="row gx-4 align-items-start">
                    <aside class="col-md-3 col-sidebar order-md-1 order-2 mb-4">
                        <div class="card mb-4 p-3 shadow-sm rounded-4">
                            <h6 class="fw-bold mb-3"><i class="fa-solid fa-sort me-2"></i>Sort By</h6>
                            <div class="list-group">
                                <a href="#" class="list-group-item list-group-item-action active rounded-pill mb-2"><i class="fa-solid fa-clock me-2"></i>Newest</a>
                                <a href="#" class="list-group-item list-group-item-action rounded-pill mb-2"><i class="fa-solid fa-fire me-2"></i>Most Learned</a>
                                <a href="#" class="list-group-item list-group-item-action rounded-pill mb-2"><i class="fa-solid fa-star me-2"></i>Average Rating</a>
                                <a href="#" class="list-group-item list-group-item-action rounded-pill mb-2"><i class="fa-solid fa-dollar-sign me-2"></i>Price</a>
                                <a href="#" class="list-group-item list-group-item-action rounded-pill"><i class="fa-solid fa-tags me-2"></i>Discount</a>
                            </div>
                        </div>
                        <div class="card p-3 shadow-sm rounded-4">
                            <h6 class="fw-bold mb-3"><i class="fa-solid fa-list me-2"></i>Categories</h6>
                            <div class="list-group">
                                <c:set var="selectedCategory" value="${param.category}" />
                                <a href="${pageContext.request.contextPath}/courses" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center rounded mb-2 ${empty param.category ? 'active' : ''}">
                                    <span>
                                        <i class="fa-solid fa-list me-2 text-dark"></i> All
                                    </span>
                                    <span class="badge bg-primary rounded-pill">
                                        <c:out value="${totalCourses}" />
                                    </span>
                                </a>

                                <!-- Fixed ordered categories to match design: Development, Business, Marketing, Design -->
                                <a href="${pageContext.request.contextPath}/courses?category=Development" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center rounded mb-2 ${param.category == 'Development' ? 'active' : ''}">
                                    <span><i class="fa-solid fa-code me-2 text-primary"></i> Development</span>
                                    <span class="badge bg-primary rounded-pill"><c:out value="${categoryCounts['Development']}" /></span>
                                </a>

                                <a href="${pageContext.request.contextPath}/courses?category=Business" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center rounded mb-2 ${param.category == 'Business' ? 'active' : ''}">
                                    <span><i class="fa-solid fa-briefcase me-2 text-info"></i> Business</span>
                                    <span class="badge bg-primary rounded-pill"><c:out value="${categoryCounts['Business']}" /></span>
                                </a>

                                <a href="${pageContext.request.contextPath}/courses?category=Marketing" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center rounded mb-2 ${param.category == 'Marketing' ? 'active' : ''}">
                                    <span><i class="fa-solid fa-bullhorn me-2 text-warning"></i> Marketing</span>
                                    <span class="badge bg-primary rounded-pill"><c:out value="${categoryCounts['Marketing']}" /></span>
                                </a>

                                <a href="${pageContext.request.contextPath}/courses?category=Design" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center rounded mb-2 ${param.category == 'Design' ? 'active' : ''}">
                                    <span><i class="fa-solid fa-palette me-2 text-secondary"></i> Design</span>
                                    <span class="badge bg-primary rounded-pill"><c:out value="${categoryCounts['Design']}" /></span>
                                </a>
                            </div>
                        </div>
                    </aside>
                    <main class="col-md-9 main-col order-md-2 order-1 d-flex flex-wrap">
                        <div class="w-100 d-flex justify-content-between align-items-center mb-3">
                            <h2 class="mb-0">Available Courses</h2>
                        </div>
                        <c:forEach items="${courses}" var="course">
                            <div class="col-md-4 mb-4 d-flex">
                                <div class="card course-card h-100 w-100 shadow rounded-4">
                                    <img src="${fn:escapeXml(course.thumbUrl)}" class="card-img-top course-image rounded-top-4" alt="${fn:escapeXml(course.title)}" onerror="this.src='${pageContext.request.contextPath}/assets/img/demo/java.jpg'" />
                                    <div class="card-body">
                                        <h5 class="card-title text-truncate" title="${fn:escapeXml(course.title)}">${fn:escapeXml(course.title)}</h5>
                                        <div class="d-flex align-items-center mb-2">
                                            <span class="me-2"><i class="fa-solid fa-user-tie text-secondary"></i></span>
                                            <span class="text-muted small">${fn:escapeXml(course.instructorName)}</span>
                                        </div>
                                        <div class="d-flex align-items-center mb-2">
                                            <span class="badge bg-light text-dark me-2"><i class="fas fa-layer-group"></i> ${fn:escapeXml(course.level)}</span>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div>
                                                <c:if test="${course.hasDiscount()}">
                                                    <small class="text-decoration-line-through text-muted">${fn:escapeXml(course.formattedPrice)}</small>
                                                    <span class="badge bg-danger">-${course.discountPercentage}%</span>
                                                </c:if>
                                                <div class="fw-bold text-success">${fn:escapeXml(course.formattedDiscountedPrice)}</div>
                                            </div>
                                            <div class="text-muted"><i class="fas fa-users"></i> ${course.learnerCount} learners</div>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div class="rating">
                                                <c:forEach var="i" begin="1" end="5">
                                                    <i class="fa${i <= course.averageRating ? 's' : 'r'} fa-star text-warning"></i>
                                                </c:forEach>
                                                <small class="text-muted">(${course.ratingCount})</small>
                                            </div>
                                        </div>
                                        <div class="d-flex justify-content-end">
                                            <a href="${pageContext.request.contextPath}/detail?id=${fn:escapeXml(course.id)}" class="btn btn-primary btn-sm rounded-pill px-3"><i class="fa-solid fa-arrow-right"></i></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${not empty totalPages and totalPages > 1}">
                            <nav aria-label="Page navigation" class="mt-4 w-100">
                                <ul class="pagination justify-content-center">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="${prevPageUrl != null ? prevPageUrl : '#'}" tabindex="-1"><i class="fas fa-chevron-left"></i></a>
                                    </li>
                                    <c:forEach items="${pageUrls}" var="purl" varStatus="st">
                                        <li class="page-item ${currentPage == (st.index + 1) ? 'active' : ''}">
                                            <a class="page-link" href="${purl}">${st.index + 1}</a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="${nextPageUrl != null ? nextPageUrl : '#'}"><i class="fas fa-chevron-right"></i></a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </main>
                </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- courses-page.js removed: sidebar sticky logic is handled by CSS/server-side now -->
    <!-- No category toggle script needed for fixed category list -->
</body>
</html>