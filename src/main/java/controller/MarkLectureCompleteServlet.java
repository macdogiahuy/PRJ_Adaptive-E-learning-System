package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.json.JSONArray;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

@WebServlet("/mark-lecture-complete")
public class MarkLectureCompleteServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=CourseHubDB;encrypt=true;trustServerCertificate=true;";
    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "123456";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Get current user
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("account");

        if (currentUser == null || currentUser.getId() == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"Not logged in\"}");
            return;
        }

        String courseId = request.getParameter("courseId");
        String lectureId = request.getParameter("lectureId");

        if (courseId == null || lectureId == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Missing parameters\"}");
            return;
        }

        try {
            boolean success = markLectureComplete(currentUser.getId(), courseId, lectureId);
            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Lecture marked as complete\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to mark lecture\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }

    private boolean markLectureComplete(String userId, String courseId, String lectureId) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

            // Check if enrollment exists
            String checkSql = "SELECT LectureMilestones FROM Enrollments WHERE CreatorId = ? AND CourseId = ?";
            String existingMilestones = "";
            boolean enrollmentExists = false;

            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setString(1, userId);
                ps.setString(2, courseId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        enrollmentExists = true;
                        existingMilestones = rs.getString("LectureMilestones");
                        if (existingMilestones == null) {
                            existingMilestones = "";
                        }
                    }
                }
            }

            // Parse existing milestones
            JSONArray milestonesArray;
            try {
                milestonesArray = new JSONArray(existingMilestones.isEmpty() ? "[]" : existingMilestones);
            } catch (Exception e) {
                milestonesArray = new JSONArray();
            }

            // Check if already completed
            for (int i = 0; i < milestonesArray.length(); i++) {
                if (milestonesArray.getString(i).equals(lectureId)) {
                    return true; // Already completed
                }
            }

            // Add new lecture ID
            milestonesArray.put(lectureId);
            String updatedMilestones = milestonesArray.toString();

            if (enrollmentExists) {
                // Update existing enrollment
                String updateSql = "UPDATE Enrollments SET LectureMilestones = ? WHERE CreatorId = ? AND CourseId = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setString(1, updatedMilestones);
                    ps.setString(2, userId);
                    ps.setString(3, courseId);
                    return ps.executeUpdate() > 0;
                }
            } else {
                // Create new enrollment
                String insertSql = "INSERT INTO Enrollments (CreatorId, CourseId, Status, CreationTime, AssignmentMilestones, LectureMilestones, SectionMilestones) "
                        + "VALUES (?, ?, 'Ongoing', GETDATE(), '', ?, '')";
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setString(1, userId);
                    ps.setString(2, courseId);
                    ps.setString(3, updatedMilestones);
                    return ps.executeUpdate() > 0;
                }
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("account");

        if (currentUser == null) {
            response.getWriter().write("{\"completedLectures\": []}");
            return;
        }

        String courseId = request.getParameter("courseId");
        if (courseId == null) {
            response.getWriter().write("{\"completedLectures\": []}");
            return;
        }

        try {
            JSONArray completed = getCompletedLectures(currentUser.getId(), courseId);
            response.getWriter().write("{\"completedLectures\": " + completed.toString() + "}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"completedLectures\": []}");
        }
    }

    private JSONArray getCompletedLectures(String userId, String courseId) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql = "SELECT LectureMilestones FROM Enrollments WHERE CreatorId = ? AND CourseId = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, userId);
                ps.setString(2, courseId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String milestones = rs.getString("LectureMilestones");
                        if (milestones != null && !milestones.isEmpty()) {
                            return new JSONArray(milestones);
                        }
                    }
                }
            }
        }
        return new JSONArray();
    }
}