package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.coursehub.tools.DBSectionInserter;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.model.File;
import com.google.api.services.drive.model.FileList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.CredentialManager;
import utils.DriveService;

/**
 * Servlet tự động đồng bộ video từ Google Drive xuống database
 * Quét thư mục Drive theo cấu trúc: CourseHubVideo > Course > Section > Lecture
 * Tự động tạo entries trong LectureMaterial cho video mới
 */
@WebServlet("/admin/auto-sync-drive")
public class AutoSyncDriveServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(AutoSyncDriveServlet.class.getName());

    // Cache để tránh query DB nhiều lần
    private static Map<String, String> courseNameToIdCache = new HashMap<>();
    private static Map<String, Map<String, String>> sectionCache = new HashMap<>(); // courseId -> sectionName ->
                                                                                    // sectionId
    private static Map<String, Map<String, String>> lectureCache = new HashMap<>(); // sectionId -> lectureName ->
                                                                                    // lectureId

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin permission
        model.Users currentUser = (model.Users) request.getSession().getAttribute("account");
        if (currentUser == null || !"Admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required");
            return;
        }

        StringBuilder syncLog = new StringBuilder();
        int videosProcessed = 0;
        int videosAdded = 0;

        try {
            Credential credential = CredentialManager.getAdminCredential();
            Drive driveService = DriveService.getDriveService(credential);

            // Refresh caches
            refreshCaches();

            // Quét thư mục CourseHubVideo
            String rootFolderId = DriveService.COURSE_VIDEO_FOLDER_ID;
            syncLog.append("🔍 Bắt đầu quét thư mục CourseHubVideo...\n");

            // Lấy danh sách course folders
            List<File> courseFolders = getSubfolders(driveService, rootFolderId);

            for (File courseFolder : courseFolders) {
                String courseName = courseFolder.getName();
                syncLog.append(String.format("\n📚 Course: %s\n", courseName));

                // Tìm hoặc tạo course trong DB
                String courseId = findOrCreateCourse(courseName);
                if (courseId == null) {
                    syncLog.append("  ❌ Không tìm thấy course trong DB\n");
                    continue;
                }

                // Quét sections trong course
                List<File> sectionFolders = getSubfolders(driveService, courseFolder.getId());

                for (File sectionFolder : sectionFolders) {
                    String sectionName = sectionFolder.getName();
                    syncLog.append(String.format("  📖 Section: %s\n", sectionName));

                    // Tìm hoặc tạo section
                    String sectionId = findOrCreateSection(courseId, sectionName);

                    // Quét lectures trong section
                    List<File> lectureFolders = getSubfolders(driveService, sectionFolder.getId());

                    for (File lectureFolder : lectureFolders) {
                        String lectureName = lectureFolder.getName();
                        syncLog.append(String.format("    🎥 Lecture: %s\n", lectureName));

                        // Tìm hoặc tạo lecture
                        String lectureId = findOrCreateLecture(sectionId, lectureName);

                        // Quét video files trong lecture folder
                        List<File> videoFiles = getVideoFiles(driveService, lectureFolder.getId());

                        for (File videoFile : videoFiles) {
                            videosProcessed++;
                            String fileName = videoFile.getName();
                            String fileId = videoFile.getId();

                            // Kiểm tra xem video đã có trong DB chưa
                            if (!isVideoExistsInDB(lectureId, fileId)) {
                                // Thêm video mới vào DB
                                String embedUrl = DriveService.getEmbedUrl(fileId);

                                try {
                                    // Đảm bảo file được share public
                                    DriveService.setFilePublic(fileId, credential);

                                    // Thêm vào LectureMaterial
                                    boolean success = DBSectionInserter.addLectureMaterial(
                                            lectureId, "Video", embedUrl, fileName);

                                    if (success) {
                                        videosAdded++;
                                        syncLog.append(String.format("      ✅ Đã thêm: %s\n", fileName));
                                    } else {
                                        syncLog.append(String.format("      ❌ Lỗi thêm: %s\n", fileName));
                                    }
                                } catch (Exception e) {
                                    syncLog.append(
                                            String.format("      ❌ Exception: %s - %s\n", fileName, e.getMessage()));
                                    logger.log(Level.WARNING, "Error adding video: " + fileName, e);
                                }
                            } else {
                                syncLog.append(String.format("      ⏭️ Đã tồn tại: %s\n", fileName));
                            }
                        }
                    }
                }
            }

            syncLog.append(String.format("\n🎯 Hoàn thành! Đã xử lý %d video, thêm mới %d video.\n",
                    videosProcessed, videosAdded));

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Auto sync failed", e);
            syncLog.append("❌ Lỗi: ").append(e.getMessage()).append("\n");
        }

        // Trả về kết quả
        request.setAttribute("syncLog", syncLog.toString());
        request.setAttribute("videosProcessed", videosProcessed);
        request.setAttribute("videosAdded", videosAdded);
        request.getRequestDispatcher("/WEB-INF/views/Pages/admin/sync-result.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị form sync
        request.getRequestDispatcher("/WEB-INF/views/Pages/admin/auto-sync-form.jsp").forward(request, response);
    }

    private List<File> getSubfolders(Drive driveService, String parentId) throws IOException {
        String query = String.format(
                "'%s' in parents and mimeType='application/vnd.google-apps.folder' and trashed=false", parentId);
        FileList result = driveService.files().list()
                .setQ(query)
                .setFields("files(id,name)")
                .execute();
        return result.getFiles() != null ? result.getFiles() : new ArrayList<>();
    }

    private List<File> getVideoFiles(Drive driveService, String parentId) throws IOException {
        String query = String.format(
                "'%s' in parents and (mimeType contains 'video/' or name contains '.mp4' or name contains '.avi' or name contains '.mov') and trashed=false",
                parentId);
        FileList result = driveService.files().list()
                .setQ(query)
                .setFields("files(id,name,mimeType)")
                .execute();
        return result.getFiles() != null ? result.getFiles() : new ArrayList<>();
    }

    private void refreshCaches() throws SQLException {
        courseNameToIdCache.clear();
        sectionCache.clear();
        lectureCache.clear();

        // Cache courses
        List<DBSectionInserter.CourseItem> courses = DBSectionInserter.getCourses();
        for (DBSectionInserter.CourseItem course : courses) {
            courseNameToIdCache.put(course.title, course.id);
        }
    }

    private String findOrCreateCourse(String courseName) throws SQLException {
        // Thử tìm trong cache trước
        String courseId = courseNameToIdCache.get(courseName);
        if (courseId != null) {
            return courseId;
        }

        // Thử tìm course gần giống nhất
        for (Map.Entry<String, String> entry : courseNameToIdCache.entrySet()) {
            if (entry.getKey().toLowerCase().contains(courseName.toLowerCase()) ||
                    courseName.toLowerCase().contains(entry.getKey().toLowerCase())) {
                return entry.getValue();
            }
        }

        return null; // Không tìm thấy - cần tạo manually hoặc có logic tạo tự động
    }

    private String findOrCreateSection(String courseId, String sectionName) throws SQLException {
        Map<String, String> courseSections = sectionCache.get(courseId);
        if (courseSections == null) {
            courseSections = new HashMap<>();
            sectionCache.put(courseId, courseSections);

            // Load sections cho course này
            List<DBSectionInserter.SectionItem> sections = DBSectionInserter.getSectionsForCourse(courseId);
            for (DBSectionInserter.SectionItem section : sections) {
                courseSections.put(section.title, section.id);
            }
        }

        String sectionId = courseSections.get(sectionName);
        if (sectionId != null) {
            return sectionId;
        }

        // Tạo section mới
        sectionId = UUID.randomUUID().toString();
        try (Connection conn = getDBConnection()) {

            String sql = "INSERT INTO Sections (Id, [Index], Title, LectureCount, CourseId, CreationTime, LastModificationTime) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, sectionId);
                ps.setInt(2, courseSections.size() + 1);
                ps.setString(3, sectionName);
                ps.setInt(4, 0);
                ps.setString(5, courseId);
                Timestamp now = new Timestamp(System.currentTimeMillis());
                ps.setTimestamp(6, now);
                ps.setTimestamp(7, now);
                ps.executeUpdate();
            }

            courseSections.put(sectionName, sectionId);
            return sectionId;
        } catch (Exception e) {
            logger.log(Level.WARNING, "Failed to create section: " + sectionName, e);
            return null;
        }
    }

    private String findOrCreateLecture(String sectionId, String lectureName) throws SQLException {
        Map<String, String> sectionLectures = lectureCache.get(sectionId);
        if (sectionLectures == null) {
            sectionLectures = new HashMap<>();
            lectureCache.put(sectionId, sectionLectures);

            // Load lectures cho section này
            try (Connection conn = getDBConnection()) {

                String sql = "SELECT Id, Title FROM dbo.Lectures WHERE SectionId = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, sectionId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            sectionLectures.put(rs.getString("Title"), rs.getString("Id"));
                        }
                    }
                }
            } catch (Exception e) {
                logger.log(Level.WARNING, "Failed to load lectures for section: " + sectionId, e);
            }
        }

        String lectureId = sectionLectures.get(lectureName);
        if (lectureId != null) {
            return lectureId;
        }

        // Tạo lecture mới
        lectureId = UUID.randomUUID().toString();
        try {
            DBSectionInserter.insertLecture(lectureId, lectureName, "", sectionId);
            sectionLectures.put(lectureName, lectureId);
            return lectureId;
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Failed to create lecture: " + lectureName, e);
            return null;
        }
    }

    private Connection getDBConnection() throws SQLException {
        String dbUrl = System.getenv().getOrDefault("DB_URL",
                "jdbc:sqlserver://localhost:1433;databaseName=CourseHubDB;encrypt=true;trustServerCertificate=true");
        String dbUser = System.getenv().getOrDefault("DB_USER", "sa");
        String dbPassword = System.getenv().getOrDefault("DB_PASSWORD", "123456");
        return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
    }

    private boolean isVideoExistsInDB(String lectureId, String fileId) throws SQLException {
        try (Connection conn = getDBConnection()) {

            String sql = "SELECT COUNT(*) FROM dbo.LectureMaterial WHERE LectureId = ? AND Url LIKE ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, lectureId);
                ps.setString(2, "%/d/" + fileId + "/%");
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }
        } catch (Exception e) {
            logger.log(Level.WARNING, "Failed to check video existence", e);
        }
        return false;
    }
}