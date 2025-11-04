package dao;

import model.Courses;
import model.Categories;
import model.Sections;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO class for Course management
 * @author LP
 */
public class CourseDAO {
    private static final Logger LOGGER = Logger.getLogger(CourseDAO.class.getName());
    
    /**
     * Get all courses by instructor ID
     */
    public List<Courses> getCoursesByInstructorId(String instructorId) {
        List<Courses> courses = new ArrayList<>();
        String sql = "SELECT c.*, cat.Title as CategoryTitle, cat.Id as CategoryId " +
                     "FROM Courses c " +
                     "LEFT JOIN Categories cat ON c.LeafCategoryId = cat.Id " +
                     "WHERE c.InstructorId = ? " +
                     "ORDER BY c.CreationTime DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, instructorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Courses course = mapResultSetToCourse(rs);
                courses.add(course);
            }
            
            LOGGER.log(Level.INFO, "Found {0} courses for instructor {1}", 
                      new Object[]{courses.size(), instructorId});
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting courses by instructor: " + instructorId, e);
        }
        
        return courses;
    }
    
    /**
     * Get all courses in the system (for admin use)
     */
    public List<Courses> getAllCourses() {
        List<Courses> courses = new ArrayList<>();
        String sql = "SELECT c.*, cat.Title as CategoryTitle, cat.Id as CategoryId " +
                     "FROM Courses c " +
                     "LEFT JOIN Categories cat ON c.LeafCategoryId = cat.Id " +
                     "WHERE c.Status = 'ongoing' " +
                     "ORDER BY c.CreationTime DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Courses course = mapResultSetToCourse(rs);
                courses.add(course);
            }
            
            LOGGER.log(Level.INFO, "Found {0} active courses (status=ongoing)", courses.size());
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all courses", e);
        }
        
        return courses;
    }
    
    /**
     * Get all courses for admin (including pending/off status)
     */
    public List<Courses> getAllCoursesForAdmin() {
        List<Courses> courses = new ArrayList<>();
        String sql = "SELECT c.*, cat.Title as CategoryTitle, cat.Id as CategoryId " +
                     "FROM Courses c " +
                     "LEFT JOIN Categories cat ON c.LeafCategoryId = cat.Id " +
                     "ORDER BY c.CreationTime DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Courses course = mapResultSetToCourse(rs);
                courses.add(course);
            }
            
            LOGGER.log(Level.INFO, "Found {0} total courses for admin", courses.size());
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all courses for admin", e);
        }
        
        return courses;
    }
    
    /**
     * Get course by ID
     */
    public Courses getCourseById(String courseId) {
        String sql = "SELECT c.*, cat.Title as CategoryTitle, cat.Id as CategoryId " +
                     "FROM Courses c " +
                     "LEFT JOIN Categories cat ON c.LeafCategoryId = cat.Id " +
                     "WHERE c.Id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, courseId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCourse(rs);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting course by ID: " + courseId, e);
        }
        
        return null;
    }
    
    /**
     * Create new course
     */
    public boolean createCourse(Courses course, String instructorId, String userId) {
        String sql = "INSERT INTO Courses (Id, Title, MetaTitle, ThumbUrl, Intro, Description, " +
                     "Status, Price, Discount, DiscountExpiry, Level, Outcomes, Requirements, " +
                     "LectureCount, LearnerCount, RatingCount, TotalRating, CreationTime, " +
                     "LastModificationTime, LastModifierId, LeafCategoryId, InstructorId, CreatorId) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            String courseId = UUID.randomUUID().toString();
            Timestamp now = new Timestamp(System.currentTimeMillis());
            Timestamp discountExpiry = new Timestamp(System.currentTimeMillis() + (365L * 24 * 60 * 60 * 1000));
            
            ps.setString(1, courseId);
            ps.setString(2, course.getTitle());
            ps.setString(3, course.getTitle().toLowerCase().replaceAll("\\s+", "-"));
            ps.setString(4, course.getThumbUrl() != null ? course.getThumbUrl() : "");
            ps.setString(5, course.getIntro() != null ? course.getIntro() : "");
            ps.setString(6, course.getDescription() != null ? course.getDescription() : "");
                ps.setString(7, course.getStatus()); // Use status from course object
            ps.setDouble(8, course.getPrice());
            ps.setDouble(9, course.getDiscount() > 0 ? course.getDiscount() : 0);
            ps.setTimestamp(10, discountExpiry);
            ps.setString(11, course.getLevel() != null ? course.getLevel() : "Beginner");
            ps.setString(12, course.getOutcomes() != null ? course.getOutcomes() : "");
            ps.setString(13, course.getRequirements() != null ? course.getRequirements() : "");
            ps.setShort(14, (short) 0); // Initial lecture count
            ps.setInt(15, 0); // Initial learner count
            ps.setInt(16, 0); // Initial rating count
            ps.setLong(17, 0L); // Initial total rating
            ps.setTimestamp(18, now);
            ps.setTimestamp(19, now);
            ps.setString(20, userId);
            ps.setString(21, course.getLeafCategoryId() != null ? course.getLeafCategoryId().getId() : null);
            ps.setString(22, instructorId);
            ps.setString(23, userId);
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                course.setId(courseId);
                LOGGER.log(Level.INFO, "Course created successfully with ID: {0}", courseId);
                return true;
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating course", e);
        }
        
        return false;
    }
    
    /**
     * Update existing course
     */
    public boolean updateCourse(Courses course, String userId) {
        String sql = "UPDATE Courses SET Title = ?, ThumbUrl = ?, Intro = ?, Description = ?, " +
                     "Price = ?, Discount = ?, Level = ?, Outcomes = ?, Requirements = ?, " +
                     "LastModificationTime = ?, LastModifierId = ?, LeafCategoryId = ?, Status = ? " +
                     "WHERE Id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            Timestamp now = new Timestamp(System.currentTimeMillis());
            
            ps.setString(1, course.getTitle());
            ps.setString(2, course.getThumbUrl());
            ps.setString(3, course.getIntro());
            ps.setString(4, course.getDescription());
            ps.setDouble(5, course.getPrice());
            ps.setDouble(6, course.getDiscount());
            ps.setString(7, course.getLevel());
            ps.setString(8, course.getOutcomes());
            ps.setString(9, course.getRequirements());
            ps.setTimestamp(10, now);
            ps.setString(11, userId);
            ps.setString(12, course.getLeafCategoryId() != null ? course.getLeafCategoryId().getId() : null);
            ps.setString(13, course.getStatus());
            ps.setString(14, course.getId());
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                LOGGER.log(Level.INFO, "Course updated successfully: {0}", course.getId());
                return true;
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating course: " + course.getId(), e);
        }
        
        return false;
    }
    
    /**
     * Delete course by ID
     */
    public boolean deleteCourse(String courseId) {
        // First delete related sections
        String deleteSections = "DELETE FROM Sections WHERE CourseId = ?";
        String deleteCourse = "DELETE FROM Courses WHERE Id = ?";
        
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            
            try (PreparedStatement ps1 = con.prepareStatement(deleteSections);
                 PreparedStatement ps2 = con.prepareStatement(deleteCourse)) {
                
                // Delete sections first
                ps1.setString(1, courseId);
                ps1.executeUpdate();
                
                // Then delete course
                ps2.setString(1, courseId);
                int result = ps2.executeUpdate();
                
                con.commit();
                
                if (result > 0) {
                    LOGGER.log(Level.INFO, "Course deleted successfully: {0}", courseId);
                    return true;
                }
                
            } catch (SQLException e) {
                con.rollback();
                throw e;
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting course: " + courseId, e);
        }
        
        return false;
    }
    
    /**
     * Get all categories for dropdown
     */
    public List<Categories> getAllCategories() {
        List<Categories> categories = new ArrayList<>();
        String sql = "SELECT Id, Title, Description, IsLeaf FROM Categories WHERE IsLeaf = 1 ORDER BY Title";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Categories category = new Categories();
                category.setId(rs.getString("Id"));
                category.setTitle(rs.getString("Title"));
                category.setDescription(rs.getString("Description"));
                category.setIsLeaf(rs.getBoolean("IsLeaf"));
                categories.add(category);
            }
            
            LOGGER.log(Level.INFO, "Found {0} categories", categories.size());
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting categories", e);
        }
        
        return categories;
    }
    
    /**
     * Get sections by course ID
     */
    public List<Sections> getSectionsByCourseId(String courseId) {
        List<Sections> sections = new ArrayList<>();
        String sql = "SELECT * FROM Sections WHERE CourseId = ? ORDER BY [Index]";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, courseId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Sections section = new Sections();
                section.setId(rs.getString("Id"));
                section.setIndex(rs.getShort("Index"));
                section.setTitle(rs.getString("Title"));
                section.setLectureCount(rs.getShort("LectureCount"));
                section.setCreationTime(rs.getTimestamp("CreationTime"));
                sections.add(section);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting sections for course: " + courseId, e);
        }
        
        return sections;
    }
    
    /**
     * Create section for a course
     */
    public boolean createSection(String courseId, String title, int index, String userId) {
        String sql = "INSERT INTO Sections (Id, CourseId, [Index], Title, LectureCount, " +
                     "CreationTime, LastModificationTime) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            String sectionId = UUID.randomUUID().toString();
            Timestamp now = new Timestamp(System.currentTimeMillis());
            
            ps.setString(1, sectionId);
            ps.setString(2, courseId);
            ps.setInt(3, index);
            ps.setString(4, title);
            ps.setShort(5, (short) 0);
            ps.setTimestamp(6, now);
            ps.setTimestamp(7, now);
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                LOGGER.log(Level.INFO, "Section created successfully: {0}", sectionId);
                return true;
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating section", e);
        }
        
        return false;
    }
    
    /**
     * Get course statistics for instructor dashboard
     */
    public CourseStatistics getCourseStatistics(String instructorId) {
        CourseStatistics stats = new CourseStatistics();
        String sql = "SELECT " +
                     "COUNT(*) as TotalCourses, " +
                     "SUM(LearnerCount) as TotalStudents, " +
                     "AVG(CAST(TotalRating as FLOAT) / NULLIF(RatingCount, 0)) as AverageRating " +
                     "FROM Courses WHERE InstructorId = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, instructorId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                stats.totalCourses = rs.getInt("TotalCourses");
                stats.totalStudents = rs.getInt("TotalStudents");
                stats.averageRating = rs.getDouble("AverageRating");
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting course statistics", e);
        }
        
        return stats;
    }
    
    /**
     * Map ResultSet to Course object
     */
    private Courses mapResultSetToCourse(ResultSet rs) throws SQLException {
        Courses course = new Courses();
        course.setId(rs.getString("Id"));
        course.setTitle(rs.getString("Title"));
        course.setMetaTitle(rs.getString("MetaTitle"));
        course.setThumbUrl(rs.getString("ThumbUrl"));
        course.setIntro(rs.getString("Intro"));
        course.setDescription(rs.getString("Description"));
        course.setStatus(rs.getString("Status"));
        course.setPrice(rs.getDouble("Price"));
        course.setDiscount(rs.getDouble("Discount"));
        course.setDiscountExpiry(rs.getTimestamp("DiscountExpiry"));
        course.setLevel(rs.getString("Level"));
        course.setOutcomes(rs.getString("Outcomes"));
        course.setRequirements(rs.getString("Requirements"));
        course.setLectureCount(rs.getShort("LectureCount"));
        course.setLearnerCount(rs.getInt("LearnerCount"));
        course.setRatingCount(rs.getInt("RatingCount"));
        course.setTotalRating(rs.getLong("TotalRating"));
        course.setCreationTime(rs.getTimestamp("CreationTime"));
        course.setLastModificationTime(rs.getTimestamp("LastModificationTime"));
        
        // Set category if available
        try {
            String categoryId = rs.getString("CategoryId");
            if (categoryId != null) {
                Categories category = new Categories();
                category.setId(categoryId);
                category.setTitle(rs.getString("CategoryTitle"));
                course.setLeafCategoryId(category);
            }
        } catch (SQLException e) {
            // Category columns might not be in result set
        }
        
        return course;
    }
    
    /**
     * Inner class for course statistics
     */
    public static class CourseStatistics {
        public int totalCourses;
        public int totalStudents;
        public double averageRating;
    }
}
