<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${not empty course.title ? course.title : 'Course Detail'}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/course-detail.css" />
</head>
<body style="background: #f7f8fa;">
    <jsp:include page="/WEB-INF/views/Pages/user/header.jsp" />
    <div class="container my-4">
        <div class="row">
            <div class="col-lg-8">
                <h2 class="fw-bold mb-2">${not empty course.title ? course.title : 'Course Detail'}</h2>
                <div class="d-flex align-items-center mb-3">
                    <div class="me-3 text-warning">
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                    </div>
                        <div class="text-muted small">${not empty course ? course.getAverageRating() : 0} (${not empty course ? course.getRatingCount() : 0}) · ${not empty course ? course.getLearnerCount() : 0} learners</div>
                </div>

                <div class="mb-4 p-3 bg-white rounded shadow-sm">
                    <img src="${not empty course.thumbUrl ? course.thumbUrl : (pageContext.request.contextPath + '/assets/img/demo/idea.jpg')}" class="course-thumb mb-3" alt="${not empty course.title ? course.title : 'Course thumbnail'}" onerror="this.src='${pageContext.request.contextPath}/assets/img/demo/idea.jpg'" />
                    <h5 class="fw-bold">What you'll learn</h5>
                    <ul class="mb-0">
                        <li>Apply techniques, strategies and new perspectives to their lives, to become the most successful version of themselves</li>
                    </ul>
                </div>

                <div class="mb-4">
                    <h5 class="fw-bold">Requirements</h5>
                    <ul>
                        <li>I'll teach you everything you need to know</li>
                        <li>A computer with access to the internet</li>
                    </ul>
                </div>

                <%-- Add JSTL functions taglib at top if missing --%>
                <div class="mb-4">
                    <h5 class="fw-bold">Description</h5>
                    <p>Course description not available.</p>
                </div>

                <div class="mb-4">
                    <h5 class="fw-bold">Reviews</h5>
                    <div class="alert alert-info mb-2">No reviews yet!</div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="price-box mb-3">
                    <div class="fs-3 fw-bold text-danger">${not empty course ? course.getFormattedDiscountedPrice() : '0 ₫'}</div>
                    <button class="btn buy-btn w-100 mt-2">Add to cart</button>
                </div>

                <!-- Sidebar thumbnail -->
                <img src="${not empty course ? fn:escapeXml(course.thumbUrl) : (pageContext.request.contextPath + '/assets/img/demo/idea.jpg')}" class="course-thumb mb-3" alt="Course thumbnail" onerror="this.src='${pageContext.request.contextPath}/assets/img/demo/idea.jpg'" />
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-12">
                <h5 class="fw-bold">More Courses by ${not empty course ? course.getInstructorName() : 'Instructor'}</h5>
                <div class="d-flex flex-wrap more-courses mt-3">
                    <c:choose>
                        <c:when test="${not empty moreCourses}">
                            <c:forEach items="${moreCourses}" var="mc">
                                <div class="card">
                                    <img src="${not empty mc.thumbUrl ? mc.thumbUrl : (pageContext.request.contextPath + '/assets/img/demo/team.jpg')}" class="card-img-top" alt="${mc.title}" onerror="this.src='${pageContext.request.contextPath}/assets/img/demo/team.jpg'" />
                                    <div class="card-body">
                                        <h6 class="card-title text-truncate">${mc.title}</h6>
                                        <div class="text-muted small">No rating yet</div>
                                        <div class="fw-bold text-danger">${mc.getFormattedDiscountedPrice()}</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <!-- default demo cards -->
                            <div class="card">
                                <img src="${pageContext.request.contextPath}/assets/img/demo/team.jpg" class="card-img-top" alt="Professional Life Coach Certification & Guide" />
                                <div class="card-body">
                                    <h6 class="card-title text-truncate">Professional Life Coach Certification & Guide</h6>
                                    <div class="text-muted small">No rating yet</div>
                                        <div class="fw-bold text-danger">33.000 ₫</div>
                                </div>
                            </div>
                            <div class="card">
                                <img src="${pageContext.request.contextPath}/assets/img/demo/java.jpg" class="card-img-top" alt="Learn Linux in 5 Days and Level Up Your" />
                                <div class="card-body">
                                    <h6 class="card-title text-truncate">Learn Linux in 5 Days and Level Up Your</h6>
                                    <div class="text-muted small">No rating yet</div>
                                        <div class="fw-bold text-danger">82.000 ₫</div>
                                </div>
                            </div>
                            <div class="card">
                                <img src="${pageContext.request.contextPath}/assets/img/demo/idea.jpg" class="card-img-top" alt="Sexual Harassment Training for Employees" />
                                <div class="card-body">
                                    <h6 class="card-title text-truncate">Sexual Harassment Training for Employees</h6>
                                    <div class="text-muted small">No rating yet</div>
                                        <div class="fw-bold text-danger">72.000 ₫</div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
