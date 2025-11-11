<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Khóa học</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/course-player.css">
        
        <script src="${pageContext.request.contextPath}/assets/js/jszip.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/docx-preview.min.js"></script> 
        
    </head>

    <body>
        <div class="player-container">
            <div class="sidebar">
                <h3>Nội dung khóa học</h3>
                <hr>

                <c:forEach var="section" items="${sidebarData}">
                    <div class="section-title">${section.title}</div>

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

                    <c:forEach var="assignment" items="${section.assignmentsCollection}">
                        <c:url var="assignmentUrl" value="/assignment-info">
                            <c:param name="assignmentId" value="${assignment.id}" />
                        </c:url>

                        <c:set var="completedClass"
                               value="${completedAssignments.contains(assignment.id) ? 'completed' : ''}" />

                        <a class="lecture-item" href="${assignmentUrl}">
                            <span class="icon-checkbox ${completedClass}">
                                <c:choose>
                                    <c:when test="${completedAssignments.contains(assignment.id)}">
                                        &#10003;
                                    </c:when>
                                    <c:otherwise>
                                        📝 
                                    </c:otherwise>
                                </c:choose>
                            </span>
                            <div class="lecture-text">
                                <span class="lecture-title">${assignment.name}</span>
                            </div>
                        </a>
                    </c:forEach>
                </c:forEach>
            </div>

            <div class="content-area">
                <div class="content-wrapper">
                    <h1>${currentLecture.title}</h1>

                    <div class="reading-content">
                        ${fn:replace(fn:replace(currentLecture.content, '&lt;', '<'), '&gt;', '>')}
                    </div>

                    <hr>

                    <c:if test="${not empty currentMaterials}">
                        <h3>Tài liệu bài giảng</h3>
                        <c:forEach var="material" items="${currentMaterials}">

                            <c:url var="streamUrl" value="/stream-file">
                                <c:param name="name" value="${material.url}" />
                            </c:url>
                            <c:set var="materialTypeLower" value="${fn:toLowerCase(material.type)}" />
                            <c:set var="materialUrlLower" value="${fn:toLowerCase(material.url)}" />

                            <c:choose>
                                <%-- ✅ SỬA LỖI 3: DỌN DẸP ĐIỀU KIỆN DOCX --%>
                                <c:when test="${materialTypeLower eq 'doc' || materialTypeLower eq 'docx' || fn:endsWith(materialUrlLower, '.doc') || fn:endsWith(materialUrlLower, '.docx')}">
                                    <div class="material-doc" style="margin-bottom: 20px;">
                                        <h4>📄 Tài liệu </h4>
                                        <div id="docx-container-${material.lectureMaterialPK.id}" class="docx-viewer"
                                             style="width: 100%; border: 1px solid #eee; padding: 25px; box-sizing: border-box; background: #fff;">
                                            Đang tải tài liệu...
                                        </div>
                                        <script>
                                            (function () {
                                                const fileUrl = "${streamUrl}";
                                                const container = document.getElementById("docx-container-${material.lectureMaterialPK.id}");
                                                fetch(fileUrl)
                                                        .then(response => response.blob())
                                                        .then(blob => {
                                                            docx.renderAsync(blob, container)
                                                                    .catch(err => {
                                                                        console.error("Lỗi render docx:", err);
                                                                        container.innerHTML = '<p style="color: red;">Lỗi: Không thể hiển thị file này.</p>';
                                                                    });
                                                        })
                                                        .catch(err => {
                                                            console.error('Lỗi fetch file docx:', err);
                                                            container.innerHTML = '<p style="color: red;">Lỗi: Không thể tải file từ server.</p>';
                                                        });
                                            })();
                                        </script>
                                    </div>
                                </c:when>

                                <c:when test="${materialTypeLower eq 'pdf' || fn:endsWith(materialUrlLower, '.pdf')}">
                                    <div class="material-pdf" style="margin-bottom: 20px;">
                                        <h4>📄 Tài liệu PDF</h4>
                                        <iframe class="material-pdf" src="${streamUrl}"
                                                style="width: 100%; height: 700px; border: 1px solid #ccc;">
                                            Trình duyệt của bạn không hỗ trợ xem PDF.
                                        </iframe>
                                    </div>
                                </c:when>

                                <%-- ✅ SỬA LỖI 2: SỬA LẠI ĐIỀU KIỆN CHO VIDEO --%>
                                <c:when test="${materialTypeLower eq 'video' || fn:endsWith(materialUrlLower, '.mp4') || fn:endsWith(materialUrlLower, '.webm') }">
                                    <c:set var="videoUrl" value="${fn:startsWith(material.url, 'http') ? material.url : streamUrl}" />
                                    <div class="material-video" style="margin-bottom: 20px;">
                                        <h4>🎥 Video:</h4>
                                        <iframe src="${videoUrl}"
                                                style="width: 100%; aspect-ratio: 16/9; border: none;"
                                                allow="autoplay; fullscreen; picture-in-picture"
                                                allowfullscreen></iframe>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <div class="material-download" style="margin-bottom: 20px;">
                                        <h4>Tài liệu đính kèm:</h4>
                                        <a href="${streamUrl}" target="_blank" class="complete-button" style="text-decoration: none;">
                                            Tải xuống
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </c:if>

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