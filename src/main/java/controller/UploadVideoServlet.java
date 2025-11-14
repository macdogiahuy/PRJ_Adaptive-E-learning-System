package controller;

import com.google.api.client.auth.oauth2.Credential;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import utils.CredentialManager;
import utils.DriveService;

@MultipartConfig 
@WebServlet(urlPatterns = {
    "/instructor/upload-video",
    "/instructor/upload-form"
})
public class UploadVideoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        
        // Load courses for the dropdown
        try {
            java.util.List<com.coursehub.tools.DBSectionInserter.CourseItem> courses = 
                com.coursehub.tools.DBSectionInserter.getCourses();
            request.setAttribute("courses", courses);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("courses", java.util.Collections.emptyList());
        }
        
        // Forward to upload form
        // Also load assignments for the current user (if available)
        model.Users current = (model.Users) request.getSession().getAttribute("account");
        try {
            if (current != null && current.getId() != null) {
                java.util.List<com.coursehub.tools.DBSectionInserter.AssignmentItem> assigns =
                        com.coursehub.tools.DBSectionInserter.getAssignmentsByCreator(current.getId());
                request.setAttribute("assignments", assigns);
            } else {
                request.setAttribute("assignments", java.util.Collections.emptyList());
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("assignments", java.util.Collections.emptyList());
        }

        request.getRequestDispatcher("/WEB-INF/views/Pages/instructor/upload-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        // 1. Validate user authentication
        model.Users currentUser = (model.Users) request.getSession().getAttribute("account");
        if (currentUser == null || currentUser.getId() == null) {
            request.setAttribute("dbMsg", "❌ Bạn cần đăng nhập trước khi upload.");
            loadCoursesAndForward(request, response);
            return;
        }

        // 2. Get form parameters
        String courseId = request.getParameter("courseId");
        String courseTitle = request.getParameter("courseTitle");
        String authorName = request.getParameter("authorName");
        String sectionTitle = request.getParameter("sectionTitle");
        String lectureTitle = request.getParameter("lectureTitle");
        // If the instructor used the dedicated JSON importer field, prefer that and do not require other files
        Part jsonPart = null;
        try {
            jsonPart = request.getPart("jsonFile");
        } catch (IllegalStateException | IOException | ServletException ignored) {
            // ignore - no json part
        }

        if (jsonPart != null && jsonPart.getSize() > 0) {
            // Only instructors are allowed to import MCQ JSON files
            try {
                if (currentUser.getRole() == null || !"Instructor".equalsIgnoreCase(currentUser.getRole())) {
                    request.setAttribute("dbMsg", "❌ Chỉ người có quyền Instructor mới được import JSON.");
                    loadCoursesAndForward(request, response);
                    return;
                }
            } catch (Exception ignore) {
                // If any unexpected nulls, deny and forward
                request.setAttribute("dbMsg", "❌ Không đủ quyền để import JSON.");
                loadCoursesAndForward(request, response);
                return;
            }
            // Validate basic JSON mime/extension
            String jfName = jsonPart.getSubmittedFileName();
            String jfType = jsonPart.getContentType();
            if ((jfName == null || !jfName.toLowerCase().endsWith(".json")) && (jfType == null || !jfType.toLowerCase().contains("json"))) {
                request.setAttribute("dbMsg", "❌ Vui lòng chọn file .json hợp lệ trong ô Import MCQ JSON.");
                loadCoursesAndForward(request, response);
                return;
            }

            // Validate course/fields required for creating assignment if needed
            if ((courseId == null || courseId.isBlank()) && (courseTitle == null || courseTitle.isBlank())) {
                request.setAttribute("dbMsg", "❌ Vui lòng chọn khóa học có sẵn hoặc nhập tên khóa học mới.");
                loadCoursesAndForward(request, response);
                return;
            }

            if (sectionTitle == null || sectionTitle.isBlank() || lectureTitle == null || lectureTitle.isBlank()) {
                request.setAttribute("dbMsg", "❌ Vui lòng nhập đầy đủ tên Section và Lecture.");
                loadCoursesAndForward(request, response);
                return;
            }

            // Author name is only required for new courses
            if ((courseId == null || courseId.isBlank()) && (authorName == null || authorName.isBlank())) {
                request.setAttribute("dbMsg", "❌ Vui lòng nhập tên tác giả khi tạo khóa học mới.");
                loadCoursesAndForward(request, response);
                return;
            }

            // Process JSON import (similar to previous flow)
            try {
                // role re-check before proceeding (defense-in-depth)
                if (currentUser.getRole() == null || !"Instructor".equalsIgnoreCase(currentUser.getRole())) {
                    request.setAttribute("dbMsg", "❌ Chỉ người có quyền Instructor mới được import JSON.");
                    loadCoursesAndForward(request, response);
                    return;
                }
                String assignmentId = request.getParameter("assignmentId");
                String manual = request.getParameter("assignmentIdManual");
                if (manual != null && !manual.isBlank()) assignmentId = manual.trim();

                if (assignmentId == null || assignmentId.isBlank()) {
                    String targetCourseId = courseId;
                    if (targetCourseId == null || targetCourseId.isBlank()) {
                        targetCourseId = createNewCourse(courseTitle, authorName, currentUser.getId());
                        request.setAttribute("driveMsg", "✅ Đã tạo khóa học mới: " + courseTitle);
                    }
                    assignmentId = createNewAssignment(targetCourseId, lectureTitle, currentUser.getId());
                    request.setAttribute("dbMsg", "✅ Đã tạo Assignment mới: " + assignmentId);
                }

                java.io.File tmp = java.io.File.createTempFile("import-", ".json");
                try (java.io.InputStream is = jsonPart.getInputStream(); java.io.FileOutputStream fos = new java.io.FileOutputStream(tmp)) {
                    byte[] buf = new byte[8192]; int r;
                    while ((r = is.read(buf)) > 0) fos.write(buf, 0, r);
                }

                try {
                    int imported = com.coursehub.tools.JsonAssignmentImporter.importFileToAssignment(assignmentId, tmp.getAbsolutePath());
                    request.setAttribute("dbMsg", "✅ Đã lưu " + imported + " câu hỏi vào Assignment: " + assignmentId);
                } catch (Exception ex) {
                    ex.printStackTrace();
                    request.setAttribute("dbMsg", "❌ Lỗi khi import JSON vào DB: " + ex.getMessage());
                } finally {
                    try { tmp.delete(); } catch (Exception ignore) {}
                }

                loadCoursesAndForward(request, response);
                return;
            } catch (Exception ex) {
                ex.printStackTrace();
                request.setAttribute("dbMsg", "❌ Lỗi khi import JSON: " + ex.getMessage());
                loadCoursesAndForward(request, response);
                return;
            }
        }

        // MULTI-FILE SUPPORT: collect parts named 'files' (new) or legacy 'videoFile'
        java.util.List<Part> fileParts = new java.util.ArrayList<>();
        for (Part p : request.getParts()) {
            String name = p.getName();
            if (("files".equals(name) || "videoFile".equals(name)) && p.getSize() > 0) {
                fileParts.add(p);
            }
        }

        // 3. Validate required fields
        if (fileParts.isEmpty()) {
            request.setAttribute("dbMsg", "⚠️ Chưa chọn file để tải lên.");
            loadCoursesAndForward(request, response);
            return;
        }

        if ((courseId == null || courseId.isBlank()) && (courseTitle == null || courseTitle.isBlank())) {
            request.setAttribute("dbMsg", "❌ Vui lòng chọn khóa học có sẵn hoặc nhập tên khóa học mới.");
            loadCoursesAndForward(request, response);
            return;
        }

        if (sectionTitle == null || sectionTitle.isBlank() || lectureTitle == null || lectureTitle.isBlank()) {
            request.setAttribute("dbMsg", "❌ Vui lòng nhập đầy đủ tên Section và Lecture.");
            loadCoursesAndForward(request, response);
            return;
        }

        // Author name is only required for new courses
        if ((courseId == null || courseId.isBlank()) && (authorName == null || authorName.isBlank())) {
            request.setAttribute("dbMsg", "❌ Vui lòng nhập tên tác giả khi tạo khóa học mới.");
            loadCoursesAndForward(request, response);
            return;
        }

        // 4. Process file upload workflow
    // Use first file as primary (creates lecture). Others become attachments.
    Part primaryPart = fileParts.get(0);
    String originalFileName = primaryPart.getSubmittedFileName();
    String lowerName = originalFileName == null ? "" : originalFileName.toLowerCase();
    boolean isJsonUpload = lowerName.endsWith(".json") || (primaryPart.getContentType() != null && primaryPart.getContentType().toLowerCase().contains("json"));
        
        try {
            // Special handling: JSON import -> save into Assignment (no Drive upload)
            if (isJsonUpload) {
                // Ensure only instructors can upload JSON via the files input
                if (currentUser.getRole() == null || !"Instructor".equalsIgnoreCase(currentUser.getRole())) {
                    request.setAttribute("dbMsg", "❌ Chỉ người có quyền Instructor mới được import JSON.");
                    loadCoursesAndForward(request, response);
                    return;
                }
                // Determine assignmentId from form (select dropdown or pasted UUID)
                String assignmentId = request.getParameter("assignmentId");
                String manual = request.getParameter("assignmentIdManual");
                if (manual != null && !manual.isBlank()) assignmentId = manual.trim();

                // If empty, create a new assignment attached to the selected course (or new course created above)
                if (assignmentId == null || assignmentId.isBlank()) {
                    // Ensure course exists (finalCourseId may have been created earlier)
                    String targetCourseId = courseId;
                    if (targetCourseId == null || targetCourseId.isBlank()) {
                        // create a course if not provided
                        targetCourseId = createNewCourse(courseTitle, authorName, currentUser.getId());
                        request.setAttribute("driveMsg", "✅ Đã tạo khóa học mới: " + courseTitle);
                    }
                    assignmentId = createNewAssignment(targetCourseId, lectureTitle, currentUser.getId());
                    request.setAttribute("dbMsg", "✅ Đã tạo Assignment mới: " + assignmentId);
                }

                // Save uploaded JSON to temp file and import
                java.io.File tmp = java.io.File.createTempFile("import-", ".json");
                try (java.io.InputStream is = primaryPart.getInputStream(); java.io.FileOutputStream fos = new java.io.FileOutputStream(tmp)) {
                    byte[] buf = new byte[8192]; int r;
                    while ((r = is.read(buf)) > 0) fos.write(buf, 0, r);
                }

                try {
                    int imported = com.coursehub.tools.JsonAssignmentImporter.importFileToAssignment(assignmentId, tmp.getAbsolutePath());
                    request.setAttribute("dbMsg", "✅ Đã lưu " + imported + " câu hỏi vào Assignment: " + assignmentId);
                } catch (Exception ex) {
                    ex.printStackTrace();
                    request.setAttribute("dbMsg", "❌ Lỗi khi import JSON vào DB: " + ex.getMessage());
                } finally {
                    try { tmp.delete(); } catch (Exception ignore) {}
                }

                // reload form with assignments and messages
                loadCoursesAndForward(request, response);
                return;
            }

            // Step 1: Create/Get Course
            String finalCourseId = courseId;
            if (finalCourseId == null || finalCourseId.isBlank()) {
                finalCourseId = createNewCourse(courseTitle, authorName, currentUser.getId());
                request.setAttribute("driveMsg", "✅ Đã tạo khóa học mới: " + courseTitle);
            }

            // Step 2: Upload to Google Drive with proper folder structure
            String driveFileId = uploadToGoogleDrive(primaryPart, finalCourseId, sectionTitle, lectureTitle, originalFileName);
            
            if (driveFileId == null) {
                request.setAttribute("driveMsg", "❌ Upload lên Google Drive thất bại.");
                loadCoursesAndForward(request, response);
                return;
            }

            // Step 3: Save to Database
            // Detect display file type for badge (normalize from MIME or extension)
            String displayType = detectDisplayType(primaryPart.getContentType(), originalFileName);

            String lectureId = saveLectureToDatabase(finalCourseId, sectionTitle, lectureTitle, driveFileId, originalFileName, displayType);
            if (lectureId == null) {
                request.setAttribute("dbMsg", "❌ Không tạo được lecture đầu tiên.");
                loadCoursesAndForward(request, response);
                return;
            }

            // Process remaining files as additional materials
            if (fileParts.size() > 1) {
                int successAttach = 0;
                for (int i = 1; i < fileParts.size(); i++) {
                    Part extra = fileParts.get(i);
                    String fname = extra.getSubmittedFileName();
                    try (InputStream is = extra.getInputStream()) {
                        String courseTitleResolved;
                        try { courseTitleResolved = com.coursehub.tools.DBSectionInserter.getCourseTitle(finalCourseId); }
                        catch (Exception ex) { courseTitleResolved = "Course_" + finalCourseId; }
                        Credential cred = CredentialManager.getAdminCredential();
                        if (cred == null) throw new Exception("Missing Drive credential");
                        String folderId = DriveService.ensureCourseFolderHierarchy(cred, courseTitleResolved, sectionTitle, lectureTitle);
                        String fileId = DriveService.uploadFile(is, extra.getContentType(), cred, folderId, fname);
                        DriveService.setFilePublic(fileId, cred);
                        String embed = DriveService.getEmbedUrl(fileId);
                        String typeLabel = detectDisplayType(extra.getContentType(), fname);
                        com.coursehub.tools.DBSectionInserter.addLectureMaterial(lectureId, typeLabel, embed, fname);
                        successAttach++;
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        // continue with other files
                    }
                }
                request.setAttribute("driveMsg", "✅ Upload " + fileParts.size() + " files. Tài liệu phụ: " + successAttach);
            }

            // Set a flash message so course-player can show a success alert after redirect
            try {
                HttpSession sess = request.getSession();
                String fm = "✅ Upload thành công cho khóa học: " + finalCourseId + ". Lecture: " + lectureId;
                sess.setAttribute("flashMsg", fm);
                sess.setAttribute("flashType", "success");
            } catch (Exception ignore) {}
            response.sendRedirect(request.getContextPath() + "/course-player?id=" + finalCourseId);
            return;

        } catch (Exception e) {
            e.printStackTrace();
            
            String errorMsg = "❌ Lỗi: " + e.getMessage();
            
            // Check if it's an OAuth error
            if (e.getMessage() != null && e.getMessage().contains("Refresh Token")) {
                errorMsg = "❌ Lỗi xác thực Google Drive: Refresh Token chưa được cấu hình.<br>"
                        + "🔧 <strong>Giải pháp:</strong> Truy cập <a href='/Adaptive_Elearning/auth/drive' target='_blank'>link này</a> "
                        + "để lấy Refresh Token mới.";
            } else if (e.getMessage() != null && (e.getMessage().contains("invalid_grant") || e.getMessage().contains("400"))) {
                errorMsg = "❌ Lỗi xác thực Google Drive: Token đã hết hạn hoặc không hợp lệ.<br>"
                        + "🔧 <strong>Giải pháp:</strong> Truy cập <a href='/Adaptive_Elearning/auth/drive' target='_blank'>link này</a> "
                        + "để lấy Refresh Token mới, sau đó cập nhật vào file <code>src/conf/env.properties</code> và restart server.";
            }
            
            request.setAttribute("dbMsg", errorMsg);
        }

        loadCoursesAndForward(request, response);
    }



    /**
     * Load courses and forward to upload form
     */
    private void loadCoursesAndForward(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            java.util.List<com.coursehub.tools.DBSectionInserter.CourseItem> courses = 
                com.coursehub.tools.DBSectionInserter.getCourses();
            request.setAttribute("courses", courses);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("courses", java.util.Collections.emptyList());
        }
        request.getRequestDispatcher("/WEB-INF/views/Pages/instructor/upload-form.jsp").forward(request, response);
    }

    /**
     * Create new course in database
     */
    private String createNewCourse(String courseTitle, String authorName, String creatorId) throws Exception {
        // Generate unique course ID
        String courseId = java.util.UUID.randomUUID().toString();
        
        // Use existing method to create course with initial section and lecture
        String sectionId = java.util.UUID.randomUUID().toString();
        String lectureId = java.util.UUID.randomUUID().toString();
        
        com.coursehub.tools.DBSectionInserter.createCourseWithSectionAndLecture(
            courseId, courseTitle, sectionId, "Introduction", 
            lectureId, "Welcome", creatorId, creatorId
        );
        
        return courseId;
    }

    /**
     * Create a minimal Assignment in dbo.Assignments and return its Id.
     * Associates the assignment with an existing or newly created Section under the given course.
     */
    private String createNewAssignment(String courseId, String assignmentName, String creatorId) throws Exception {
        if (assignmentName == null || assignmentName.isBlank()) assignmentName = "Imported Assignment";
        String assignmentId = java.util.UUID.randomUUID().toString();
        // find or create a section to attach assignment
        String sectionId = com.coursehub.tools.DBSectionInserter.findOrCreateSection(courseId, "Assignments");

        try (java.sql.Connection conn = dao.DBConnection.getConnection()) {
            String sql = "INSERT INTO dbo.Assignments (Id, Name, Duration, QuestionCount, GradeToPass, SectionId, CreatorId) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, assignmentId);
                ps.setString(2, assignmentName);
                ps.setInt(3, 30); // default duration
                ps.setInt(4, 0);
                ps.setDouble(5, 0.0);
                ps.setString(6, sectionId);
                ps.setString(7, creatorId);
                ps.executeUpdate();
            }
            return assignmentId;
        }
    }

    /**
     * Upload file to Google Drive with proper folder structure
     */
    private String uploadToGoogleDrive(Part videoPart, String courseId, String sectionTitle, 
                                     String lectureTitle, String fileName) throws Exception {
        
        // Get course title for folder structure
        String courseTitle;
        try {
            courseTitle = com.coursehub.tools.DBSectionInserter.getCourseTitle(courseId);
        } catch (Exception e) {
            courseTitle = "Course_" + courseId;
        }
        
        // Get Google Drive credentials
        Credential credential = CredentialManager.getAdminCredential();
        if (credential == null) {
            throw new Exception("Google Drive credentials not available");
        }

        // Create folder hierarchy and upload file
        try (InputStream fileStream = videoPart.getInputStream()) {
            String targetFolderId = DriveService.ensureCourseFolderHierarchy(credential,
                    courseTitle, sectionTitle, lectureTitle);
            
            String driveFileId = DriveService.uploadFile(fileStream, videoPart.getContentType(), 
                    credential, targetFolderId, fileName);
            
            // Set file to public for viewing
            DriveService.setFilePublic(driveFileId, credential);
            
            return driveFileId;
        }
    }

    /**
     * Save lecture information to database
     */
    private String saveLectureToDatabase(String courseId, String sectionTitle, String lectureTitle, 
                                       String driveFileId, String fileName, String displayType) throws Exception {
        
        // Generate Google Drive embed URL for course player
        String embedUrl = DriveService.getEmbedUrl(driveFileId);
        
        // Generate unique IDs
        String sectionId = java.util.UUID.randomUUID().toString();
        String lectureId = java.util.UUID.randomUUID().toString();
        
        // Use DBSectionInserter to create complete lecture with material
        boolean success = com.coursehub.tools.DBSectionInserter.createSectionLectureAndMaterial(
            courseId, sectionId, sectionTitle, lectureId, lectureTitle, embedUrl, displayType, fileName
        );
        
        return success ? lectureId : null;
    }

    /**
     * Map MIME or filename extension to a short display type for badge.
     */
    private String detectDisplayType(String mime, String fileName) {
        String lowerMime = mime == null ? "" : mime.toLowerCase();
        String lowerName = fileName == null ? "" : fileName.toLowerCase();

        // Video
        if (lowerMime.startsWith("video/") || lowerName.endsWith(".mp4") || lowerName.endsWith(".mov") || lowerName.endsWith(".mkv")) {
            return "Video";
        }
        // PDF
        if (lowerMime.equals("application/pdf") || lowerName.endsWith(".pdf")) {
            return "PDF";
        }
        // Word
        if (lowerName.endsWith(".doc") || lowerName.endsWith(".docx") || lowerMime.contains("msword") || lowerMime.contains("wordprocessingml")) {
            return "DOCX";
        }
        // PowerPoint
        if (lowerName.endsWith(".ppt") || lowerName.endsWith(".pptx") || lowerMime.contains("presentation") || lowerMime.contains("powerpoint")) {
            return "PPT";
        }
        // Excel / Sheets
        if (lowerName.endsWith(".xls") || lowerName.endsWith(".xlsx") || lowerMime.contains("spreadsheet") || lowerMime.contains("excel")) {
            return "XLS";
        }
        // Image
        if (lowerMime.startsWith("image/") || lowerName.matches(".*\\.(png|jpg|jpeg|gif|webp)$")) {
            return "Ảnh";
        }
        // Text
        if (lowerMime.startsWith("text/") || lowerName.endsWith(".txt") || lowerName.endsWith(".md")) {
            return "Text";
        }
        return "Tài liệu"; // fallback
    }
}
