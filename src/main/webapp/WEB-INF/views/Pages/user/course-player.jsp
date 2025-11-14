<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Player</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            background-color: #f8fafc;
            font-family: "Segoe UI", Arial, sans-serif;
            color: #0f172a;
        }
        .player-shell {
            display: flex;
            min-height: 100vh;
        }
        .player-main {
            flex: 1 1 auto;
            display: flex;
            flex-direction: column;
            background-color: #0b1120;
            color: #e2e8f0;
        }
        .player-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.25rem 2rem;
            border-bottom: 1px solid rgba(226, 232, 240, 0.1);
        }
        .player-header h1 {
            font-size: 1.25rem;
            margin: 0;
        }
        .player-header small {
            color: #94a3b8;
            display: block;
            margin-top: 0.35rem;
        }
        .player-viewport {
            flex: 1 1 auto;
            display: flex;
            flex-direction: column;
            padding: 1.5rem 2rem;
            gap: 1.5rem;
        }
        .video-stage {
            position: relative;
            width: 100%;
            background-color: #020617;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 20px 45px rgba(2, 6, 23, 0.35);
        }
        .video-stage::before {
            content: "";
            display: block;
            padding-top: 56.25%;
        }
        .video-stage .player-host {
            position: absolute;
            inset: 0;
        }
        .video-stage iframe,
        .video-stage video {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: 0;
        }
        .video-stage .placeholder {
            position: absolute;
            inset: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            color: rgba(226, 232, 240, 0.8);
        }
        .video-stage .placeholder i {
            font-size: 3rem;
            opacity: 0.65;
        }
        .attachments {
            background-color: rgba(15, 23, 42, 0.6);
            border-radius: 0.75rem;
            padding: 1.25rem;
        }
        .attachments h2 {
            font-size: 1rem;
            margin-bottom: 0.75rem;
            color: #a5b4fc;
        }
        .attachments a {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .attachment-item + .attachment-item {
            margin-top: 0.75rem;
        }
        .attachment-item a {
            color: #38bdf8;
            text-decoration: none;
        }
        .attachment-item a:hover {
            color: #7dd3fc;
        }
        .player-sidebar {
            width: 360px;
            background-color: #fff;
            border-left: 1px solid #e2e8f0;
            display: flex;
            flex-direction: column;
        }
        .sidebar-header {
            padding: 1.5rem;
            border-bottom: 1px solid #e2e8f0;
        }
        .sidebar-header h2 {
            font-size: 1.125rem;
            margin: 0 0 0.35rem 0;
            color: #1e293b;
        }
        .sidebar-header span {
            font-size: 0.875rem;
            color: #64748b;
        }
        .course-outline {
            flex: 1 1 auto;
            overflow-y: auto;
        }
        .section-block + .section-block {
            border-top: 1px solid #e2e8f0;
        }
        .section-toggle {
            width: 100%;
            padding: 1rem 1.5rem;
            background-color: transparent;
            border: 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 600;
            color: #0f172a;
            text-align: left;
        }
        .section-toggle:hover {
            background-color: #f8fafc;
        }
        .section-toggle i {
            transition: transform 0.25s ease;
        }
        .section-toggle[aria-expanded="true"] i {
            transform: rotate(180deg);
        }
        .lecture-list {
            display: none;
            padding-bottom: 0.5rem;
        }
        .lecture-list.is-open {
            display: block;
        }
        .lecture-item {
            padding: 0.85rem 1.75rem 0.85rem 2.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            cursor: pointer;
            border-left: 3px solid transparent;
        }
        .lecture-item:hover {
            background-color: #f1f5f9;
        }
        .lecture-item.active {
            background-color: rgba(14, 165, 233, 0.12);
            border-left-color: #0ea5e9;
            color: #0369a1;
            font-weight: 600;
        }
        .badge-type {
            background-color: rgba(37, 99, 235, 0.12);
            color: #2563eb;
            border-radius: 999px;
            font-size: 0.7rem;
            padding: 0.15rem 0.55rem;
        }
        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
            color: #64748b;
        }
        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        .alert-box {
            max-width: 640px;
            margin: 4rem auto;
        }
        @media (max-width: 992px) {
            .player-shell {
                flex-direction: column;
            }
            .player-sidebar {
                width: 100%;
                max-height: 360px;
            }
            .course-outline {
                max-height: 320px;
            }
        }
    </style>
