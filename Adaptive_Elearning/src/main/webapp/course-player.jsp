<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Khóa học</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/course-player.css">
</head>

<body>
    <div class="player-container">
        <!-- SIDEBAR -->
        <div class="sidebar">
            <h3>Nội dung khóa học</h3>
            <hr>

            <c:forEach var="section" items="${sidebarData}">
                <div class="section-title">${section.title}</div>

                <!-- Danh sách bài giảng -->
                <c:forEach var="lecture" items="${section.lecturesCollection}">
                    <c:set var="activeClass" value="${lecture.id == currentLecture.id ? 'active' : ''}" />
                    <a class="lecture-item ${activeClass}"
                       href="course-player?courseId=${section.courseId.id}&lectureId=${lecture.id}">
                        <c:set var="completedClass"
                               value="${completedLectures.contains(lecture.id) ? 'completed' : ''}" />
                        <span class="icon-checkbox ${completedClass}">&#10003;</span>
                        <div class="lecture-text">
                            <span class="lecture-title">${lecture.title}</span>
                        </div>
                    </a>
                </c:forEach>

                <!-- Danh sách bài tập -->
                <c:forEach var="assignment" items="${section.assignmentsCollection}">
                    <a class="lecture-item"
                       href="${pageContext.request.contextPath}/assignment-info?assignmentId=${assignment.id}">
                        <span class="icon-checkbox">📝</span>
                        <div class="lecture-text">
                            <span class="lecture-title">${assignment.name}</span>
                        </div>
                    </a>
                </c:forEach>
            </c:forEach>
        </div>

        <!-- MAIN CONTENT -->
        <div class="content-area">
            <div class="content-wrapper">
                <h1>${currentLecture.title}</h1>

                <div class="reading-content">
                    ${fn:replace(fn:replace(currentLecture.content, '&lt;', '<'), '&gt;', '>')}
                </div>

                <hr>

                <!-- HIỂN THỊ MATERIALS CỦA BÀI HIỆN TẠI -->
                <c:if test="${not empty currentMaterials}">
                    <h3>Tài liệu bài giảng</h3>
                    <c:forEach var="material" items="${currentMaterials}">
                        <c:set var="finalUrl" value="${material.url}" />
                        <c:if test="${not material.url.startsWith('http')}">
                            <c:set var="finalUrl" value="${pageContext.request.contextPath}/${material.url}" />
                        </c:if>

                        <c:choose>
                            <c:when test="${material.type eq 'Video'}">
                                <div class="material-video">
                                    <h4>🎥 Video:</h4>
                                    <iframe src="${finalUrl}" allowfullscreen></iframe>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="material-pdf">
                                    <h4>📄 Tài liệu:</h4>
                                    <iframe class="material-pdf" src="${finalUrl}">
                                        Trình duyệt của bạn không hỗ trợ xem PDF.
                                    </iframe>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </c:if>

                <!-- NÚT HOÀN THÀNH -->
                <div class="navigation-footer">
                    <form action="mark-complete" method="post" style="display:inline-block;">
                        <input type="hidden" name="lectureId" value="${currentLecture.id}" />
                        <input type="hidden" name="courseId"
                               value="${currentLecture.sectionId.courseId.id}" />
                        <button type="submit" class="complete-button">Đánh dấu đã hoàn thành</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
