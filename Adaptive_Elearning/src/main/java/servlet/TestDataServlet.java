package servlet;

import com.google.gson.Gson;
import dao.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet để lấy dữ liệu thật từ database cho testing
 */
@WebServlet("/api/test-data/*")
public class TestDataServlet extends HttpServlet {
    
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Enable CORS
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        
        try {
            Map<String, Object> result;
            
            switch (pathInfo) {
                case "/users":
                    result = getUsers();
                    break;
                case "/courses":
                    result = getCourses();
                    break;
                case "/enrollments":
                    result = getEnrollments();
                    break;
                case "/sample-data":
                    result = getSampleTestData();
                    break;
                case "/create-sample":
                    result = createSampleData();
                    break;
                default:
                    result = Map.of("success", false, "error", "Invalid endpoint");
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
            
            writeJsonResponse(response, result);
            
        } catch (Exception e) {
            System.err.println("Error in TestDataServlet: " + e.getMessage());
            e.printStackTrace();
            
            Map<String, Object> errorResult = Map.of(
                "success", false,
                "error", "Internal server error: " + e.getMessage()
            );
            
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            writeJsonResponse(response, errorResult);
        }
    }
    
    /**
     * Lấy danh sách users từ database
     */
    private Map<String, Object> getUsers() throws SQLException {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> users = new ArrayList<>();
        
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            String sql = """
                SELECT TOP 20 Id, UserName, Email, FullName, Role, AvatarUrl, 
                       CreationTime, IsVerified, IsApproved
                FROM Users 
                WHERE IsVerified = 1 AND IsApproved = 1
                ORDER BY CreationTime DESC
                """;
            
            stmt = connection.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("id", rs.getString("Id"));
                user.put("userName", rs.getString("UserName"));
                user.put("email", rs.getString("Email"));
                user.put("fullName", rs.getString("FullName"));
                user.put("role", rs.getString("Role"));
                user.put("avatarUrl", rs.getString("AvatarUrl"));
                user.put("creationTime", rs.getTimestamp("CreationTime"));
                user.put("isVerified", rs.getBoolean("IsVerified"));
                user.put("isApproved", rs.getBoolean("IsApproved"));
                
                users.add(user);
            }
            
            result.put("success", true);
            result.put("users", users);
            result.put("count", users.size());
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
        
