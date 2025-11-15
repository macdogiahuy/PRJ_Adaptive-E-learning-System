package servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;
import dao.DBConnection;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet(name = "CoursePlayerServletJDBC", urlPatterns = {"/course-player"})
public class CoursePlayerServletJDBC extends HttpServlet {

    private static final Logger logger = Logger.getLogger(CoursePlayerServletJDBC.class.getName());

    /** ---- STRUCT FOR JSP BIND ---- **/
    public static class LectureInfo {
        public Lectures lecture;
        public String primaryMaterialUrl;
        public String primaryMaterialType;
        public List<MaterialItem> materials;
        public String materialsJson;

        // Getters for JSP
        public Lectures getLecture() { return lecture; }
        public String getPrimaryMaterialUrl() { return primaryMaterialUrl; }
        public String getPrimaryMaterialType() { return primaryMaterialType; }
        public List<MaterialItem> getMaterials() { return materials; }
        public String getMaterialsJson() { return materialsJson; }

        public static class MaterialItem {
            public String url;
            public String type;
            public String fileName;

            // Getters for JSP
            public String getUrl() { return url; }
            public String getType() { return type; }
            public String getFileName() { return fileName; }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // ===== CHECK USER LOGIN =====
            HttpSession session = request.getSession();
            Users currentUser = (Users) session.getAttribute("account");

            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // ===== GET COURSE ID =====
            String courseId = request.getParameter("id");
            if (courseId == null || courseId.isBlank()) {
                request.setAttribute("errorMsg", "❌ Course ID không hợp lệ");
                request.getRequestDispatcher("/WEB-INF/views/Pages/user/course-player.jsp").forward(request, response);
                return;
            }

            logger.info("🎬 LOAD Course Player - Course ID = " + courseId);

            // ===== VALIDATE COURSE EXISTS =====
            SimpleCourse course = loadCourse(courseId);
            if (course == null) {
                request.setAttribute("errorMsg", "❌ Course không tồn tại.");
                request.getRequestDispatcher("/WEB-INF/views/Pages/user/course-player.jsp").forward(request, response);
                return;
            }

            // ===== Validate purchase — TODO (demo always true) =====
            boolean hasPurchased = true;
            if (!hasPurchased) {
                request.setAttribute("errorMsg", "❌ Bạn chưa mua khóa học này.");
                request.getRequestDispatcher("/WEB-INF/views/Pages/user/course-player.jsp").forward(request, response);
                return;
            }

            // ===== LOAD sections + lectures + lecture materials =====
            CourseBundle bundle = loadCourseStructure(courseId);

            request.setAttribute("course", course);
            request.setAttribute("sections", bundle.sections);
            request.setAttribute("lecturesBySection", bundle.lecturesBySection);

