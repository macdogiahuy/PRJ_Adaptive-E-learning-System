<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Instructor Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <style>
            body {
                background-color: #0f172a;
                color: white;
                font-family: "Inter", sans-serif;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .dashboard-box {
                background-color: #1e293b;
                padding: 3rem;
                border-radius: 1.25rem;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.4);
                width: 100%;
                max-width: 500px;
            }
            .upload-area {
                border: 2px dashed #64748b;
                border-radius: 0.75rem;
                padding: 3rem 1rem;
                text-align: center;
                transition: border-color 0.3s ease;
                color: #cbd5e1;
            }
            .upload-area:hover {
                border-color: #3b82f6;
                color: #f8fafc;
                cursor: pointer;
            }
            .upload-area input[type="file"] {
                display: none;
            }
            .upload-icon {
                font-size: 2.5rem;
                color: #94a3b8;
            }
            .btn-upload {
                background-color: #2563eb;
                color: white;
                font-weight: 500;
                width: 100%;
            }
            .btn-upload:hover {
                background-color: #1d4ed8;
                color: white;
            }
            .btn-create-lecture {
                background-color: #10b981;
                color: white;
                font-weight: 500;
            }
            .btn-create-lecture:hover {
                background-color: #059669;
                color: white;
            }
        </style>
    </head>
    <body>

        <div class="dashboard-box">
            <h1 class="text-center mb-2 fw-bold">Instructor Dashboard</h1>
            <p class="text-center text-secondary mb-4">
                Upload a new video lecture for your course.
            </p>

            <form id="uploadForm" 
                  action="${pageContext.request.contextPath}/instructor/upload-video"
                  method="post"
                  enctype="multipart/form-data">

                <!-- Course Information Section -->
                <div class="mb-4">
                    <h5 class="text-info mb-3">📚 Course Information</h5>
                    
                    <div class="mb-3">
                        <label for="courseSelect" class="form-label text-light">Select Course</label>
                        <select id="courseSelect" name="courseId" class="form-select bg-dark text-light">
                            <option value="">-- choose existing course or create new --</option>
                            <%
                                java.util.List courses = (java.util.List) request.getAttribute("courses");
                                if (courses != null) {
                                    for (Object o : courses) {
                                        com.coursehub.tools.DBSectionInserter.CourseItem ci = (com.coursehub.tools.DBSectionInserter.CourseItem) o;
                                        out.println("<option value='" + ci.id + "'>" + ci.title + "</option>");
                                    }
                                }
                            %>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label for="courseTitle" class="form-label text-light">Course Title (for new course)</label>
                        <input type="text" id="courseTitle" name="courseTitle" 
                               class="form-control bg-dark text-light border-0"
                               placeholder="e.g., Complete Web Development Bootcamp" />
                    </div>
                    
                    <div class="mb-3">
                        <label for="authorName" class="form-label text-light">Instructor/Author Name</label>
                        <input type="text" id="authorName" name="authorName" 
                               class="form-control bg-dark text-light border-0"
                               placeholder="e.g., John Smith" required />
                    </div>
                </div>

                <!-- Section & Lecture Information -->
                <div class="mb-4">
                    <h5 class="text-info mb-3">📝 Section & Lecture Details</h5>
                    
                    <div class="mb-3">
                        <label for="sectionTitle" class="form-label text-light">Section Title</label>
                        <input type="text" id="sectionTitle" name="sectionTitle" 
                               class="form-control bg-dark text-light border-0" 
                               placeholder="e.g., Introduction to HTML" required />
                    </div>
                    
                    <div class="mb-3">
                        <label for="lectureTitle" class="form-label text-light">Lecture Title</label>
                        <input type="text" id="lectureTitle" name="lectureTitle" 
                               class="form-control bg-dark text-light border-0" 
                               placeholder="e.g., Getting Started with HTML Tags" required />
                    </div>
                    
                    <div class="mb-3">
                        <label for="assignmentSelect" class="form-label text-light">Choose Assignment (optional - for JSON import)</label>
                        <select id="assignmentSelect" name="assignmentId" class="form-select bg-dark text-light">
                            <option value="">-- Create new assignment (default) --</option>
                            <%
                                java.util.List assigns = (java.util.List) request.getAttribute("assignments");
                                if (assigns != null) {
                                    for (Object a : assigns) {
                                        com.coursehub.tools.DBSectionInserter.AssignmentItem ai = (com.coursehub.tools.DBSectionInserter.AssignmentItem) a;
                                        out.println("<option value='" + ai.id + "'>" + ai.name + " (" + ai.id + ")</option>");
                                    }
                                }
                            %>
                        </select>
                        <div class="form-text mt-2">Or <a href="#" id="toggleManual">paste an Assignment UUID</a></div>

                        <div id="manualAssignment" style="display:none; margin-top:.5rem;">
                            <input type="text" id="assignmentIdManual" name="assignmentIdManual"
                                   class="form-control bg-dark text-light border-0"
                                   placeholder="Paste existing Assignment UUID here" />
                            <div class="form-text">If you paste a UUID here it overrides the dropdown selection.</div>
                        </div>
                    </div>
                </div>

                <!-- File Upload Section -->
                <div class="mb-4">
                    <h5 class="text-info mb-3">📁 File Upload</h5>
                </div>

                <div class="upload-area mb-4" 
                     id="uploadArea"
                     onclick="document.getElementById('files').click()"
                     ondragover="event.preventDefault()"
                     ondrop="handleDrop(event)">
                    <div class="upload-icon mb-2">⬆️</div>
                    <p id="uploadText">
                        Click to select or drag & drop multiple files<br />
                        <small class="text-secondary">
                            Video (MP4/MOV/WEBM), PDF, DOCX, PPTX, XLSX, Images
                        </small><br>
                        <small class="text-warning">Max 10 files per upload (demo limit)</small>
                    </p>
                    <div id="fileCountBadge" class="mt-2" style="display: none;">
                        <span class="badge bg-primary fs-5 px-4 py-2">
                            <span id="fileCount">0</span> file(s) selected
                        </span>
                    </div>
              <input type="file" id="files" name="files" multiple
                  accept=".json,application/json,video/*,application/pdf,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.openxmlformats-officedocument.presentationml.presentation,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,image/*,text/plain" 
                  required onchange="handleFileSelect(event)" />
                </div>

                                <!-- Dedicated JSON importer input (single file) - visible only to Instructors -->
                                <%
                                    model.Users __curr = (model.Users) session.getAttribute("account");
                                    boolean __isInstructor = (__curr != null && __curr.getRole() != null && "Instructor".equalsIgnoreCase(__curr.getRole()));
                                %>
                                <% if (__isInstructor) { %>
                                    <div class="mb-3">
                                        <label class="form-label text-light">Import MCQ JSON (use this field to import questions only)</label>
                                        <input type="file" id="jsonFile" name="jsonFile" accept=".json,application/json" class="form-control bg-dark text-light border-0" onchange="handleJsonSelect(event)" />
                                        <div class="form-text">If you choose a JSON file here, other file uploads will be disabled to avoid conflicts.</div>
                                    </div>
                                <% } else { %>
                                    <div class="mb-3">
                                        <label class="form-label text-light">Import MCQ JSON</label>
                                        <div class="form-text text-muted">Chỉ người có quyền "Instructor" mới được import file JSON. Nếu bạn là giảng viên nhưng không thấy ô này, hãy đăng nhập lại hoặc liên hệ quản trị viên.</div>
                                    </div>
                                <% } %>

                <div id="fileList" class="mb-3 small"></div>

                <button type="submit" class="btn btn-upload py-3">Upload Files</button>
            </form>

            <!-- Auto-sync link for instructors -->
            <div class="mt-4 text-center">
                <p class="text-secondary mb-2">After uploading videos to Google Drive structure:</p>
                <a href="${pageContext.request.contextPath}/admin/auto-sync-drive" 
                   class="btn btn-outline-info btn-sm">
                    <i class="fas fa-sync-alt me-2"></i>
                    Run Auto-Sync to Database
                </a>
            </div>

            <!-- ✅ Hiển thị thông báo cho Drive upload và DB (styled alerts) -->
            <%
                String driveMsg = (String) request.getAttribute("driveMsg");
                String dbMsg = (String) request.getAttribute("dbMsg");
                if (driveMsg != null && !driveMsg.isEmpty()) {
                    String css = "alert-info";
                    if (driveMsg.contains("✅") || driveMsg.toLowerCase().contains("thành công")) css = "alert-success";
                    if (driveMsg.contains("❌") || driveMsg.toLowerCase().contains("lỗi")) css = "alert-danger";
                    out.println("<div class='mt-3 alert " + css + " text-center' role='alert'>" + driveMsg.replaceAll("\n", "<br/>") + "</div>");
                }
                if (dbMsg != null && !dbMsg.isEmpty()) {
                    String css = "alert-info";
                    if (dbMsg.contains("✅") || dbMsg.toLowerCase().contains("đã lưu") || dbMsg.toLowerCase().contains("thành công")) css = "alert-success";
                    if (dbMsg.contains("❌") || dbMsg.toLowerCase().contains("lỗi") || dbMsg.toLowerCase().contains("không tồn tại")) css = "alert-danger";
                    out.println("<div class='mt-2 alert " + css + " text-center' role='alert'>" + dbMsg.replaceAll("\n", "<br/>") + "</div>");
                }
            %>
        </div>



        <script>
            // Multiple file selection handling
            function summarizeFiles(fileList) {
                if (!fileList || fileList.length === 0) return '<span class="text-secondary">No files selected</span>';
                const maxShow = 5;
                let names = [];
                for (let i = 0; i < fileList.length && i < maxShow; i++) {
                    names.push(`<span class='badge bg-dark border text-light me-1 mb-1'>${fileList[i].name}</span>`);
                }
                if (fileList.length > maxShow) {
                    names.push(`<span class='badge bg-secondary ms-1'>+${fileList.length - maxShow} more</span>`);
                }
                return names.join('');
            }

            function renderFileList(files) {
                const listDiv = document.getElementById('fileList');
                if (!files || files.length === 0) { listDiv.innerHTML = ''; return; }
                let html = '<div class="d-flex flex-wrap">' + summarizeFiles(files) + '</div>';
                listDiv.innerHTML = html;
            }

            function handleFileSelect(e) {
                const files = e.target.files;
                if (files && files.length) {
                    // If a JSON importer file is already chosen, prevent selecting other files
                    const jf = document.getElementById('jsonFile');
                    if (jf && jf.files && jf.files.length) {
                        alert('Bạn đã chọn một file JSON cho import. Xóa file JSON nếu muốn upload files khác.');
                        // clear the files chosen
                        e.target.value = null;
                        return;
                    }
                    document.getElementById('uploadText').innerHTML = `<span class='text-info fw-semibold'>${files.length} file(s) selected</span>`;
                    const badgeWrap = document.getElementById('fileCountBadge');
                    document.getElementById('fileCount').textContent = files.length;
                    badgeWrap.style.display = 'block';
                    renderFileList(files);
                }
            }

            function handleDrop(e) {
                e.preventDefault();
                const dtFiles = e.dataTransfer.files;
                // If JSON file is set, prevent dropping other files
                const jf = document.getElementById('jsonFile');
                if (jf && jf.files && jf.files.length) {
                    alert('Bạn đã chọn một file JSON cho import. Xóa file JSON nếu muốn upload files khác.');
                    return;
                }
                document.getElementById('files').files = dtFiles;
                if (dtFiles && dtFiles.length) {
                    document.getElementById('uploadText').innerHTML = `<span class='text-info fw-semibold'>${dtFiles.length} file(s) selected</span>`;
                    const badgeWrap = document.getElementById('fileCountBadge');
                    document.getElementById('fileCount').textContent = dtFiles.length;
                    badgeWrap.style.display = 'block';
                    renderFileList(dtFiles);
                }
            }

            // Handle dedicated JSON import file selection
            function handleJsonSelect(e) {
                const f = e.target.files;
                const fileInput = document.getElementById('files');
                if (f && f.length) {
                    // Basic check: extension
                    const name = f[0].name || '';
                    if (!name.toLowerCase().endsWith('.json')) {
                        alert('Vui lòng chọn file .json hợp lệ.');
                        e.target.value = null;
                        return;
                    }
                    // Disable multi-file input to avoid conflicts
                    if (fileInput) {
                        fileInput.value = null;
                        fileInput.required = false; // remove required so browser allows submit with only JSON
                        document.getElementById('fileCountBadge').style.display = 'none';
                        document.getElementById('fileList').innerHTML = '';
                    }
                    document.getElementById('uploadText').innerHTML = `<span class='text-warning fw-semibold'>JSON importer selected — other files disabled</span>`;
                } else {
                    // If user cleared JSON input, restore message
                    if (fileInput) fileInput.required = true; // restore required when JSON cleared
                    document.getElementById('uploadText').innerHTML = `Click to select or drag & drop multiple files<br /><small class="text-secondary">Video (MP4/MOV/WEBM), PDF, DOCX, PPTX, XLSX, Images</small><br /><small class="text-warning">Max 10 files per upload (demo limit)</small>`;
                }
            }

            // Toggle between existing course or new course + load assignments for selected course
            document.getElementById('courseSelect').addEventListener('change', async function() {
                const courseTitle = document.getElementById('courseTitle');
                const authorName = document.getElementById('authorName');
                const assignmentSelect = document.getElementById('assignmentSelect');
                
                if (this.value) {
                    // Existing course selected - make author optional
                    courseTitle.style.display = 'none';
                    courseTitle.previousElementSibling.style.display = 'none';
                    authorName.required = false;
                } else {
                    // No course selected - require new course fields
                    courseTitle.style.display = 'block';
                    courseTitle.previousElementSibling.style.display = 'block';
                    authorName.required = true;
                }

                // Fetch assignments for this course via AJAX and populate dropdown
                const courseId = this.value;
                try {
                    // Clear manual input when switching
                    document.getElementById('assignmentIdManual').value = '';
                    document.getElementById('manualAssignment').style.display = 'none';

                    // Default option
                    assignmentSelect.innerHTML = '<option value="">-- Create new assignment (default) --</option>';
                    if (!courseId) return;
                    const url = appContextPath + '/instructor/assignments-by-course?courseId=' + encodeURIComponent(courseId);
                    const res = await fetch(url, { credentials: 'same-origin' });
                    if (!res.ok) return;
                    const list = await res.json();
                    list.forEach(it => {
                        const opt = document.createElement('option');
                        opt.value = it.id;
                        opt.textContent = it.name + ' (' + it.id + ')';
                        assignmentSelect.appendChild(opt);
                    });
                } catch (err) {
                    console.error('Failed to load assignments for course', err);
                }
            });

            // Toggle manual assignment UUID input
            document.getElementById('toggleManual').addEventListener('click', function(e){
                e.preventDefault();
                var wrap = document.getElementById('manualAssignment');
                if (wrap.style.display === 'none' || wrap.style.display === '') {
                    wrap.style.display = 'block';
                } else {
                    wrap.style.display = 'none';
                    document.getElementById('assignmentIdManual').value = '';
                }
            });

            // Limit file count demo safeguard
            document.getElementById('uploadForm').addEventListener('submit', function(e){
                const fs = document.getElementById('files').files;
                if (fs.length > 10) {
                    e.preventDefault();
                    alert('Vượt quá giới hạn 10 files/lần (demo). Chọn ít hơn nhé.');
                }
            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
