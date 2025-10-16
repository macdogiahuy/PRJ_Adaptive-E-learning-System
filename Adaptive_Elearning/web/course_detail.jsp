<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>${course.title}</title>
    <style>
        body { font-family: Arial, sans-serif; background: #faf8fc; }
        .container { max-width: 1100px; margin: 30px auto; background: #fff; border-radius: 10px; box-shadow: 0 2px 8px #ccc; padding: 30px; }
        .header { display: flex; align-items: center; justify-content: space-between; }
        .course-title { font-size: 2em; font-weight: bold; }
        .price-box { background: #f8f8f8; border-radius: 8px; padding: 20px; text-align: center; margin-bottom: 20px; }
        .price { font-size: 1.5em; color: #d32f2f; font-weight: bold; }
        .buy-btn { background: #d32f2f; color: #fff; border: none; padding: 12px 30px; border-radius: 5px; font-size: 1em; cursor: pointer; }
        .buy-btn:hover { background: #b71c1c; }
        .course-thumb { max-width: 350px; border-radius: 10px; }
        .section { margin: 30px 0; }
        .section-title { font-size: 1.2em; font-weight: bold; margin-bottom: 10px; }
        .review-box { background: #f5f5f5; border-radius: 8px; padding: 15px; margin-bottom: 10px; }
        .other-courses { display: flex; gap: 20px; }
        .other-course-card { background: #f8f8f8; border-radius: 8px; padding: 10px; width: 180px; text-align: center; }
        .other-course-card img { max-width: 100%; border-radius: 6px; }
        .nav { background: #7c3aed; color: #fff; padding: 12px 0; border-radius: 8px; margin-bottom: 20px; }
        .nav a { color: #fff; margin: 0 18px; text-decoration: none; font-weight: bold; }
        .nav a:hover { text-decoration: underline; }
        .search-box { display: inline-block; margin-left: 30px; }
        .search-input { padding: 6px 12px; border-radius: 4px; border: 1px solid #ccc; }
        .user-box { float: right; display: flex; align-items: center; gap: 10px; }
        .user-avatar { width: 36px; height: 36px; border-radius: 50%; border: 2px solid #7c3aed; }
        .report-btn { background: #ff9800; color: #fff; border: none; padding: 6px 16px; border-radius: 5px; cursor: pointer; margin-left: 10px; }
        .report-btn:hover { background: #e65100; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <div class="nav">
            <a href="home.jsp">Home</a>
            <a href="courses.jsp">Courses</a>
            <a href="groups.jsp">Learning Groups</a>
            <form class="search-box" action="search" method="get" style="display:inline;">
                <input class="search-input" type="text" name="q" placeholder="Search courses..."/>
                <button type="submit">Search</button>
            </form>
        </div>
        <div class="user-box">
            <span>${userName}</span>
            <img src="${userAvatar}" class="user-avatar" alt="avatar"/>
        </div>
    </div>
    <hr/>
    <div style="display: flex; gap: 40px; align-items: flex-start;">
        <div style="flex: 2;">
            <div class="course-title">${course.title}</div>
            <div style="margin: 10px 0; color: #888;">Created by <a href="#">${instructor.fullName}</a></div>
            <button class="report-btn">Report</button>
            <div style="margin: 18px 0;">Last updated: 21/10/2023 9:29:39 SA</div>
            <div class="section">
                <div class="section-title">What you'll learn</div>
                <ul>
                    <li>${course.outcomes}</li>
                </ul>
            </div>
            <div class="section">
                <div class="section-title">Requirements</div>
                <div>${course.requirements}</div>
            </div>
            <div class="section">
                <div class="section-title">Description</div>
                <div>${course.description}</div>
            </div>
            <div class="section">
                <div class="section-title">Reviews</div>
                <div>⭐ 0.00 • 0</div>
                <c:if test="${empty reviews}">
                    <div style="background:#ffeaea; color:#d32f2f; padding:8px; border-radius:5px;">No reviews yet</div>
                    <div style="background:#ffeaea; color:#d32f2f; padding:8px; border-radius:5px; margin-top:5px;">Enroll in the course to review</div>
                </c:if>
                <c:forEach var="review" items="${reviews}">
                    <div class="review-box">
                        <b>${review.userName}</b>: ${review.comment} (${review.rating}⭐)
                    </div>
                </c:forEach>
            </div>
        </div>
        <div style="flex: 1;">
            <img class="course-thumb" src="${course.thumbUrl}" alt="Course Image"/>
            <div class="price-box">
                <div class="price">${course.price}đ</div>
                <form action="buy-course" method="post">
                    <input type="hidden" name="courseId" value="${course.id}"/>
                    <button class="buy-btn" type="submit">Buy this course</button>
                </form>
            </div>
        </div>
    </div>
    <div class="section">
        <div class="section-title">More Courses by ${instructor.fullName}</div>
        <div class="other-courses">
            <c:forEach var="c" items="${otherCourses}">
                <div class="other-course-card">
                    <img src="${c.thumbUrl}" alt=""/>
                    <div style="font-weight:bold; margin:8px 0;">${c.title}</div>
                    <div style="color:#d32f2f;">${c.price}đ</div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>
</body>
</html>
