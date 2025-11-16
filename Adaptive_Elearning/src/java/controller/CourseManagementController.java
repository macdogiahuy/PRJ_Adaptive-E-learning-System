package controller;

import dao.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;
import java.text.NumberFormat;
import java.util.Locale;

/**
 * Controller for Course Management
 */
public class CourseManagementController {
    
    /**
     * Course data model
     */
    public static class Course {
        private String id;
        private String title;
        private String thumbUrl;
        private String status;
        private double price;
        private double discount;
        private Date discountExpiry;
        private String level;
        private int learnerCount;
        private int ratingCount;
        private long totalRating;
        private String instructorName;
        
        // Constructors
        public Course() {}
        
        public Course(String id, String title, String thumbUrl, String status, 
                     double price, double discount, Date discountExpiry, String level,
                     int learnerCount, int ratingCount, long totalRating, String instructorName) {
            this.id = id;
            this.title = title;
            this.thumbUrl = thumbUrl;
            this.status = status;
            this.price = price;
            this.discount = discount;
            this.discountExpiry = discountExpiry;
            this.level = level;
            this.learnerCount = learnerCount;
            this.ratingCount = ratingCount;
            this.totalRating = totalRating;
            this.instructorName = instructorName;
        }
        
        // Getters and Setters
        public String getId() { return id; }
        public void setId(String id) { this.id = id; }
        
        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }
        
        public String getThumbUrl() { return thumbUrl; }
        public void setThumbUrl(String thumbUrl) { this.thumbUrl = thumbUrl; }
        
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        
        public double getPrice() { return price; }
        public void setPrice(double price) { this.price = price; }
        
        public double getDiscount() { return discount; }
        public void setDiscount(double discount) { this.discount = discount; }
        
        public Date getDiscountExpiry() { return discountExpiry; }
        public void setDiscountExpiry(Date discountExpiry) { this.discountExpiry = discountExpiry; }
        
        public String getLevel() { return level; }
        public void setLevel(String level) { this.level = level; }
        
        public int getLearnerCount() { return learnerCount; }
        public void setLearnerCount(int learnerCount) { this.learnerCount = learnerCount; }
        
        public int getRatingCount() { return ratingCount; }
        public void setRatingCount(int ratingCount) { this.ratingCount = ratingCount; }
        
        public long getTotalRating() { return totalRating; }
        public void setTotalRating(long totalRating) { this.totalRating = totalRating; }
        
        public String getInstructorName() { return instructorName; }
        public void setInstructorName(String instructorName) { this.instructorName = instructorName; }
        
        // Helper methods
        public boolean hasDiscount() {
            return discount > 0 && discountExpiry.after(new Date());
        }
        
        public double getDiscountedPrice() {
            if (hasDiscount()) {
                return price * (1 - discount);
            }
            return price;
        }
        
        public double getAverageRating() {
            if (ratingCount == 0) return 0;
            return (double) totalRating / ratingCount;
        }
        
        public String getFormattedPrice() {
            NumberFormat formatter = NumberFormat.getCurrencyInstance(Locale.forLanguageTag("vi-VN"));
            return formatter.format(price);
        }
        
        public String getFormattedDiscountedPrice() {
            if (hasDiscount()) {
                NumberFormat formatter = NumberFormat.getCurrencyInstance(Locale.forLanguageTag("vi-VN"));
                return formatter.format(getDiscountedPrice());
            }
            return getFormattedPrice();
        }
        