        return result;
    }
    
    /**
     * Lấy danh sách courses từ database
     */
    private Map<String, Object> getCourses() throws SQLException {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> courses = new ArrayList<>();
        
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            String sql = """
                SELECT TOP 20 c.Id, c.Title, c.ThumbUrl, c.Status, c.Price, 
                       c.LearnerCount, c.CreationTime, u.FullName as InstructorName
                FROM Courses c
                INNER JOIN Instructors i ON i.Id = c.InstructorId
                INNER JOIN Users u ON u.Id = i.CreatorId
                WHERE c.Status = 'Published'
                ORDER BY c.CreationTime DESC
                """;
            
            stmt = connection.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> course = new HashMap<>();
                course.put("id", rs.getString("Id"));
                course.put("title", rs.getString("Title"));
                course.put("thumbUrl", rs.getString("ThumbUrl"));
                course.put("status", rs.getString("Status"));
                course.put("price", rs.getDouble("Price"));
                course.put("learnerCount", rs.getInt("LearnerCount"));
                course.put("instructorName", rs.getString("InstructorName"));
                course.put("creationTime", rs.getTimestamp("CreationTime"));
                
                courses.add(course);
            }
            
            result.put("success", true);
            result.put("courses", courses);
            result.put("count", courses.size());
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
        
        return result;
    }
    
    /**
     * Lấy danh sách enrollments từ database
     */
    private Map<String, Object> getEnrollments() throws SQLException {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> enrollments = new ArrayList<>();
        
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            String sql = """
                SELECT TOP 50 e.CreatorId, e.CourseId, e.Status, e.CreationTime,
                       u.FullName as StudentName, u.Email as StudentEmail,
                       c.Title as CourseTitle
                FROM Enrollments e
                INNER JOIN Users u ON u.Id = e.CreatorId
                INNER JOIN Courses c ON c.Id = e.CourseId
                ORDER BY e.CreationTime DESC
                """;
            
            stmt = connection.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> enrollment = new HashMap<>();
                enrollment.put("userId", rs.getString("CreatorId"));
                enrollment.put("courseId", rs.getString("CourseId"));
                enrollment.put("status", rs.getString("Status"));
                enrollment.put("studentName", rs.getString("StudentName"));
                enrollment.put("studentEmail", rs.getString("StudentEmail"));
                enrollment.put("courseTitle", rs.getString("CourseTitle"));
                enrollment.put("creationTime", rs.getTimestamp("CreationTime"));
                
                enrollments.add(enrollment);
            }
            
            result.put("success", true);
            result.put("enrollments", enrollments);
            result.put("count", enrollments.size());
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
        
        return result;
    }
    
    /**
     * Lấy sample data cho testing (user-course pairs)
     */
    private Map<String, Object> getSampleTestData() throws SQLException {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> testPairs = new ArrayList<>();
        
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            String sql = """
                SELECT TOP 10 e.CreatorId as UserId, e.CourseId, 
                       u.FullName as UserName, u.Email as UserEmail,
                       c.Title as CourseTitle
                FROM Enrollments e
                INNER JOIN Users u ON u.Id = e.CreatorId
                INNER JOIN Courses c ON c.Id = e.CourseId
                WHERE u.IsVerified = 1 AND u.IsApproved = 1 
                AND c.Status = 'Published'
                ORDER BY NEWID()
                """;
            
            stmt = connection.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> pair = new HashMap<>();
                pair.put("userId", rs.getString("UserId"));
                pair.put("courseId", rs.getString("CourseId"));
                pair.put("userName", rs.getString("UserName"));
                pair.put("userEmail", rs.getString("UserEmail"));
                pair.put("courseTitle", rs.getString("CourseTitle"));
                
                testPairs.add(pair);
            }
            
            result.put("success", true);
            result.put("testPairs", testPairs);
            result.put("count", testPairs.size());
            result.put("message", "Use these real user-course pairs for testing");
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
        
        return result;
    }
    
    /**
     * Tạo sample data nếu database trống
     */
    private Map<String, Object> createSampleData() throws SQLException {
        Map<String, Object> result = new HashMap<>();
        Connection connection = null;
        
        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);
            
            // Check if we already have data
            PreparedStatement checkStmt = connection.prepareStatement("SELECT COUNT(*) FROM Users");
            ResultSet rs = checkStmt.executeQuery();
            rs.next();
            int userCount = rs.getInt(1);
            
            if (userCount > 0) {
                result.put("success", false);
                result.put("message", "Database already has data. Use existing data instead.");
                return result;
            }
            
            // Create sample users
            String[] sampleUsers = {
                "('11111111-1111-1111-1111-111111111111', 'john_doe', 'password123', 'john@example.com', 'John Doe', 'john doe', '/assets/images/avatar1.jpg', 'Student', '', '', 1, 1, 0, NULL, NULL, 'Computer Science student', NULL, NULL, 0, NULL, GETDATE(), GETDATE(), 0)",
                "('22222222-2222-2222-2222-222222222222', 'jane_smith', 'password123', 'jane@example.com', 'Jane Smith', 'jane smith', '/assets/images/avatar2.jpg', 'Instructor', '', '', 1, 1, 0, NULL, NULL, 'Math teacher', NULL, NULL, 0, NULL, GETDATE(), GETDATE(), 0)",
                "('33333333-3333-3333-3333-333333333333', 'bob_wilson', 'password123', 'bob@example.com', 'Bob Wilson', 'bob wilson', '/assets/images/avatar3.jpg', 'Student', '', '', 1, 1, 0, NULL, NULL, 'Engineering student', NULL, NULL, 0, NULL, GETDATE(), GETDATE(), 0)"
            };
            
            for (String userData : sampleUsers) {
                PreparedStatement insertUser = connection.prepareStatement(
                    "INSERT INTO Users (Id, UserName, Password, Email, FullName, MetaFullName, AvatarUrl, Role, Token, RefreshToken, IsVerified, IsApproved, AccessFailedCount, LoginProvider, ProviderKey, Bio, DateOfBirth, Phone, EnrollmentCount, InstructorId, CreationTime, LastModificationTime, SystemBalance) VALUES " + userData
                );
                insertUser.executeUpdate();
                insertUser.close();
            }
            
            // Create sample instructors
            PreparedStatement instructorStmt = connection.prepareStatement(
                "INSERT INTO Instructors (Id, Intro, Experience, CreatorId, CreationTime, LastModificationTime, Balance) VALUES (?, ?, ?, ?, GETDATE(), GETDATE(), 0)"
            );
            
            instructorStmt.setString(1, "44444444-4444-4444-4444-444444444444");
            instructorStmt.setString(2, "Experienced instructor");
            instructorStmt.setString(3, "5+ years teaching experience");
            instructorStmt.setString(4, "22222222-2222-2222-2222-222222222222");
            instructorStmt.executeUpdate();
            
            // Create sample category
            PreparedStatement categoryStmt = connection.prepareStatement(
                "INSERT INTO Categories (Id, Title, MetaTitle, Intro, Content, ThumbUrl, CreationTime, LastModificationTime, ParentId) VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), NULL)"
            );
            
            categoryStmt.setString(1, "55555555-5555-5555-5555-555555555555");
            categoryStmt.setString(2, "Programming");
            categoryStmt.setString(3, "programming");
            categoryStmt.setString(4, "Programming courses");
            categoryStmt.setString(5, "Learn programming languages");
            categoryStmt.setString(6, "/assets/images/programming.jpg");
            categoryStmt.executeUpdate();
            
            // Create sample courses
            String[] sampleCourses = {
                "('66666666-6666-6666-6666-666666666666', 'Java Programming Basics', 'java programming basics', '/assets/images/java-course.jpg', 'Learn Java programming from scratch', 'Complete Java programming course for beginners', 'Published', 99.99, 0, GETDATE(), 'Beginner', 'Build real projects', 'No prerequisites', 10, 0, 0, 0, '55555555-5555-5555-5555-555555555555', '44444444-4444-4444-4444-444444444444', GETDATE(), GETDATE(), '22222222-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222')",
                "('77777777-7777-7777-7777-777777777777', 'Web Development with JavaScript', 'web development javascript', '/assets/images/js-course.jpg', 'Master modern web development', 'Learn HTML, CSS, and JavaScript', 'Published', 149.99, 0, GETDATE(), 'Intermediate', 'Build web applications', 'Basic HTML knowledge', 15, 0, 0, 0, '55555555-5555-5555-5555-555555555555', '44444444-4444-4444-4444-444444444444', GETDATE(), GETDATE(), '22222222-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222')"
            };
            
            for (String courseData : sampleCourses) {
                PreparedStatement insertCourse = connection.prepareStatement(
                    "INSERT INTO Courses (Id, Title, MetaTitle, ThumbUrl, Intro, Description, Status, Price, Discount, DiscountExpiry, Level, Outcomes, Requirements, LectureCount, LearnerCount, RatingCount, TotalRating, LeafCategoryId, InstructorId, CreationTime, LastModificationTime, CreatorId, LastModifierId) VALUES " + courseData
                );
                insertCourse.executeUpdate();
                insertCourse.close();
            }
            
            // Create sample enrollments
            String[] sampleEnrollments = {
                "('11111111-1111-1111-1111-111111111111', '66666666-6666-6666-6666-666666666666', 'Active', NULL, GETDATE(), '', '', '')",
                "('33333333-3333-3333-3333-333333333333', '66666666-6666-6666-6666-666666666666', 'Active', NULL, GETDATE(), '', '', '')",
                "('11111111-1111-1111-1111-111111111111', '77777777-7777-7777-7777-777777777777', 'Active', NULL, GETDATE(), '', '', '')"
            };
            
            for (String enrollmentData : sampleEnrollments) {
                PreparedStatement insertEnrollment = connection.prepareStatement(
                    "INSERT INTO Enrollments (CreatorId, CourseId, Status, BillId, CreationTime, AssignmentMilestones, LectureMilestones, SectionMilestones) VALUES " + enrollmentData
                );
                insertEnrollment.executeUpdate();
                insertEnrollment.close();
            }
            
            connection.commit();
            
            result.put("success", true);
            result.put("message", "Sample data created successfully");
            result.put("created", Map.of(
                "users", 3,
                "instructors", 1,
                "courses", 2,
                "enrollments", 3
            ));
            
        } catch (SQLException e) {
            if (connection != null) {
                connection.rollback();
            }
            throw e;
        } finally {
            if (connection != null) {
                connection.setAutoCommit(true);
                connection.close();
            }
        }
        
        return result;
    }
    
    private void writeJsonResponse(HttpServletResponse response, Map<String, Object> data) throws IOException {
        try (PrintWriter out = response.getWriter()) {
            out.write(gson.toJson(data));
        }
    }
}