            request.getRequestDispatcher("/WEB-INF/views/Pages/user/course-player.jsp").forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "🔥 ERROR CoursePlayerServletJDBC", e);
            request.setAttribute("errorMsg", "❌ Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/course-player.jsp").forward(request, response);
        }
    }


    /** ======================================================
     * LOAD COURSE INFO (title + description)
     * ====================================================== */
    private SimpleCourse loadCourse(String courseId) {
        String sql = """
            SELECT Title, Description
            FROM dbo.Courses
            WHERE Id = ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, courseId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new SimpleCourse(
                        courseId,
                        rs.getString("Title"),
                        rs.getString("Description")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }


    /** ======================================================
     * STRUCT for holding course outline
     * ====================================================== */
    private static class CourseBundle {
        List<Sections> sections;
        Map<String, List<LectureInfo>> lecturesBySection;

        CourseBundle(List<Sections> s, Map<String, List<LectureInfo>> ls) {
            this.sections = s;
            this.lecturesBySection = ls;
        }
    }


    /** ======================================================
     * LOAD:
     *  Sections
     *      → Lectures
     *          → Materials
     * ====================================================== */
    private CourseBundle loadCourseStructure(String courseId) throws SQLException {
        List<Sections> sectionList = new ArrayList<>();
        Map<String, List<LectureInfo>> lecturesBySection = new HashMap<>();

        String qSections = """
            SELECT Id, Title
            FROM Sections
            WHERE CourseId = ?
            ORDER BY CreationTime
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(qSections)) {

            ps.setString(1, courseId);
            ResultSet rsSec = ps.executeQuery();

            while (rsSec.next()) {
                String sectionId = rsSec.getString("Id");
                String sectionTitle = rsSec.getString("Title");

                Sections sec = new Sections();
                sec.setId(sectionId);
                sec.setTitle(sectionTitle);
                sectionList.add(sec);

                // LOAD LECTURES
                List<LectureInfo> lectureInfos = loadLecturesForSection(conn, sectionId);
                lecturesBySection.put(sectionId, lectureInfos);
            }
        }

        return new CourseBundle(sectionList, lecturesBySection);
    }


    /** LOAD LECTURES + MATERIALS */
    private List<LectureInfo> loadLecturesForSection(Connection conn, String sectionId) throws SQLException {

        List<LectureInfo> lectureInfos = new ArrayList<>();

        String qLectures = """
            SELECT Id, Title
            FROM Lectures
            WHERE SectionId = ?
            ORDER BY CreationTime
        """;

        try (PreparedStatement psL = conn.prepareStatement(qLectures)) {
            psL.setString(1, sectionId);
            ResultSet rsL = psL.executeQuery();

            while (rsL.next()) {

                String lectureId = rsL.getString("Id");
                String lectureTitle = rsL.getString("Title");

                LectureInfo info = new LectureInfo();
                Lectures lec = new Lectures();
                lec.setId(lectureId);
                lec.setTitle(lectureTitle);
                info.lecture = lec;

                // LOAD MATERIALS
                List<LectureInfo.MaterialItem> materials = new ArrayList<>();
                String qMat = """
                    SELECT Url, Type
                    FROM LectureMaterial
                    WHERE LectureId = ?
                    ORDER BY Id
                """;

                try (PreparedStatement psM = conn.prepareStatement(qMat)) {
                    psM.setString(1, lectureId);
                    ResultSet rsM = psM.executeQuery();

                    boolean first = true;

                    while (rsM.next()) {
                        LectureInfo.MaterialItem m = new LectureInfo.MaterialItem();
                        m.url = rsM.getString("Url");
                        m.type = rsM.getString("Type");
                        m.fileName = ""; // Không có cột FileName trong DB

                        materials.add(m);

                        // Mark primary material (first one) with normalized display type
                        if (first) {
                            info.primaryMaterialUrl = m.url;
                            info.primaryMaterialType = normalizeDisplayType(m.type);
                            first = false;
                        }
                    }
                }

                info.materials = materials;
                info.materialsJson = new com.google.gson.Gson().toJson(materials);

                lectureInfos.add(info);
            }
        }

        return lectureInfos;
    }

    /**
     * Chuẩn hoá kiểu tài liệu để hiển thị badge ngắn gọn.
     * Accepts raw DB 'Type' hoặc MIME (application/pdf, video/mp4, etc.).
     */
    private String normalizeDisplayType(String raw) {
        if (raw == null || raw.isBlank()) {
            return "Tài liệu";
        }
        String t = raw.trim().toLowerCase();

        // Video
        if (t.contains("video") || t.contains("mp4") || t.equals("video/mp4") || t.contains("preview")) {
            return "Video";
        }
        // PDF
        if (t.contains("pdf")) {
            return "PDF";
        }
        // Word / DOC / DOCX
        if (t.contains("doc") || t.contains("word") || t.contains("application/msword")
                || t.contains("application/vnd.openxmlformats-officedocument.wordprocessingml.document")) {
            return "DOCX";
        }
        // PowerPoint
        if (t.contains("ppt") || t.contains("presentation")
                || t.contains("application/vnd.ms-powerpoint")
                || t.contains("application/vnd.openxmlformats-officedocument.presentationml.presentation")) {
            return "PPT";
        }
        // Excel / Sheets
        if (t.contains("xls") || t.contains("sheet") || t.contains("application/vnd.ms-excel")
                || t.contains("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")) {
            return "XLS";
        }
        // Image
        if (t.startsWith("image/") || t.contains("png") || t.contains("jpg") || t.contains("jpeg") || t.contains("gif")) {
            return "Ảnh";
        }
        // Text / Plain
        if (t.startsWith("text/")) {
            return "Text";
        }
        return "Tài liệu"; // fallback
    }


    /** ===== MINIMAL DTO ==== */
    public static class SimpleCourse {
        private String id;
        private String title;
        private String description;

        public SimpleCourse(String id, String title, String description) {
            this.id = id;
            this.title = title;
            this.description = description;
        }

        public String getId() { return id; }
        public String getTitle() { return title; }
        public String getDescription() { return description; }
    }

}
