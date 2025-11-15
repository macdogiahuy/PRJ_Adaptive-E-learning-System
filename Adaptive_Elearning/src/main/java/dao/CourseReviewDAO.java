package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO for managing course reviews and ratings
 */
public class CourseReviewDAO {
    private static final Logger LOGGER = Logger.getLogger(CourseReviewDAO.class.getName());

    /**
     * Check if user has enrolled in a course (purchased it)
     */
    public boolean hasUserEnrolled(String userId, String courseId) {
        String sql = "SELECT COUNT(*) FROM Enrollments WHERE CreatorId = ? AND CourseId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, userId);
            ps.setString(2, courseId);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking user enrollment", e);
        }
        return false;
    }

    /**
     * Check if user has already reviewed a course
     */
    public boolean hasUserReviewed(String userId, String courseId) {
        String sql = "SELECT COUNT(*) FROM CourseReviews WHERE CreatorId = ? AND CourseId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, userId);
            ps.setString(2, courseId);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking user review", e);
        }
        return false;
    }

    /**
     * Save a new review to database
     */
    public boolean saveReview(String userId, String courseId, int rating, String content) {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(true); // Ensure autocommit is enabled
            
            String sql = "INSERT INTO CourseReviews (Id, Content, Rating, CourseId, CreatorId, " +
                         "LastModifierId, CreationTime, LastModificationTime) " +
                         "VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
            
            ps = conn.prepareStatement(sql);
            
            String reviewId = UUID.randomUUID().toString().toUpperCase();
            
            LOGGER.log(Level.INFO, "Attempting to save review: ReviewId={0}, UserId={1}, CourseId={2}, Rating={3}", 
                      new Object[]{reviewId, userId, courseId, rating});
            
            ps.setString(1, reviewId);
            ps.setString(2, content);
            ps.setInt(3, rating);
            ps.setString(4, courseId);
            ps.setString(5, userId);
            ps.setString(6, userId);
            
            int rows = ps.executeUpdate();
            
            LOGGER.log(Level.INFO, "Review insert rows affected: {0}", rows);
            
            if (rows > 0) {
                LOGGER.log(Level.INFO, "Review saved successfully: User={0}, Course={1}, Rating={2}", 
                          new Object[]{userId, courseId, rating});
                
                // Update course rating statistics
                updateCourseRatingStats(conn, courseId);
                return true;
            } else {
                LOGGER.log(Level.WARNING, "No rows inserted for review");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Error saving review: " + e.getMessage(), e);
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing resources", e);
            }
        }
        return false;
    }

    /**
     * Update course rating statistics after new review
     */
    private void updateCourseRatingStats(Connection conn, String courseId) {
        String sql = "UPDATE Courses SET " +
                     "RatingCount = (SELECT COUNT(*) FROM CourseReviews WHERE CourseId = ?), " +
                     "TotalRating = (SELECT ISNULL(AVG(CAST(Rating AS FLOAT)), 0) FROM CourseReviews WHERE CourseId = ?) " +
                     "WHERE Id = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, courseId);
            ps.setString(2, courseId);
            ps.setString(3, courseId);
            ps.executeUpdate();
            LOGGER.log(Level.INFO, "Updated course rating stats for course: {0}", courseId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating course rating stats", e);
        }
    }

    /**
     * Get all reviews for a course
     */
    public List<ReviewDTO> getReviewsByCourseId(String courseId) {
        List<ReviewDTO> reviews = new ArrayList<>();
        
        String sql = "SELECT cr.Id, cr.Content, cr.Rating, cr.CreationTime, cr.CreatorId, " +
                     "u.UserName, u.AvatarUrl " +
                     "FROM CourseReviews cr " +
                     "INNER JOIN Users u ON cr.CreatorId = u.Id " +
                     "WHERE cr.CourseId = ? " +
                     "ORDER BY cr.CreationTime DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, courseId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ReviewDTO review = new ReviewDTO();
                review.setId(rs.getString("Id"));
                review.setCreatorId(rs.getString("CreatorId"));
                review.setContent(rs.getString("Content"));
                review.setRating(rs.getInt("Rating"));
                review.setCreationTime(rs.getTimestamp("CreationTime"));
                review.setUserName(rs.getString("UserName"));
                review.setAvatarUrl(rs.getString("AvatarUrl"));
                reviews.add(review);
            }
            
            LOGGER.log(Level.INFO, "Found {0} reviews for course {1}", 
                      new Object[]{reviews.size(), courseId});
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting reviews for course: " + courseId, e);
        }
        
        return reviews;
    }

    /**
     * Update an existing review (only owner can update)
     */
    public boolean updateReview(String reviewId, String userId, int rating, String content) {
        // First verify ownership
        if (!isReviewOwner(reviewId, userId)) {
            LOGGER.log(Level.WARNING, "User {0} attempted to update review {1} they don't own", 
                      new Object[]{userId, reviewId});
            return false;
        }
        
        String sql = "UPDATE CourseReviews SET Content = ?, Rating = ?, " +
                     "LastModificationTime = GETDATE(), LastModifierId = ? " +
                     "WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, content);
            ps.setInt(2, rating);
            ps.setString(3, userId);
            ps.setString(4, reviewId);
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                LOGGER.log(Level.INFO, "Review updated: ID={0}, User={1}", 
                          new Object[]{reviewId, userId});
                
                // Update course rating stats
                String courseId = getCourseIdFromReview(conn, reviewId);
                if (courseId != null) {
                    updateCourseRatingStats(conn, courseId);
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating review", e);
        }
        return false;
    }

    /**
     * Delete a review (only owner can delete)
     */
    public boolean deleteReview(String reviewId, String userId) {
        // First verify ownership
        if (!isReviewOwner(reviewId, userId)) {
            LOGGER.log(Level.WARNING, "User {0} attempted to delete review {1} they don't own", 
                      new Object[]{userId, reviewId});
            return false;
        }
        
        String sql = "DELETE FROM CourseReviews WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Get courseId before deleting
            String courseId = getCourseIdFromReview(conn, reviewId);
            
            ps.setString(1, reviewId);
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                LOGGER.log(Level.INFO, "Review deleted: ID={0}, User={1}", 
                          new Object[]{reviewId, userId});
                
                // Update course rating stats
                if (courseId != null) {
                    updateCourseRatingStats(conn, courseId);
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting review", e);
        }
        return false;
    }

    /**
     * Check if user owns the review
     */
    private boolean isReviewOwner(String reviewId, String userId) {
        String sql = "SELECT COUNT(*) FROM CourseReviews WHERE Id = ? AND CreatorId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, reviewId);
            ps.setString(2, userId);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking review ownership", e);
        }
        return false;
    }

    /**
     * Get courseId from a review
     */
    private String getCourseIdFromReview(Connection conn, String reviewId) {
        String sql = "SELECT CourseId FROM CourseReviews WHERE Id = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reviewId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getString("CourseId");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting courseId from review", e);
        }
        return null;
    }

    /**
     * DTO class for review data
     */
    public static class ReviewDTO {
        private String id;
        private String creatorId;
        private String content;
        private int rating;
        private Date creationTime;
        private String userName;
        private String avatarUrl;

        // Getters and setters
        public String getId() { return id; }
        public void setId(String id) { this.id = id; }
        
        public String getCreatorId() { return creatorId; }
        public void setCreatorId(String creatorId) { this.creatorId = creatorId; }
        
        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
        
        public int getRating() { return rating; }
        public void setRating(int rating) { this.rating = rating; }
        
        public Date getCreationTime() { return creationTime; }
        public void setCreationTime(Date creationTime) { this.creationTime = creationTime; }
        
        public String getUserName() { return userName; }
        public void setUserName(String userName) { this.userName = userName; }
        
        public String getAvatarUrl() { return avatarUrl; }
        public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }
    }
}