        public int getDiscountPercentage() {
            return (int)(discount * 100);
        }
    }
    
    /**
     * Course statistics model
     */
    public static class CourseStats {
        private int totalCourses;
        private int ongoingCourses;
        private int completedCourses;
        private int draftCourses;
        
        public CourseStats(int totalCourses, int ongoingCourses, int completedCourses, int draftCourses) {
            this.totalCourses = totalCourses;
            this.ongoingCourses = ongoingCourses;
            this.completedCourses = completedCourses;
            this.draftCourses = draftCourses;
        }
        
        // Getters
        public int getTotalCourses() { return totalCourses; }
        public int getOngoingCourses() { return ongoingCourses; }
        public int getCompletedCourses() { return completedCourses; }
        public int getDraftCourses() { return draftCourses; }
    }
    
    /**
     * Get course statistics
     */
    public CourseStats getCourseStats() throws SQLException {
        String sql = "SELECT " +
                    "COUNT(*) as total, " +
                    "SUM(CASE WHEN Status = 'Ongoing' THEN 1 ELSE 0 END) as ongoing, " +
                    "SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) as completed, " +
                    "SUM(CASE WHEN Status = 'Draft' THEN 1 ELSE 0 END) as draft " +
                    "FROM Courses";
                    
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return new CourseStats(
                    rs.getInt("total"),
                    rs.getInt("ongoing"),
                    rs.getInt("completed"),
                    rs.getInt("draft")
                );
            }
        }
        return new CourseStats(0, 0, 0, 0);
    }
    
    /**
     * Get all courses with optional search and pagination
     */
    public List<Course> getCourses(String searchTerm, int limit, int offset) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT c.Id, c.Title, c.ThumbUrl, c.Status, c.Price, c.Discount, ");
        sql.append("c.DiscountExpiry, c.Level, c.LearnerCount, c.RatingCount, c.TotalRating, ");
        sql.append("u.FullName as InstructorName ");
        sql.append("FROM Courses c ");
        sql.append("LEFT JOIN Users u ON c.InstructorId = u.Id ");
        
        List<Object> params = new ArrayList<>();
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("WHERE LOWER(c.Title) LIKE LOWER(?) ");
            params.add("%" + searchTerm.trim() + "%");
        }
        
        sql.append("ORDER BY c.CreationTime DESC ");
        
        if (limit > 0) {
            sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
            params.add(offset);
            params.add(limit);
        }
        
        List<Course> courses = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    courses.add(new Course(
                        rs.getString("Id"),
                        rs.getString("Title"),
                        rs.getString("ThumbUrl"),
                        rs.getString("Status"),
                        rs.getDouble("Price"),
                        rs.getDouble("Discount"),
                        rs.getTimestamp("DiscountExpiry"),
                        rs.getString("Level"),
                        rs.getInt("LearnerCount"),
                        rs.getInt("RatingCount"),
                        rs.getLong("TotalRating"),
                        rs.getString("InstructorName")
                    ));
                }
            }
        }
        
        return courses;
    }
    
    /**
     * Get total course count for pagination
     */
    public int getTotalCourseCount(String searchTerm) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Courses ");
        List<Object> params = new ArrayList<>();
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("WHERE LOWER(Title) LIKE LOWER(?) ");
            params.add("%" + searchTerm.trim() + "%");
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    public int getTotalCoursesCount(String searchQuery) {
        String sql = "SELECT COUNT(*) FROM Courses WHERE Title LIKE ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + (searchQuery != null ? searchQuery : "") + "%");
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Start a course (set status to Ongoing)
     */
    public boolean startCourse(String courseId) throws SQLException {
        String sql = "UPDATE Courses SET Status = 'Ongoing' WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, courseId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    /**
     * Stop a course (set status to Off)
     */
    public boolean stopCourse(String courseId) throws SQLException {
        String sql = "UPDATE Courses SET Status = 'Off' WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, courseId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    /**
     * Get course by ID
     */
    public Course getCourseById(String courseId) throws SQLException {
        String sql = "SELECT c.Id, c.Title, c.ThumbUrl, c.Status, c.Price, c.Discount, " +
                    "c.DiscountExpiry, c.Level, c.LearnerCount, c.RatingCount, c.TotalRating, " +
                    "u.FullName as InstructorName " +
                    "FROM Courses c " +
                    "LEFT JOIN Users u ON c.InstructorId = u.Id " +
                    "WHERE c.Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, courseId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Course(
                        rs.getString("Id"),
                        rs.getString("Title"),
                        rs.getString("ThumbUrl"),
                        rs.getString("Status"),
                        rs.getDouble("Price"),
                        rs.getDouble("Discount"),
                        rs.getTimestamp("DiscountExpiry"),
                        rs.getString("Level"),
                        rs.getInt("LearnerCount"),
                        rs.getInt("RatingCount"),
                        rs.getLong("TotalRating"),
                        rs.getString("InstructorName")
                    );
                }
            }
        }
        return null;
    }
    
    /**
     * Test database connection
     */
    public boolean testConnection() {
        try (Connection conn = DBConnection.getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}