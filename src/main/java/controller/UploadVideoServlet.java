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
        
        try {
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
