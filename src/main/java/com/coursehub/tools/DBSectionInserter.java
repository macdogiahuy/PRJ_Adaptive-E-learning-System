package com.coursehub.tools;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;

/**
 * DBSectionInserter
 *
 * Utility to check Course existence and insert Sections and LectureMaterial.
 */
public class DBSectionInserter {

    // Default DB config; override with env vars DB_URL, DB_USER, DB_PASSWORD
    private static final String DEFAULT_DB_URL = System.getenv().getOrDefault("DB_URL",
            "jdbc:sqlserver://localhost:1433;databaseName=CourseHubDB11;encrypt=true;trustServerCertificate=true");
    private static final String DEFAULT_DB_USER = System.getenv().getOrDefault("DB_USER", "sa");
    private static final String DEFAULT_DB_PASSWORD = System.getenv().getOrDefault("DB_PASSWORD", "123456789");

    private static boolean courseExists(Connection conn, String courseId) throws SQLException {
        String sql = "SELECT 1 FROM Courses WHERE Id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private static boolean lectureExists(Connection conn, String lectureId) throws SQLException {
        String sql = "SELECT 1 FROM dbo.Lectures WHERE Id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, lectureId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public static boolean addLectureMaterial(String lectureId, String fileType, String googleDriveLink, String fileName)
            throws SQLException {
        try (Connection conn = DriverManager.getConnection(DEFAULT_DB_URL, DEFAULT_DB_USER, DEFAULT_DB_PASSWORD)) {
            if (!lectureExists(conn, lectureId)) {
                return false;
            }
            insertLectureMaterialLink(conn, lectureId, fileType, googleDriveLink, fileName);
            return true;
        }
    }

    private static void insertSection(Connection conn, String id, int index, String title, int lectureCount,
            String courseId) throws SQLException {
        String sql = "INSERT INTO Sections (Id, [Index], Title, LectureCount, CourseId, CreationTime, LastModificationTime) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        Timestamp now = Timestamp.from(Instant.now());
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            ps.setInt(2, index);
            ps.setString(3, title);
            ps.setInt(4, lectureCount);
            ps.setString(5, courseId);
            ps.setTimestamp(6, now);
            ps.setTimestamp(7, now);
            ps.executeUpdate();
        }
    }

    /**
     * Insert into dbo.LectureMaterial according to schema:
     * (LectureId UNIQUEIDENTIFIER, Id UNIQUEIDENTIFIER, Type NVARCHAR(50), Url NVARCHAR(500))
     */
    /**
     * Insert LectureMaterial. LectureMaterial.Id is an IDENTITY column in the DB, so we do not
     * provide an explicit Id value here; the DB will generate it.
     */
    private static volatile Boolean FILE_NAME_COLUMN_AVAILABLE = null;

    private static void insertLectureMaterialLink(Connection conn, String lectureId, String fileType,
            String link, String fileName) throws SQLException {
        // ⚠️ FIX: Bảng LectureMaterial không có cột FileName, luôn insert không có FileName
        doInsertLectureMaterial(conn, lectureId, fileType, link, fileName, false);
    }