</head>
<body>
    <c:choose>
        <c:when test="${not empty errorMsg}">
            <div class="alert alert-danger alert-box" role="alert">
                <div class="d-flex align-items-start gap-3">
                    <i class="fa-solid fa-circle-exclamation fs-3 mt-1"></i>
                    <div>
                        <h5 class="fw-semibold mb-2">Không thể mở khóa học</h5>
                        <div>${errorMsg}</div>
                        <a class="btn btn-outline-danger btn-sm mt-3" href="${pageContext.request.contextPath}/my-courses">
                            <i class="fa-solid fa-arrow-left-long me-2"></i>Quay lại danh sách khóa học
                        </a>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <%-- Flash message support: read from session then remove so it shows once after redirect --%>
            <%
                String flash = (String) session.getAttribute("flashMsg");
                String flashType = (String) session.getAttribute("flashType");
                if (flash != null) {
                    session.removeAttribute("flashMsg");
                    session.removeAttribute("flashType");
            %>
            <div class="container alert-box">
                <div class="alert <%= ("success".equalsIgnoreCase(flashType) ? "alert-success" : ("error".equalsIgnoreCase(flashType) ? "alert-danger" : "alert-info")) %>" role="alert">
                    <%= flash %>
                </div>
            </div>
            <%
                }
            %>
            <div class="player-shell">
                <div class="player-main">
                    <div class="player-header">
                        <div>
                            <h1 id="activeLectureTitle">Chọn một bài giảng</h1>
                            <small>
                                <c:out value="${course.title}"/>
                            </small>
                        </div>
                        <a class="btn btn-outline-light btn-sm" href="${pageContext.request.contextPath}/my-courses">
                            <i class="fa-solid fa-arrow-left me-2"></i>Thoát khóa học
                        </a>
                    </div>
                    <div class="player-viewport">
                        <div class="video-stage" id="videoStage">
                            <div class="placeholder" id="videoPlaceholder">
                                <i class="fa-solid fa-film"></i>
                                <span id="placeholderText" data-default="Chọn một bài giảng ở bên phải để bắt đầu.">Chọn một bài giảng ở bên phải để bắt đầu.</span>
                            </div>
                            <div class="player-host" id="videoHost"></div>
                        </div>
                        <div class="attachments d-none" id="attachmentPanel">
                            <h2>Tài liệu đính kèm</h2>
                            <div id="attachmentList"></div>
                        </div>
                    </div>
                </div>
                <aside class="player-sidebar">
                    <div class="sidebar-header">
                        <h2><c:out value="${course.title}"/></h2>
                        <span>
                            <i class="fa-solid fa-graduation-cap me-1 text-primary"></i>
                            ${fn:length(sections)} mục lục
                        </span>
                    </div>
                    <div class="course-outline">
                        <c:choose>
                            <c:when test="${empty sections}">
                                <div class="empty-state">
                                    <i class="fa-regular fa-folder-open"></i>
                                    <p>Khóa học chưa có nội dung hiển thị.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${sections}" var="section" varStatus="sec">
                                    <c:set var="sectionLectures" value="${lecturesBySection[section.id]}"/>
                                    <div class="section-block">
                                        <button class="section-toggle" type="button" data-target="section-${sec.index}" aria-expanded="false">
                                            <span>Phần ${sec.count}: <c:out value="${section.title}"/></span>
                                            <span class="text-secondary small">${fn:length(sectionLectures)} bài giảng <i class="fa-solid fa-chevron-down ms-2"></i></span>
                                        </button>
                                        <div class="lecture-list" id="section-${sec.index}" aria-hidden="true">
                                            <c:forEach items="${sectionLectures}" var="lectureInfo">
                                                <div class="lecture-item"
                                                     data-lecture-id="${lectureInfo.lecture.id}"
                                                     data-lecture-title="${fn:escapeXml(lectureInfo.lecture.title)}"
                                                     data-primary-url="${fn:escapeXml(empty lectureInfo.primaryMaterialUrl ? '' : lectureInfo.primaryMaterialUrl)}"
                                                     data-primary-type="${fn:escapeXml(empty lectureInfo.primaryMaterialType ? '' : lectureInfo.primaryMaterialType)}"
                                                     data-materials='${fn:escapeXml(lectureInfo.materialsJson)}'>
                                                    <i class="fa-regular fa-circle-play text-primary"></i>
                                                    <div class="flex-grow-1">
                                                        <div><c:out value="${lectureInfo.lecture.title}"/></div>
                                                        <c:if test="${not empty lectureInfo.materials}">
                                                            <span class="badge-type"><c:out value="${empty lectureInfo.primaryMaterialType ? 'Tài liệu' : lectureInfo.primaryMaterialType}"/></span>
                                                        </c:if>
                                                    </div>
                                                    <i class="fa-solid fa-check-circle text-success lecture-completed-icon" style="display: none;"></i>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </aside>
            </div>
        </c:otherwise>
    </c:choose>

    <script>
        // Attachment icon color styles injected (PDF red, DOCX ocean blue)
        (function addAttachmentColors(){
            const style = document.createElement('style');
            style.textContent = `
                .attachment-item i.fa-file-pdf { color: #dc2626; } /* red */
                .attachment-item i.fa-file-word { color: #0ea5e9; } /* ocean blue */
            `;
            document.head.appendChild(style);
        })();
        const courseId = "${course.id}";
        // Inject context path for building internal URLs (avoid using pageContext directly inside JS logic strings)
        const appContextPath = "${pageContext.request.contextPath}";
        let completedLectures = [];
        let currentLectureId = null;
        let currentPlayer = null;

        // Load completed lectures on page load
        window.addEventListener('DOMContentLoaded', loadCompletedLectures);

        async function loadCompletedLectures() {
            try {
                const response = await fetch('${pageContext.request.contextPath}/mark-lecture-complete?courseId=' + encodeURIComponent(courseId));
                const data = await response.json();
                completedLectures = data.completedLectures || [];
                updateCompletionIcons();
            } catch (err) {
                console.error('Failed to load completed lectures:', err);
            }
        }

        function updateCompletionIcons() {
            lectureItems.forEach(item => {
                const lectureId = item.dataset.lectureId;
                const icon = item.querySelector('.lecture-completed-icon');
                if (icon && completedLectures.includes(lectureId)) {
                    icon.style.display = 'inline-block';
                }
            });
        }

        async function markLectureComplete(lectureId) {
            if (completedLectures.includes(lectureId)) {
                return; // Already completed
            }

            try {
                const formData = new URLSearchParams();
                formData.append('courseId', courseId);
                formData.append('lectureId', lectureId);

                const response = await fetch('${pageContext.request.contextPath}/mark-lecture-complete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: formData
                });

                const data = await response.json();
                if (data.success) {
                    completedLectures.push(lectureId);
                    updateCompletionIcons();
                    console.log('Lecture marked as complete:', lectureId);
                }
            } catch (err) {
                console.error('Failed to mark lecture complete:', err);
            }
        }

        const lectureItems = Array.from(document.querySelectorAll('.lecture-item'));
        lectureItems.forEach(item => item.addEventListener('click', () => selectLecture(item)));

        const sectionToggles = Array.from(document.querySelectorAll('.section-toggle'));
        sectionToggles.forEach(toggle => {
            toggle.addEventListener('click', () => {
                const targetId = toggle.dataset.target;
                const panel = document.getElementById(targetId);
                const expanded = toggle.getAttribute('aria-expanded') === 'true';

                if (!expanded) {
                    closeAllSections();
                    toggle.setAttribute('aria-expanded', 'true');
                    panel.classList.add('is-open');
                    panel.setAttribute('aria-hidden', 'false');
                } else {
                    toggle.setAttribute('aria-expanded', 'false');
                    panel.classList.remove('is-open');
                    panel.setAttribute('aria-hidden', 'true');
                }
            });
        });

        function closeAllSections() {
            sectionToggles.forEach(btn => btn.setAttribute('aria-expanded', 'false'));
            document.querySelectorAll('.lecture-list').forEach(list => {
                list.classList.remove('is-open');
                list.setAttribute('aria-hidden', 'true');
            });
        }

        function selectLecture(element) {
            lectureItems.forEach(item => item.classList.remove('active'));
            element.classList.add('active');

            currentLectureId = element.dataset.lectureId;

            const title = element.dataset.lectureTitle || 'Bài giảng';
            document.getElementById('activeLectureTitle').textContent = title;

            const rawMaterials = decodeHtml(element.dataset.materials || '[]');
            let materials = [];
            try {
                materials = JSON.parse(rawMaterials);
            } catch (err) {
                console.warn('Không thể phân tích materials JSON, fallback sang primary URL.', err);
            }

            if (!materials || materials.length === 0) {
                const primaryUrl = element.dataset.primaryUrl;
                const primaryType = element.dataset.primaryType || 'Video';
                if (primaryUrl) {
                    materials = [{ url: primaryUrl, type: primaryType }];
                }
            }

            renderLecture(materials);
        }

        function renderLecture(materials) {
            const placeholder = document.getElementById('videoPlaceholder');
            const placeholderText = document.getElementById('placeholderText');
            const defaultMessage = placeholderText ? (placeholderText.dataset.default || placeholderText.textContent) : '';
            const host = document.getElementById('videoHost');
            const attachmentPanel = document.getElementById('attachmentPanel');
            const attachmentList = document.getElementById('attachmentList');

            if (!placeholder || !host || !attachmentPanel || !attachmentList) {
                return;
            }

            host.innerHTML = '';
            attachmentPanel.classList.add('d-none');
            attachmentList.innerHTML = '';

            if (!materials || materials.length === 0) {
                if (placeholderText) {
                    placeholderText.textContent = 'Chưa có nội dung cho bài giảng này.';
                }
                placeholder.classList.remove('d-none');
                return;
            }

            const videoIndex = materials.findIndex(material => isVideo(material.type));
            const video = videoIndex >= 0 ? materials[videoIndex] : null;

            if (video) {
                const playerElement = buildVideoPlayer(video.url);
                if (playerElement) {
                    if (placeholderText && defaultMessage) {
                        placeholderText.textContent = defaultMessage;
                    }
                    placeholder.classList.add('d-none');
                    host.appendChild(playerElement);
                } else {
                    if (placeholderText) {
                        placeholderText.textContent = 'Không tải được video cho bài giảng này.';
                    }
                    placeholder.classList.remove('d-none');
                }
            } else {
                if (placeholderText) {
                    placeholderText.textContent = 'Chưa có video cho bài giảng này.';
                }
                placeholder.classList.remove('d-none');
            }

            const extras = materials.filter((_, index) => index !== videoIndex);
            if (extras.length > 0) {
                attachmentPanel.classList.remove('d-none');
                extras.forEach(material => {
                    attachmentList.appendChild(buildAttachment(material));
                });
            }
        }

        function buildVideoPlayer(url) {
            if (!url) {
                return null;
            }

            const isDrive = url.includes('drive.google.com');
            if (isDrive) {
                // Prefer native streaming through our proxy to avoid CSP frame-ancestors issues
                const fileIdMatch = url.match(/\/d\/([a-zA-Z0-9_-]+)/) || url.match(/[?&]id=([^&]+)/);
                const fileId = fileIdMatch && fileIdMatch[1] ? fileIdMatch[1] : null;
                if (fileId) {
                    const video = document.createElement('video');
                    video.controls = true;
                    video.playsInline = true;
                    video.preload = 'metadata';
                    // Build stream URL using injected context path
                    video.src = window.location.origin + appContextPath + '/drive-stream?fileId=' + fileId;
                    video.addEventListener('error', () => {
                        console.warn('Proxy stream failed, fallback to iframe preview');
                        const iframe = document.createElement('iframe');
                        iframe.src = toDriveEmbed(url);
                        iframe.allow = 'autoplay; fullscreen; picture-in-picture';
                        iframe.allowFullscreen = true;
                        iframe.referrerPolicy = 'strict-origin-when-cross-origin';
                        iframe.loading = 'lazy';
                        video.replaceWith(iframe);
                        // Fallback completion heuristic
                        setTimeout(() => { if (currentLectureId) { markLectureComplete(currentLectureId); } }, 30000);
                        currentPlayer = iframe;
                    });
                    // Completion tracking similar to normal video
                    video.addEventListener('ended', () => { if (currentLectureId) { markLectureComplete(currentLectureId); } });
                    video.addEventListener('timeupdate', () => {
                        if (video.duration > 0 && video.currentTime / video.duration >= 0.9) {
                            if (currentLectureId) { markLectureComplete(currentLectureId); }
                        }
                    });
                    currentPlayer = video;
                    return video;
                } else {
                    // Drive link without identifiable file id - fallback to iframe
                    const iframe = document.createElement('iframe');
                    iframe.src = toDriveEmbed(url);
                    iframe.allow = 'autoplay; fullscreen; picture-in-picture';
                    iframe.allowFullscreen = true;
                    iframe.referrerPolicy = 'strict-origin-when-cross-origin';
                    iframe.loading = 'lazy';
                    setTimeout(() => { if (currentLectureId) { markLectureComplete(currentLectureId); } }, 30000);
                    currentPlayer = iframe;
                    return iframe;
                }
            }

            const video = document.createElement('video');
            video.controls = true;
            video.playsInline = true;
            video.src = url;
            
            // Track video completion
            video.addEventListener('ended', () => {
                if (currentLectureId) {
                    markLectureComplete(currentLectureId);
                }
            });
            
            // Also mark as complete if watched 90% of video
            video.addEventListener('timeupdate', () => {
                if (video.duration > 0 && video.currentTime / video.duration >= 0.9) {
                    if (currentLectureId) {
                        markLectureComplete(currentLectureId);
                    }
                }
            });
            
            currentPlayer = video;
            return video;
        }

        function buildAttachment(material) {
            const container = document.createElement('div');
            container.className = 'attachment-item';
            const type = material.type || 'Tài liệu';
            const url = material.url || '#';
            const label = material.fileName || type;

            const link = document.createElement('a');
            link.href = url;
            link.target = '_blank';
            link.rel = 'noopener noreferrer';

            const icon = document.createElement('i');
            icon.className = 'fa-solid ' + mapAttachmentIcon(type) + ' me-2';
            // Optionally add a data attribute for future expansion
            icon.dataset.fileType = type.toLowerCase();

            const text = document.createTextNode(label);

            link.appendChild(icon);
            link.appendChild(text);
            container.appendChild(link);
            return container;
        }

        function decodeHtml(content) {
            if (!content) {
                return '';
            }
            return content.replace(/&quot;/g, '"')
                          .replace(/&#39;/g, "'")
                          .replace(/&#x27;/g, "'")
                          .replace(/&lt;/g, '<')
                          .replace(/&gt;/g, '>')
                          .replace(/&amp;/g, '&');
        }

        function isVideo(type) {
            if (!type) {
                return false;
            }
            const lower = type.toLowerCase();
            return lower.includes('video') || lower.includes('mp4') || lower.includes('drive');
        }

        function toDriveEmbed(url) {
            if (!url) {
                return '';
            }
            if (url.includes('drive.google.com')) {
                if (url.includes('/preview')) {
                    return url;
                }
                const byId = url.match(/\/d\/([a-zA-Z0-9_-]+)/);
                if (byId && byId[1]) {
                    return 'https://drive.google.com/file/d/' + byId[1] + '/preview';
                }
                const byQuery = url.match(/[?&]id=([^&]+)/);
                if (byQuery && byQuery[1]) {
                    return 'https://drive.google.com/file/d/' + byQuery[1] + '/preview';
                }
            }
            return url;
        }

        function mapAttachmentIcon(type) {
            const lower = (type || '').toLowerCase();
            if (lower.includes('video')) return 'fa-circle-play';
            if (lower.includes('pdf')) return 'fa-file-pdf';
            if (lower.includes('doc')) return 'fa-file-word';
            if (lower.includes('sheet') || lower.includes('xls')) return 'fa-file-excel';
            if (lower.includes('ppt') || lower.includes('slide')) return 'fa-file-powerpoint';
            return 'fa-paperclip';
        }
    </script>
</body>
</html>
