package controller;

import dao.CourseDAO;
import dao.LectureDAO;
import dao.EnrollmentDAO;
import dao.CompletionDAO; // ✅ Thêm DAO tiến độ
import model.Lectures;
import model.LectureMaterial;
import model.Sections;
import model.Users;
import model.Enrollments;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CoursePlayerServlet", urlPatterns = {
    "/course-player",
    "/my-courses/course-player"
})
public class CoursePlayerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String courseId = request.getParameter("courseId");
        String lectureId = request.getParameter("lectureId");

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("account");

        // 🔹 Bảo vệ: chưa đăng nhập
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 🔹 Bảo vệ: thiếu courseId
        if (courseId == null || courseId.isBlank()) {
            response.getWriter().println("Thiếu courseId hợp lệ.");
            return;
        }

        try {
            CourseDAO courseDAO = new CourseDAO();
            LectureDAO lectureDAO = new LectureDAO();
            EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
            CompletionDAO completionDAO = new CompletionDAO(); // ✅ NEW

            // 🔹 Kiểm tra user có đăng ký khóa học không
            if (!enrollmentDAO.isUserEnrolled(currentUser.getId(), courseId)) {
                response.getWriter().println("Bạn chưa đăng ký khóa học này.");
                return;
            }

            // 🔹 Lấy danh sách section và lecture (cho sidebar)
            List<Sections> sidebarData = courseDAO.getSectionsWithLectures(courseId);
            courseDAO.loadLecturesForSections(sidebarData);
            courseDAO.loadMaterialsForLectures(sidebarData);
            courseDAO.loadAssignmentsForSections(sidebarData);

            // 🔹 Fallback: nếu lectureId bị thiếu/null → ưu tiên lastViewedLectureId
            if (lectureId == null || lectureId.isBlank()) {
                Enrollments enrollment = enrollmentDAO.getEnrollment(currentUser.getId(), courseId);
                if (enrollment != null && enrollment.getLastViewedLectureId() != null) {
                    lectureId = enrollment.getLastViewedLectureId().getId();
                } else {
                    lectureId = getFirstLectureId(sidebarData);
                }

                if (lectureId == null) {
                    response.getWriter().println("Khóa học này chưa có bài học nào.");
                    return;
                }

                response.sendRedirect(request.getContextPath()
                        + "/course-player?courseId=" + courseId + "&lectureId=" + lectureId);
                return;
            }

            // 🔹 Lấy thông tin bài học hiện tại + tài liệu
            Lectures currentLecture = lectureDAO.getLectureById(lectureId);
            List<LectureMaterial> currentMaterials = lectureDAO.getMaterialsByLectureId(lectureId);

            // 🔹 Cập nhật bài học cuối cùng mà user đã xem
            enrollmentDAO.updateLastViewedLecture(currentUser.getId(), courseId, lectureId);

            // 🔹 Lấy danh sách bài học đã hoàn thành từ DB
            List<String> completedLectures = completionDAO.getCompletedLectureIds(currentUser.getId(), courseId);

            // 🔹 Gán dữ liệu cho JSP
            request.setAttribute("returnCourseId", courseId);
            request.setAttribute("returnLectureId", lectureId);
            request.setAttribute("sidebarData", sidebarData);
            request.setAttribute("currentLecture", currentLecture);
            request.setAttribute("currentMaterials", currentMaterials);
            request.setAttribute("completedLectures", completedLectures);

            request.getRequestDispatcher("course-player.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi tải trang học: " + e.getMessage());
        }
    }

    private String getFirstLectureId(List<Sections> sections) {
        if (sections == null || sections.isEmpty()) {
            return null;
        }
        for (Sections section : sections) {
            if (section.getLecturesCollection() != null && !section.getLecturesCollection().isEmpty()) {
                Lectures firstLecture = section.getLecturesCollection().iterator().next();
                return firstLecture.getId();
            }
        }
        return null;
    }
}