    private static void doInsertLectureMaterial(Connection conn, String lectureId, String fileType,
            String link, String fileName, boolean includeFileName) throws SQLException {
        final String sql;
        if (includeFileName) {
            sql = "INSERT INTO dbo.LectureMaterial (LectureId, Type, Url, FileName) VALUES (?, ?, ?, ?)";
        } else {
            sql = "INSERT INTO dbo.LectureMaterial (LectureId, Type, Url) VALUES (?, ?, ?)";
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, lectureId);
            ps.setString(2, fileType == null || fileType.isBlank() ? "Video" : fileType);
            ps.setString(3, link);
            if (includeFileName) {
                if (fileName == null || fileName.isBlank()) {
                    ps.setNull(4, java.sql.Types.NVARCHAR);
                } else {
                    ps.setString(4, fileName);
                }
            }
            ps.executeUpdate();
        }
    }

    private static boolean isFileNameColumnMissing(SQLException ex) {
        String message = ex.getMessage();
        if (message == null) {
            return false;
        }
        String lower = message.toLowerCase();
        return lower.contains("filename") && lower.contains("column");
    }

    /**
     * Public helper: check Course exists and insert Section and LectureMaterial in a transaction.
     * Returns true if inserted, false if Course not found.
     * Throws SQLException on DB errors.
     */
    public static boolean insertSectionAndMaterial(String lectureId, String sectionId, int index, String title, int lectureCount,
            String courseId, String googleDriveLink, String fileType, String fileName) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DEFAULT_DB_URL, DEFAULT_DB_USER, DEFAULT_DB_PASSWORD)) {
            if (!courseExists(conn, courseId)) {
                return false;
            }

            boolean originalAutoCommit = conn.getAutoCommit();
            try {
                conn.setAutoCommit(false);
                insertSection(conn, sectionId, index, title, lectureCount, courseId);
                // Ensure LectureId exists before inserting LectureMaterial
                if (!lectureExists(conn, lectureId)) {
                    throw new SQLException("LectureId does not exist: " + lectureId);
                }
                // Save Drive link into LectureMaterial using the provided lectureId
                insertLectureMaterialLink(conn, lectureId, fileType, googleDriveLink, fileName);
                conn.commit();
                return true;
            } catch (SQLException e) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
                throw e;
            } finally {
                try { conn.setAutoCommit(originalAutoCommit); } catch (SQLException ignore) {}
            }
        }
    }

    // Optional: main for standalone testing
    public static void main(String[] args) {
        System.out.println("DBSectionInserter helper class");
    }

    // ---------- Convenience helpers to populate the upload form ----------
    public static class CourseItem {
        public final String id;
        public final String title;
        public CourseItem(String id, String title) { this.id = id; this.title = title; }
    }

    public static java.util.List<CourseItem> getCourses() throws SQLException {
        java.util.List<CourseItem> out = new java.util.ArrayList<>();
        try (Connection conn = DriverManager.getConnection(DEFAULT_DB_URL, DEFAULT_DB_USER, DEFAULT_DB_PASSWORD)) {
            String sql = "SELECT Id, Title FROM dbo.Courses ORDER BY CreationTime DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        out.add(new CourseItem(rs.getString("Id"), rs.getString("Title")));
                    }
                }
            }
        }
        return out;
    }

    /**
     * Get courses for a specific instructor (filter by InstructorId)
     */
    public static java.util.List<CourseItem> getCoursesByInstructor(String instructorId) throws SQLException {
        java.util.List<CourseItem> out = new java.util.ArrayList<>();
        try (Connection conn = DriverManager.getConnection(DEFAULT_DB_URL, DEFAULT_DB_USER, DEFAULT_DB_PASSWORD)) {
            String sql = "SELECT Id, Title FROM dbo.Courses WHERE InstructorId = ? ORDER BY CreationTime DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, instructorId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        out.add(new CourseItem(rs.getString("Id"), rs.getString("Title")));
                    }
                }
            }
        }
        return out;
    }

    public static class LectureItem {
        public final String id;
        public final String title;
        public LectureItem(String id, String title) { this.id = id; this.title = title; }
    }

    /**
     * Return lectures for a given courseId (by finding Sections for the course, then Lectures linked to those sections)
     */
    public static java.util.List<LectureItem> getLecturesForCourse(String courseId) throws SQLException {
        java.util.List<LectureItem> out = new java.util.ArrayList<>();
        try (Connection conn = DriverManager.getConnection(DEFAULT_DB_URL, DEFAULT_DB_USER, DEFAULT_DB_PASSWORD)) {
            String sql = "SELECT L.Id, L.Title FROM dbo.Lectures L WHERE L.SectionId IN (SELECT S.Id FROM dbo.Sections S WHERE S.CourseId = ?) ORDER BY L.CreationTime DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, courseId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        out.add(new LectureItem(rs.getString("Id"), rs.getString("Title")));
                    }
                }
            }
        }
        return out;
    }

    public static String getCourseTitle(String courseId) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DEFAULT_DB_URL, DEFAULT_DB_USER, DEFAULT_DB_PASSWORD)) {
            String sql = "SELECT Title FROM dbo.Courses WHERE Id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, courseId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return rs.getString("Title");
                }
            }
        }
        return null;
    }

    /**
     * Get the instructor ID of a course
     */
    public static String getCourseInstructorId(String courseId) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DEFAULT_DB_URL, DEFAULT_DB_USER, DEFAULT_DB_PASSWORD)) {
            String sql = "SELECT InstructorId FROM dbo.Courses WHERE Id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, courseId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return rs.getString("InstructorId");
                }
            }
        }
        return null;
    }

    public static class SectionItem {
        public final String id;
        public final String title;
        public SectionItem(String id, String title) { this.id = id; this.title = title; }
    }

    /**
     * Return sections for a given courseId
     */
    public static java.util.List<SectionItem> getSectionsForCourse(String courseId) throws SQLException {
        java.util.List<SectionItem> out = new java.util.ArrayList<>();
        try (Connection conn = DriverManager.getConnection(DEFAULT_DB_URL, DEFAULT_DB_USER, DEFAULT_DB_PASSWORD)) {
            String sql = "SELECT Id, Title FROM dbo.Sections WHERE CourseId = ? ORDER BY [Index] ASC";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, courseId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        out.add(new SectionItem(rs.getString("Id"), rs.getString("Title")));
                    }
                }
            }
        }
        return out;
    }

    // ---------- Assignments helper ----------
    public static class AssignmentItem {
        public final String id;
        public final String name;
        public AssignmentItem(String id, String name) { this.id = id; this.name = name; }
    }

    /**
     * Return assignments created by an instructor/creator (CreatorId)
     */
    public static java.util.List<AssignmentItem> getAssignmentsByCreator(String creatorId) throws SQLException {
        java.util.List<AssignmentItem> out = new java.util.ArrayList<>();
        try (java.sql.Connection conn = java.sql.DriverManager.getConnection(DEFAULT_DB_URL, DEFAULT_DB_USER, DEFAULT_DB_PASSWORD)) {
            String sql = "SELECT Id, Name FROM dbo.Assignments WHERE CreatorId = ? ORDER BY Name";
            try (java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, creatorId);
                try (java.sql.ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        out.add(new AssignmentItem(rs.getString("Id"), rs.getString("Name")));
                    }
                }
            }
        }
        return out;
    }

    /**
     * Return assignments for a given courseId (joins Sections -> Assignments)
     */
    public static java.util.List<AssignmentItem> getAssignmentsForCourse(String courseId) throws SQLException {
        java.util.List<AssignmentItem> out = new java.util.ArrayList<>();
        try (java.sql.Connection conn = java.sql.DriverManager.getConnection(DEFAULT_DB_URL, DEFAULT_DB_USER, DEFAULT_DB_PASSWORD)) {
            String sql = "SELECT a.Id, a.Name FROM dbo.Assignments a JOIN dbo.Sections s ON a.SectionId = s.Id WHERE s.CourseId = ? ORDER BY a.Name";
            try (java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, courseId);
                try (java.sql.ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        out.add(new AssignmentItem(rs.getString("Id"), rs.getString("Name")));
                    }
                }
            }
        }
        return out;
    }

    /**
     * Insert a new Lecture row. Caller must manage transaction/connection.
     */
    private static void insertLecture(Connection conn, String lectureId, String title, String content, String sectionId) throws SQLException {
        String sql = "INSERT INTO dbo.Lectures (Id, Title, Content, CreationTime, LastModificationTime, IsPreviewable, SectionId) VALUES (?, ?, ?, ?, ?, ?, ?)";
        Timestamp now = Timestamp.from(Instant.now());
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, lectureId);
            ps.setString(2, title);
            ps.setString(3, content == null ? "" : content);
            ps.setTimestamp(4, now);
            ps.setTimestamp(5, now);
            ps.setBoolean(6, false);
            ps.setString(7, sectionId);
            ps.executeUpdate();
        }
    }

    /**
     * Insert a new Lecture without transaction (for simple single insert from servlet)
     */
    public static void insertLecture(String lectureId, String title, String content, String sectionId) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DEFAULT_DB_URL, DEFAULT_DB_USER, DEFAULT_DB_PASSWORD)) {
            insertLecture(conn, lectureId, title, content, sectionId);
        }
    }

    /**
     * Create a Section and a Lecture (if needed) and save LectureMaterial link in one transaction.
     * Returns true if successful, false if course doesn't exist.
     */
    public static boolean createSectionLectureAndMaterial(String courseId, String sectionId, String sectionTitle,
                                                          String lectureId, String lectureTitle, String googleDriveLink,
                                                          String fileType, String fileName) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DEFAULT_DB_URL, DEFAULT_DB_USER, DEFAULT_DB_PASSWORD)) {
            if (!courseExists(conn, courseId)) {
                return false;
            }
            
            // ✅ FIX: Tìm section có sẵn hoặc tạo mới để tránh trùng lặp
            String actualSectionId = sectionId;
            String findSql = "SELECT Id FROM Sections WHERE CourseId = ? AND Title = ?";
            try (PreparedStatement ps = conn.prepareStatement(findSql)) {
                ps.setString(1, courseId);
                ps.setString(2, sectionTitle == null || sectionTitle.isBlank() ? "Section" : sectionTitle);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        actualSectionId = rs.getString("Id");
                    }
                }
            }
            
            boolean originalAuto = conn.getAutoCommit();
            try {
                conn.setAutoCommit(false);
                
                // Insert section only if not found
                if (actualSectionId.equals(sectionId)) {
                    insertSection(conn, sectionId, 1, sectionTitle == null || sectionTitle.isBlank() ? "Section" : sectionTitle, 1, courseId);
                }
                
                // Insert lecture
                insertLecture(conn, lectureId, lectureTitle == null || lectureTitle.isBlank() ? "Lecture" : lectureTitle, "", actualSectionId);
                // Insert lecture material
                insertLectureMaterialLink(conn, lectureId, fileType, googleDriveLink, fileName);
                conn.commit();
                return true;
            } catch (SQLException e) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
                throw e;
            } finally {
                try { conn.setAutoCommit(originalAuto); } catch (SQLException ignore) {}
            }
        }
    }

    public static class LectureDetails {
        public final String lectureId;
        public final String lectureTitle;
        public final String sectionId;
        public final String sectionTitle;

        public LectureDetails(String lectureId, String lectureTitle, String sectionId, String sectionTitle) {
            this.lectureId = lectureId;
            this.lectureTitle = lectureTitle;
            this.sectionId = sectionId;
            this.sectionTitle = sectionTitle;
        }
    }

    public static LectureDetails getLectureDetails(String lectureId) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DEFAULT_DB_URL, DEFAULT_DB_USER, DEFAULT_DB_PASSWORD)) {
            String sql = "SELECT L.Id, L.Title AS LectureTitle, S.Id AS SectionId, S.Title AS SectionTitle "
                    + "FROM dbo.Lectures L JOIN dbo.Sections S ON L.SectionId = S.Id WHERE L.Id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, lectureId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return new LectureDetails(
                                rs.getString("Id"),
                                rs.getString("LectureTitle"),
                                rs.getString("SectionId"),
                                rs.getString("SectionTitle"));
                    }
                }
            }
        }
        return null;
    }

    /**
     * Find existing section by title or create new one
     */
    public static String findOrCreateSection(String courseId, String sectionTitle) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DEFAULT_DB_URL, DEFAULT_DB_USER, DEFAULT_DB_PASSWORD)) {
            // Try to find existing section
            String findSql = "SELECT Id FROM Sections WHERE CourseId = ? AND Title = ?";
            try (PreparedStatement ps = conn.prepareStatement(findSql)) {
                ps.setString(1, courseId);
                ps.setString(2, sectionTitle);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getString("Id");
                    }
                }
            }
            
            // Create new section if not found
            String newSectionId = java.util.UUID.randomUUID().toString();
            insertSection(conn, newSectionId, 1, sectionTitle, 1, courseId);
            return newSectionId;
        }
    }

    /**
     * Create a new Course + Section + Lecture in one transaction.
     * Uses default values for LeafCategoryId.
     * InstructorId is passed (must be a valid Instructor ID from dbo.Instructors)
     * CreatorId is the user who is creating the course
     */
    public static void createCourseWithSectionAndLecture(String courseId, String courseName,
                                                         String sectionId, String sectionName,
                                                         String lectureId, String lectureName,
                                                         String instructorId, String creatorId) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DEFAULT_DB_URL, DEFAULT_DB_USER, DEFAULT_DB_PASSWORD)) {
            boolean originalAuto = conn.getAutoCommit();
            try {
                conn.setAutoCommit(false);

                // Get a default leaf category ID (first available or use a default)
                String leafCategoryId = getDefaultLeafCategoryId(conn);

                // Insert Course with passed instructorId and creatorId
                insertCourse(conn, courseId, courseName, leafCategoryId, instructorId, creatorId);

                // Insert Section
                insertSection(conn, sectionId, 1, sectionName == null || sectionName.isBlank() ? "Section" : sectionName, 1, courseId);

                // Insert Lecture
                insertLecture(conn, lectureId, lectureName == null || lectureName.isBlank() ? "Lecture" : lectureName, "", sectionId);

                conn.commit();
            } catch (SQLException e) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
                throw e;
            } finally {
                try { conn.setAutoCommit(originalAuto); } catch (SQLException ignore) {}
            }
        }
    }

    /**
     * Overload for backwards compatibility: create course with single ID
     */
    public static void createCourseWithSectionAndLecture(String courseId, String courseName,
                                                         String sectionId, String sectionName,
                                                         String lectureId, String lectureName,
                                                         String creatorId) throws SQLException {
        // Use creatorId for both instructor and creator (fallback)
        createCourseWithSectionAndLecture(courseId, courseName, sectionId, sectionName, lectureId, lectureName, creatorId, creatorId);
    }

    /**
     * Get default leaf category ID (first one from Categories table)
     */
    private static String getDefaultLeafCategoryId(Connection conn) throws SQLException {
        String sql = "SELECT TOP 1 Id FROM dbo.Categories WHERE IsLeaf = 1 ORDER BY CourseCount DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("Id");
                }
            }
        }
        // Fallback: return a placeholder if no category found
        return "00000000-0000-0000-0000-000000000000";
    }

    /**
     * Insert a new Course with default values
     */
    private static void insertCourse(Connection conn, String courseId, String courseName,
                                     String leafCategoryId, String instructorId, String creatorId) throws SQLException {
        String sql = "INSERT INTO dbo.Courses " +
                "(Id, Title, MetaTitle, ThumbUrl, Intro, Description, Status, Price, Discount, DiscountExpiry, " +
                "Level, Outcomes, Requirements, LectureCount, LearnerCount, RatingCount, TotalRating, " +
                "CreationTime, LastModificationTime, LastModifierId, LeafCategoryId, InstructorId, CreatorId) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Timestamp now = Timestamp.from(Instant.now());
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, courseId);
            ps.setString(2, courseName);
            ps.setString(3, courseName.replaceAll(" ", "-").toLowerCase()); // MetaTitle
            ps.setString(4, "/assets/images/default-course.jpg"); // ThumbUrl
            ps.setString(5, ""); // Intro
            ps.setString(6, ""); // Description
            ps.setString(7, "pending"); // Status
            ps.setDouble(8, 0.0); // Price
            ps.setDouble(9, 0.0); // Discount
            ps.setTimestamp(10, now); // DiscountExpiry
            ps.setString(11, "Beginner"); // Level
            ps.setString(12, ""); // Outcomes
            ps.setString(13, ""); // Requirements
            ps.setShort(14, (short) 1); // LectureCount
            ps.setInt(15, 0); // LearnerCount
            ps.setInt(16, 0); // RatingCount
            ps.setLong(17, 0); // TotalRating
            ps.setTimestamp(18, now); // CreationTime
            ps.setTimestamp(19, now); // LastModificationTime
            ps.setString(20, creatorId); // LastModifierId
            ps.setString(21, leafCategoryId); // LeafCategoryId
            ps.setString(22, instructorId); // InstructorId
            ps.setString(23, creatorId); // CreatorId
            ps.executeUpdate();
        }
    }
}
